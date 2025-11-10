/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import model.Category;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "EditCategoryServlet", urlPatterns = {"/editCategory"})
public class EditCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryIDStr = request.getParameter("categoryID");
        if (categoryIDStr == null) {
            response.sendRedirect("listCategory"); // về trang danh sách nếu thiếu id
            return;
        }

        try {
            int categoryID = Integer.parseInt(categoryIDStr);
            CategoryDAO dao = new CategoryDAO();
            Category category = dao.getCategoryById(categoryID); // lấy dữ liệu từ DB

            if (category == null) {
                request.setAttribute("errorMessage", "Category not found!");
                request.getRequestDispatcher("listCategory").forward(request, response);
            } else {
                request.setAttribute("category", category);
                request.getRequestDispatcher("editCategory.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("listCategory");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int categoryID = Integer.parseInt(request.getParameter("categoryID"));
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        CategoryDAO dao = new CategoryDAO();
        boolean updated = dao.updateCategory(new Category(categoryID, categoryName, description, status));

        if (updated) {
            request.setAttribute("successMessage", "Category updated successfully!");
        } else {
            request.setAttribute("errorMessage", "Update failed!");
        }
        HttpSession session = request.getSession();
        if (updated) {
            session.setAttribute("message", "✅ Category updated successfully!");
        } else {
            session.setAttribute("message", "❌ Update failed. Please try again!");
        }

        response.sendRedirect("listCategory");
    }
}
