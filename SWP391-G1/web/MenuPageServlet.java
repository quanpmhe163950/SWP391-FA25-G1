package controller;

import dal.ItemSizePriceDAO;
import dal.PromotionDAO;
import dal.CategoryDAO; // ✅ Thêm import này
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;
import model.MenuItem;
import model.ItemSizePrice;
import model.Promotion;
import model.Category; // ✅ Thêm import này
import java.util.concurrent.ThreadLocalRandom;

@WebServlet(name = "MenuPageServlet", urlPatterns = {"/MenuPage"})
public class MenuPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ✅ Nếu user vừa thanh toán → reset toàn bộ session
        String resetSession = request.getParameter("resetSession");
        if ("true".equals(resetSession)) {
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("orderCode", generateOrderCode());
            response.sendRedirect("MenuPage");
            return;
        }

        HttpSession session;
        boolean fromPayment = "true".equals(request.getParameter("fromPayment"));
        if (fromPayment) {
            session = request.getSession(false);
            if (session == null) {
                response.sendRedirect("MenuPage?resetSession=true");
                return;
            }
        } else {
            session = request.getSession(true);
        }

        // ✅ Nếu người dùng bấm "Hủy mã giảm giá"
        if ("true".equals(request.getParameter("resetVoucher"))) {
            session.removeAttribute("discountType");
            session.removeAttribute("discountValue");
            session.removeAttribute("appliedCode");
            session.removeAttribute("voucherMessage");
            session.removeAttribute("voucherColor");
            session.removeAttribute("pendingPromotionCode");
            response.sendRedirect("MenuPage");
            return;
        }

        // --- Lấy dữ liệu menu theo món + size + giá ---
        ItemSizePriceDAO dao = new ItemSizePriceDAO();
        Map<MenuItem, List<ItemSizePrice>> menuWithSizes = dao.getMenuWithSizes();
        request.setAttribute("menuWithSizes", menuWithSizes);

        // --- Phần khuyến mãi ---
        int page = 1, pageSize = 5;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        PromotionDAO promoDAO = new PromotionDAO();
        List<Promotion> activePromotions = promoDAO.getActivePromotionsPaging(page, pageSize);
        int totalPromotions = promoDAO.getTotalActivePromotions();
        int totalPages = (int) Math.ceil((double) totalPromotions / pageSize);
        request.setAttribute("activePromotions", activePromotions);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // --- Lấy danh sách category ---
CategoryDAO categoryDAO = new CategoryDAO();
List<Category> categoryList = categoryDAO.getAllCategories();
request.setAttribute("categoryList", categoryList);

        // 🔹 Mã đơn hàng nếu chưa có
        if (session.getAttribute("orderCode") == null) {
            session.setAttribute("orderCode", generateOrderCode());
        }

        boolean fromVoucher = "true".equals(request.getParameter("fromVoucher"));
        // ✅ Luôn set discount từ session nếu có
        if (session.getAttribute("discountType") != null && session.getAttribute("discountValue") != null) {
            request.setAttribute("discountType", session.getAttribute("discountType"));
            request.setAttribute("discountValue", session.getAttribute("discountValue"));
        }
        if (session.getAttribute("voucherMessage") != null) {
            request.setAttribute("voucherMessage", session.getAttribute("voucherMessage"));
            request.setAttribute("voucherColor", session.getAttribute("voucherColor"));
        } else if (!fromVoucher && !fromPayment) {
            session.removeAttribute("voucherMessage");
            session.removeAttribute("voucherColor");
        }

        // ✅ Giữ lại giỏ hàng khi quay lại
        Object cartData = session.getAttribute("cartData");
        if (cartData != null) {
            request.setAttribute("cartData", cartData);
        }

        // ✅ Chuyển sang JSP
        request.getRequestDispatcher("MenuPage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String generateOrderCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 16; i++) {
            sb.append(chars.charAt(ThreadLocalRandom.current().nextInt(chars.length())));
        }
        return sb.toString();
    }
}
