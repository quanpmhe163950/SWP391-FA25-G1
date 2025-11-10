/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

/**
 *
 * @author ASUS
 */
public class EditInfoServlet extends HttpServlet {

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
            out.println("<title>Servlet EditInfoServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditInfoServlet at " + request.getContextPath() + "</h1>");
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
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            User customer = customerDAO.getCustomerById(id);
            request.setAttribute("customer", customer);
        }
        request.getRequestDispatcher("EditInfor.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        int id = Integer.parseInt(idStr);

        // Validate số điện thoại
        if (!phone.matches("\\d{10}")) {
            request.setAttribute("error", "Số điện thoại phải có đúng 10 chữ số.");
            User customer = new User();
            customer.setUserID(id);
            customer.setFullName(name);
            customer.setPhone(phone);
            customer.setEmail(email);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("EditInfor.jsp").forward(request, response);
            return;
        }

        User customer = new User();
        customer.setUserID(id);
        customer.setFullName(name);
        customer.setPhone(phone);
        customer.setEmail(email);

        boolean updated = customerDAO.updateCustomer(customer);
        if (updated) {
            response.sendRedirect("editinfo?id=" + customer.getUserID() + "&success=true");
        } else {
            request.setAttribute("error", "Cập nhật thất bại, vui lòng thử lại.");
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("EditInfor.jsp").forward(request, response);
        }
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
