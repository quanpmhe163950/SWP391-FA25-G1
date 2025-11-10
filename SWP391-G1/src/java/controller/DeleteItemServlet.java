/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ItemDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "DeleteItemServlet", urlPatterns = {"/deleteItem"})
public class DeleteItemServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemIDStr = request.getParameter("itemID");
        if (itemIDStr == null) {
            response.sendRedirect("listItem");
            return;
        }

        try {
            int itemID = Integer.parseInt(itemIDStr);
            ItemDAO dao = new ItemDAO();

            boolean success = dao.softDeleteItem(itemID);

            if (success) {
                request.getSession().setAttribute("successMessage", "🗑️ Item moved to Unavailable list successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "❌ Failed to update item status!");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid item ID!");
        }

        response.sendRedirect("listItem");
    }
}
