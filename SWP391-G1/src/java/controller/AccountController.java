package controller;

import dal.AccountDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/account")
public class AccountController extends HttpServlet {

    private AccountDAO dao = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            default: // ✅ Danh sách Customer + tìm theo số điện thoại
                String phone = request.getParameter("phone");
                List<User> list = dao.getAllCustomers(phone);
                request.setAttribute("list", list);
                request.getRequestDispatcher("/admin/account_list.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // ✅ Chỉ còn toggleActive
        if ("toggleActive".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                boolean active = "1".equals(request.getParameter("active"));
                dao.setActive(userId, active);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/admin/account");
            return;
        }

        // fallback
        response.sendRedirect(request.getContextPath() + "/admin/account");
    }
}
