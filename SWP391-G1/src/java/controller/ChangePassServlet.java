/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.PasswordUtil;

/**
 *
 * @author ASUS
 */
@WebServlet("/changepass")
public class ChangePassServlet extends HttpServlet {

    private final CustomerDAO dao = new CustomerDAO();

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
            out.println("<title>Servlet ChangePassServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePassServlet at " + request.getContextPath() + "</h1>");
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
        if (!isLoggedIn(request, response)) return;

        request.setAttribute("pageContent", "ChangePassword.jsp");
        request.getRequestDispatcher("CustomerPage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request, response)) return;

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        String username = user.getUsername();

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // ===== Validate =====
        if (isEmpty(currentPassword) || isEmpty(newPassword) || isEmpty(confirmPassword)) {
            setError(request, "Vui lòng nhập đầy đủ thông tin!");
            forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            setError(request, "Mật khẩu mới và xác nhận không khớp!");
            forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            setError(request, "Mật khẩu mới phải có ít nhất 6 ký tự!");
            forward(request, response);
            return;
        }

        // ===== Kiểm tra mật khẩu hiện tại =====
        User dbUser = dao.getUserByUsername(username); // Hàm lấy user từ DB
        if (dbUser == null || !PasswordUtil.checkPassword(currentPassword, dbUser.getPasswordHash())) {
            setError(request, "Mật khẩu hiện tại không đúng!");
            forward(request, response);
            return;
        }

        // ===== Hash mật khẩu mới và update =====
        String hashedNewPassword = PasswordUtil.hashPassword(newPassword);
        if (dao.updatePassword(username, hashedNewPassword)) {
            setSuccess(request, "Đổi mật khẩu thành công!");
        } else {
            setError(request, "Có lỗi xảy ra, vui lòng thử lại!");
        }

        forward(request, response);
    }

    // ================= Hỗ trợ =================

    private boolean isLoggedIn(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            res.sendRedirect("login.jsp");
            return false;
        }
        return true;
    }

    private void setError(HttpServletRequest req, String message) {
        req.setAttribute("error", message);
    }

    private void setSuccess(HttpServletRequest req, String message) {
        req.setAttribute("success", message);
    }

    private void forward(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setAttribute("pageContent", "ChangePassword.jsp");
        req.getRequestDispatcher("CustomerPage.jsp").forward(req, res);
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
