/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "DeleteCategoryServlet", urlPatterns = {"/deleteCategory"})
public class DeleteCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryIDStr = request.getParameter("categoryID");
        if (categoryIDStr == null) {
            response.sendRedirect("listCategory");
            return;
        }

        try {
            int categoryID = Integer.parseInt(categoryIDStr);
            CategoryDAO dao = new CategoryDAO();

            boolean success = dao.softDeleteCategory(categoryID);

            if (success) {
                request.getSession().setAttribute("successMessage", "🗑️ Category moved to Unavailable list successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "❌ Failed to update category status!");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid category ID!");
        }

        response.sendRedirect("listCategory");
    }
}