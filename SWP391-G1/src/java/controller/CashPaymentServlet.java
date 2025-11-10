package controller;

import dal.MenuItemDAO;
import dal.OrderDAO;
import dal.OrderItemDAO;
import dal.PaymentDAO;
import dal.PromotionDAO;
import dal.LoyaltyDAO;
import dal.UsersDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import org.json.JSONArray;
import org.json.JSONObject;
import model.MenuItem;

/**
 * Servlet xử lý thanh toán tiền mặt
 */
@WebServlet(name = "CashPaymentServlet", urlPatterns = {"/CashPayment"})
public class CashPaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("orderCode") == null) {
            response.sendRedirect("HomePage");
            return;
        }

        String totalParam = request.getParameter("total");
        double totalAmount = 0;
        if (totalParam != null && !totalParam.isEmpty()) {
            try {
                totalAmount = Double.parseDouble(totalParam);
            } catch (NumberFormatException e) {
                totalAmount = 0;
            }
        }

        session.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("CashPaymentPage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        String action = request.getParameter("action");

        if ("review".equalsIgnoreCase(action)) {
            // Hiển thị cart review
            Object totalObj = session.getAttribute("totalAmount");
            double totalAmount = 0;
            if (totalObj instanceof Double) {
                totalAmount = (Double) totalObj;
            } else if (totalObj instanceof String) {
                totalAmount = Double.parseDouble((String) totalObj);
            }

            try {
                totalAmount = Double.parseDouble(request.getParameter("total"));
            } catch (Exception ignore) {}

            session.setAttribute("totalAmount", totalAmount);
            Object cartData = session.getAttribute("cartData");
            if (cartData != null) {
                request.setAttribute("cartData", cartData);
            }
            request.getRequestDispatcher("CashPaymentPage.jsp").forward(request, response);
            return;
        }

        if ("confirm".equalsIgnoreCase(action)) {
            // Lấy orderCode
            String orderCode = (String) session.getAttribute("orderCode");
            if (orderCode == null || orderCode.trim().isEmpty()) {
                orderCode = "ORD" + System.currentTimeMillis();
                session.setAttribute("orderCode", orderCode);
            }

            String promoCode = (String) session.getAttribute("pendingPromotionCode");
            if (promoCode == null) promoCode = (String) session.getAttribute("appliedCode");

            double totalAmount = session.getAttribute("totalAmount") != null ? (double) session.getAttribute("totalAmount") : 0;
            String cartJson = (String) session.getAttribute("cartData");

            List<JSONObject> cartItems = new ArrayList<>();
            if (cartJson != null && cartJson.startsWith("[")) {
                JSONArray cartArray = new JSONArray(cartJson);
                for (int i = 0; i < cartArray.length(); i++) {
                    cartItems.add(cartArray.getJSONObject(i));
                }
            }

            String phone = request.getParameter("phone");
            UsersDAO userDAO = new UsersDAO();
            String customerID = (phone != null && !phone.trim().isEmpty()) ? userDAO.getUserIDByPhone(phone) : null;
            String waiterID = (String) session.getAttribute("userID");

            if (cartItems.isEmpty()) {
                response.sendRedirect("HomePage?error=emptyCart");
                return;
            }

            try {
                MenuItemDAO itemDAO = new MenuItemDAO();
                OrderDAO orderDAO = new OrderDAO();
                OrderItemDAO orderItemDAO = new OrderItemDAO();
                PaymentDAO paymentDAO = new PaymentDAO();
                PromotionDAO promoDAO = new PromotionDAO();
                LoyaltyDAO loyaltyDAO = new LoyaltyDAO();

                // 1. Lấy PromoID nếu có promoCode
                model.Promotion promo = promoCode != null ? promoDAO.getPromotionByCode(promoCode) : null;
                String promoID = promo != null ? promo.getPromoID() : null;

                // 2. Insert Order
                int orderID = orderDAO.insertOrder(orderCode, customerID, waiterID, "Completed", promoID);

                // 3. Insert OrderItems từ cart (lấy giá và ItemID từ DB, quantity từ cart)
                for (JSONObject cartItem : cartItems) {
                    String name = cartItem.getString("name").trim();
                    int quantity = cartItem.getInt("quantity");

                    MenuItem mi = itemDAO.getItemByName(name);
                    if (mi == null) {
                        System.out.println("Warning: Item '" + name + "' not found in DB, skipping...");
                        continue;
                    }

                    String itemID = mi.getId();
                    double price = mi.getPrice();

                    orderItemDAO.insertOrderItem(orderID, itemID, quantity, price);
                    System.out.println("Inserted OrderItem: " + " | ItemID: " + itemID + " | Quantity: " + quantity + " | Price: " + price);
                }

                // 4. Insert Payment
                String paymentID = "PM" + String.format("%08d", (int)(Math.random() * 100000000));
                paymentDAO.insertPayment(paymentID, orderID, totalAmount, "Cash", "Completed");

                // 5. Xử lý Voucher
                if (promoCode != null && orderCode != null) {
                    promoDAO.markPromotionUsedIfAbsent(orderCode, promoCode, customerID);
                }

                // 6. Tính PPoint và lưu
                double totalPPoint = 0;
                for (JSONObject item : cartItems) {
                    int qty = item.getInt("quantity");
                    totalPPoint += qty * itemDAO.getItemByName(item.getString("name")).getPrice() * 0.005;
                }
                if (customerID != null) {
                    loyaltyDAO.updatePointsAndProgram(customerID, totalPPoint);
                }

                // 7. Dọn session
                session.removeAttribute("cartData");
                session.removeAttribute("totalAmount");
                session.removeAttribute("orderCode");
                session.removeAttribute("discountType");
                session.removeAttribute("discountValue");

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("HomePage?error=saveFailed");
                return;
            }

            // Về trang chủ
            response.sendRedirect("HomePage?resetSession=true");
            return;
        }

        response.sendRedirect("HomePage");
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý thanh toán tiền mặt";
    }
}
