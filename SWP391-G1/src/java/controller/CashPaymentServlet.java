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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
                try {
                    totalAmount = Double.parseDouble((String) totalObj);
                } catch (Exception ignore) {
                    totalAmount = 0;
                }
            }

            try {
                String totalParam = request.getParameter("total");
                if (totalParam != null) totalAmount = Double.parseDouble(totalParam);
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

            double totalAmount = 0;
            Object totalObj = session.getAttribute("totalAmount");
            if (totalObj instanceof Double) totalAmount = (Double) totalObj;
            else if (totalObj instanceof String) {
                try { totalAmount = Double.parseDouble((String) totalObj); } catch (Exception ignored) {}
            }

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
                String promoID = promo != null ? String.valueOf(promo.getPromoId()) : null;

                // 2. Insert Order
                int orderID = orderDAO.insertOrder(orderCode, customerID, waiterID, "Completed", promoID);

                // 3. Insert OrderItems từ cart (lấy giá theo size nếu có)
                double recomputedTotal = 0; // (optional) để kiểm tra khớp với client
                for (JSONObject cartItem : cartItems) {
                    String name = cartItem.optString("name", "").trim();
                    int quantity = cartItem.optInt("quantity", 0);
                    String size = cartItem.optString("size", "").trim(); // có thể rỗng

                    if (name.isEmpty() || quantity <= 0) {
                        System.out.println("Warning: invalid cart item, skipping. name=" + name + " qty=" + quantity);
                        continue;
                    }

                    MenuItem mi = itemDAO.getItemByName(name);
                    if (mi == null) {
                        System.out.println("Warning: Item '" + name + "' not found in DB, skipping...");
                        continue;
                    }

                    String itemID = String.valueOf(mi.getId());
                    double price = 0;

                    // Lấy giá theo size nếu có phương thức DAO cung cấp
                    try {
                        if (!size.isEmpty()) {
                            // đòi hỏi MenuItemDAO có getPriceByItemAndSize(int, String)
                            price = itemDAO.getPriceByItemAndSize(mi.getId(), size);
                        } 

                        // fallback: nếu price vẫn 0 thì thử dùng mi.getPrice() nếu tồn tại
                        if (price <= 0) {
                            try {
                                price = mi.getPrice(); // nếu model còn field price
                            } catch (Exception ignore) {
                                price = 0;
                            }
                        }
                    } catch (Exception e) {
                        // không muốn fail toàn bộ đơn vì 1 món
                        System.err.println("Error getting price for item " + name + " size=" + size + " : " + e.getMessage());
                        price = 0;
                    }

                    // Insert order item
                    orderItemDAO.insertOrderItem(orderID, itemID, quantity, price);

                    recomputedTotal += price * quantity;
                    System.out.println("Inserted OrderItem: ItemID=" + itemID + " | Size=" + size + " | Quantity=" + quantity + " | Price=" + price);
                }

                // 4. Insert Payment
                String paymentID = "PM" + String.format("%08d", (int)(Math.random() * 100000000));
                paymentDAO.insertPayment(paymentID, orderID, totalAmount, "Cash", "Completed");

                // 5. Xử lý Voucher
                if (promoCode != null && orderCode != null) {
                    promoDAO.markPromotionUsedIfAbsent(orderCode, promoCode, customerID);
                }

                // 6. Tính PPoint và lưu (dùng giá thực tế lấy từ DB theo size)
                double totalPPoint = 0;
                for (JSONObject item : cartItems) {
                    String name = item.optString("name", "").trim();
                    int qty = item.optInt("quantity", 0);
                    String size = item.optString("size", "").trim();

                    if (name.isEmpty() || qty <= 0) continue;

                    MenuItem mi = itemDAO.getItemByName(name);
                    if (mi == null) continue;

                    double price = 0;
                    try {
                        if (!size.isEmpty()) {
                            price = itemDAO.getPriceByItemAndSize(mi.getId(), size);
                        }

                    } catch (Exception e) {
                        price = 0;
                    }

                    totalPPoint += qty * price * 0.005;
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
