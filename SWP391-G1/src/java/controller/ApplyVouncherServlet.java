/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.PromotionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Promotion;

/**
 *
 * @author dotha
 */
@WebServlet(name = "ApplyVouncherServlet", urlPatterns = {"/ApplyVouncher"})
public class ApplyVouncherServlet extends HttpServlet {

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
            out.println("<title>Servlet ApplyVouncherServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ApplyVouncherServlet at " + request.getContextPath() + "</h1>");
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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        // Chuẩn hoá mã nhập
        String raw = request.getParameter("voucherCode");
        String code = (raw == null) ? "" : raw.trim();
        // Nếu muốn không phân biệt hoa-thường nhưng code trong DB là hoa: code = code.toUpperCase();

        PromotionDAO promoDAO = new PromotionDAO();
        Promotion promo = (code.isEmpty()) ? null : promoDAO.getPromotionByCode(code);

        // ✅ Giữ lại giỏ hàng nếu có (để render lại HomePage)
        String cartJson = request.getParameter("cartJson");
        if (cartJson != null && !cartJson.trim().isEmpty()) {
            session.setAttribute("cartData", cartJson);
        } else if (session.getAttribute("cartData") == null) {
            session.setAttribute("cartData", "[]");
        }

        // ✅ Bảo đảm có orderCode để gắn vào phiên
        String orderCode = (String) session.getAttribute("orderCode");
        if (orderCode == null || orderCode.trim().isEmpty()) {
            orderCode = "ORD" + System.currentTimeMillis();
            session.setAttribute("orderCode", orderCode);
        }

        String message;
        String color;

        if (promo == null) {
            message = "Mã giảm giá không tồn tại!";
            color = "red";
        } else if (!"Active".equalsIgnoreCase(promo.getStatus())) {
            message = "Mã giảm giá đã hết hạn hoặc không khả dụng!";
            color = "orange";
        } // ❗ KHÔNG kiểm tra hasUsedPromotion ở đây, vì chỉ ghi DB ở bước confirm.
        // else if (promoDAO.hasUsedPromotion(orderCode, code)) {
        //     message = "Mỗi đơn hàng chỉ được sử dụng một lần cho mã khuyến mãi này!";
        //     color = "red";
        // }
        else {
            // Hợp lệ: lưu vào session ở dạng "tạm thời"
            message = "Áp dụng thành công mã: " + promo.getCode() + " ("
                    + (promo.getDiscountType().equalsIgnoreCase("PERCENT")
                    ? promo.getValue() + "% giảm"
                    : promo.getValue() + " VNĐ giảm")
                    + ")";
            color = "green";

            // Chuẩn hoá kiểu dữ liệu cho phía JS (tránh BigDecimal => chuỗi lạ)
            session.setAttribute("discountType", promo.getDiscountType());                 // "PERCENT" | "FIXED"
            session.setAttribute("discountValue", promo.getValue() != null
                    ? promo.getValue().doubleValue() : 0.0);                               // số thuần

            // Hiển thị code đang áp dụng
            session.setAttribute("appliedCode", promo.getCode());

            // Đánh dấu "chờ xác nhận" — chỉ khi confirm thanh toán mới ghi DB
            session.setAttribute("pendingPromotionCode", code);
        }

        // Thông báo ra HomePage
        session.setAttribute("voucherMessage", message);
        session.setAttribute("voucherColor", color);

        // Quay lại HomePage để render lại tổng tiền với discount tạm thời
        response.sendRedirect(response.encodeRedirectURL("HomePage?fromVoucher=true"));
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý áp dụng voucher từ Database (đã fix giữ giỏ hàng)";
    }
}
