/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.OrderHistoryDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.OrderHistory;
import model.User;

/**
 *
 * @author ASUS
 */
@WebServlet("/orderhistory")
public class OrderHistoryServlet extends HttpServlet {

    private final OrderHistoryDAO dao = new OrderHistoryDAO();

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

    System.out.println("=== [ORDERHISTORY] SERVLET ĐÃ ĐƯỢC GỌI!");

    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("account");

    if (user == null) {
    System.out.println("=== [ERROR] User chưa login → redirect");
    // response.sendRedirect("login.jsp");  <-- COMMENT TẠM ĐỂ TEST
    // Set user giả để test
    user = new User();
    user.setUserID(6);  // Giả userID = 6
    session.setAttribute("account", user);
}

    int userID = user.getUserID();
    System.out.println("=== [INFO] UserID = " + userID);

    try {
        List<OrderHistory> list = dao.getOrderHistoryByCustomer(userID);
        request.setAttribute("historyList", list);
        System.out.println("=== [INFO] Đã lấy " + list.size() + " đơn hàng");
    } catch (Exception e) {
        System.out.println("=== [LỖI DAO] " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("historyList", new ArrayList<>());
    }

    // BƯỚC QUAN TRỌNG: SET pageContent
    request.setAttribute("pageContent", "order-history.jsp");
    System.out.println("=== [DEBUG] pageContent = " + request.getAttribute("pageContent"));

    // FORWARD ĐÚNG ĐƯỜNG DẪN
    RequestDispatcher dispatcher = request.getRequestDispatcher("/CustomerPage.jsp");
    System.out.println("=== [FORWARD] Đang forward đến /CustomerPage.jsp");
    dispatcher.forward(request, response);
}
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}