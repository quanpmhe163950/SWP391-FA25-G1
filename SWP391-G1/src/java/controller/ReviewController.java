/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ReviewDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Review;
import model.User;

/**
 *
 * @author ASUS
 */
public class ReviewController extends HttpServlet {

    private final ReviewDAO dao = new ReviewDAO();

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
            out.println("<title>Servlet ReviewController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReviewController at " + request.getContextPath() + "</h1>");
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

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account"); // LẤY USER

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int customerID = user.getUserID(); // SỬA DÒNG 63

        String itemIDStr = request.getParameter("itemID");
        if (itemIDStr == null || itemIDStr.isEmpty()) {
            request.setAttribute("error", "Thiếu sản phẩm");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        int itemID = Integer.parseInt(itemIDStr);
        Review review = dao.getReview(customerID, itemID);

        request.setAttribute("review", review);
        request.getRequestDispatcher("ReviewForm.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int customerID = user.getUserID();

        String itemIDStr = request.getParameter("itemID");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (itemIDStr == null || ratingStr == null) {
            request.setAttribute("error", "Dữ liệu không hợp lệ");
            request.getRequestDispatcher("ReviewForm.jsp").forward(request, response);
            return;
        }

        int itemID = Integer.parseInt(itemIDStr);
        int rating = Integer.parseInt(ratingStr);
        if (rating < 1 || rating > 5) {
            rating = 5;
        }
        if (comment == null) {
            comment = "";
        }

        Review existing = dao.getReview(customerID, itemID);
        if (existing == null) {
            dao.insertReview(customerID, itemID, rating, comment);
        } else {
            dao.updateReview(existing.getReviewID(), rating, comment);
        }

        response.sendRedirect("orderhistory");
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
