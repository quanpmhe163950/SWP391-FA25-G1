/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderHistoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.OrderHistory;
import model.User;

/**
 *
 * @author ASUS
 */
public class OderHistoryServlet extends HttpServlet {

    private OrderHistoryDAO dao = new OrderHistoryDAO();

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
            out.println("<title>Servlet OderHistoryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OderHistoryServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    System.out.println("=== [HISTORY] Servlet được gọi");

    try {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userID = user.getUserID();
        System.out.println("=== [HISTORY] UserID = " + userID);

        // DAO có thể throws SQLException → BẮT Ở ĐÂY
        List<OrderHistory> list = dao.getOrderHistoryByCustomer(userID);

        request.setAttribute("historyList", list);
        request.setAttribute("pageContent", "order-history.jsp");
        request.getRequestDispatcher("CustomerPage.jsp").forward(request, response);

    } catch (SQLException e) {
        System.out.println("=== [LỖI SQL] " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("errorMessage", "Không thể tải lịch sử mua hàng.");
        request.setAttribute("pageContent", "order-history.jsp");
        request.getRequestDispatcher("CustomerPage.jsp").forward(request, response);
    } catch (Exception e) {
        System.out.println("=== [LỖI KHÁC] " + e.getMessage());
        e.printStackTrace();
    }
}

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
