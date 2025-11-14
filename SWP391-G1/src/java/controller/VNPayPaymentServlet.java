/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
import model.User;
import model.Promotion;

/**
 * /
 *
 *
 * @author dotha
 */
@WebServlet(name = "VNPayPaymentServlet", urlPatterns = {"/VNPayPayment"})
public class VNPayPaymentServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet VNPayPaymentServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VNPayPaymentServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final String BANK_CODE = "VCB"; // Vietcombank
    private static final String ACCOUNT_NUMBER = "9325992848"; // Số tài khoản người nhận
    private static final String BANK_ACCOUNT = BANK_CODE + "-" + ACCOUNT_NUMBER;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu GET, có thể handle review hoặc redirect. Ở đây giữ redirect về MenuPage.
        response.sendRedirect("MenuPage");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("MenuPage?error=invalidAction");
            return;
        }

        if ("review".equalsIgnoreCase(action)) {
            // Parse totalAmount an toàn hơn
            double totalAmount = 0.0;
            try {
                Object totalObj = session.getAttribute("totalAmount");
                if (totalObj instanceof Double) {
                    totalAmount = (Double) totalObj;
                } else if (totalObj instanceof String) {
                    totalAmount = Double.parseDouble((String) totalObj);
                } else if (request.getParameter("total") != null) {
                    totalAmount = Double.parseDouble(request.getParameter("total"));
                }
                if (totalAmount <= 0) {
                    throw new IllegalArgumentException("Invalid amount");
                }
            } catch (Exception e) {
                response.sendRedirect("MenuPage?error=invalidAmount");
                return;
            }
            session.setAttribute("totalAmount", totalAmount); // Lưu lại dưới dạng Double

            // Sinh orderCode unique hơn (sử dụng UUID để tránh duplicate)
            String orderCode = (String) session.getAttribute("orderCode");
            if (orderCode == null) {
                orderCode = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                session.setAttribute("orderCode", orderCode);
            }

            // Tạo QR URL
            String addInfo = "ThanhToan_" + orderCode;
            long amountVND = Math.round(totalAmount);
            String qrUrl = "https://img.vietqr.io/image/" + BANK_ACCOUNT
                    + "-compact.png?amount=" + amountVND
                    + "&addInfo=" + addInfo;

            // Set attributes cho JSP
            request.setAttribute("orderCode", orderCode);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("qrUrl", qrUrl);
            // Set cartData từ session (giả sử lưu ở session)
            request.setAttribute("cartData", session.getAttribute("cartData"));

            // Tính totalPPoint từ cart và set vào session để JSP hiển thị
            String cartJson = (String) session.getAttribute("cartData");
            List<JSONObject> cartItems = new ArrayList<>();
            if (cartJson != null && cartJson.startsWith("[")) {
                JSONArray cartArray = new JSONArray(cartJson);
                for (int i = 0; i < cartArray.length(); i++) {
                    cartItems.add(cartArray.getJSONObject(i));
                }
            }
            try {
                MenuItemDAO itemDAO = new MenuItemDAO();
                double totalPPoint = 0;
                for (JSONObject item : cartItems) {
                    String name = item.optString("name", "").trim();
                    int qty = item.optInt("quantity", 0);
                    String size = item.optString("size", "").trim();
                    if (name.isEmpty() || qty <= 0) {
                        continue;
                    }
                    MenuItem mi = itemDAO.getItemByName(name);
                    if (mi == null) {
                        continue;
                    }
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
                session.setAttribute("totalPPoint", totalPPoint);
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("totalPPoint", 0.0); // Default nếu lỗi
            }

            request.getRequestDispatcher("VNPayPaymentPage.jsp").forward(request, response);
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
            if (promoCode == null) {
                promoCode = (String) session.getAttribute("appliedCode");
            }

            double totalAmount = 0;
            Object totalObj = session.getAttribute("totalAmount");
            if (totalObj instanceof Double) {
                totalAmount = (Double) totalObj;
            } else if (totalObj instanceof String) {
                try {
                    totalAmount = Double.parseDouble((String) totalObj);
                } catch (Exception ignored) {
                }
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

            User user = (User) session.getAttribute("account");
            String waiterID = user != null ? String.valueOf(user.getUserID()) : null;

            if (cartItems.isEmpty()) {
                response.sendRedirect("MenuPage?error=emptyCart");
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
                Promotion promo = promoCode != null ? promoDAO.getPromotionByCode(promoCode) : null;
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
                    try {
                        if (!size.isEmpty()) {
                            price = itemDAO.getPriceByItemAndSize(mi.getId(), size); // lấy giá theo size
                        } else {
                            // Nếu size rỗng, lấy giá mặc định (size Regular) của món
                            price = itemDAO.getPriceByItemAndSize(mi.getId(), size);
                        }
                    } catch (Exception e) {
                        System.err.println("Error getting price for item " + name + " size=" + size + " : " + e.getMessage());
                        price = 0;
                    }
                    // Insert order item
                    orderItemDAO.insertOrderItem(orderID, itemID, quantity, price);
                    recomputedTotal += price * quantity;
                    System.out.println("Inserted OrderItem: ItemID=" + itemID + " | Size=" + size + " | Quantity=" + quantity + " | Price=" + price);
                }

                // 4. Insert Payment
                String paymentID = "PM" + String.format("%08d", (int) (Math.random() * 100000000));
                paymentDAO.insertPayment(paymentID, orderID, totalAmount, "VNPay", "Pending");

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

                    if (name.isEmpty() || qty <= 0) {
                        continue;
                    }

                    MenuItem mi = itemDAO.getItemByName(name);
                    if (mi == null) {
                        continue;
                    }

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
                session.removeAttribute("totalPPoint");
                session.removeAttribute("appliedCode");
                session.removeAttribute("pendingPromotionCode");
                
                response.sendRedirect("MenuPage?success=1&order=" + orderCode);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("MenuPage?error=saveFailed");
                return;
            }
            // Về trang chủ
            response.sendRedirect("MenuPage?resetSession=true");
            return;
        }
        response.sendRedirect("MenuPage");
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý thanh toán VNPay (giả lập) và tạo QR code hiển thị cho người dùng";
    }
}
