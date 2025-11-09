/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AddCategoryServlet", urlPatterns = {"/addCategory"})
public class AddCategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("addCategory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        Map<String, String> errors = new HashMap<>();

        // Validate từng trường
        if (categoryName == null || categoryName.trim().isEmpty()) {
            errors.put("categoryNameError", "Category name cannot be empty.");
        } else if (categoryName.trim().matches("\\d+")) {
            errors.put("categoryNameError", "Category name cannot be only numbers.");
        } else if (categoryDAO.isCategoryNameExist(categoryName.trim())) {
            errors.put("categoryNameError", "Category '" + categoryName.trim() + "' already exists!");
        }

        // Nếu có lỗi → trả lại form với dữ liệu và lỗi
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("categoryName", categoryName);
            request.setAttribute("description", description);
            request.setAttribute("status", status);
            request.getRequestDispatcher("addCategory.jsp").forward(request, response);
            return;
        }

        // Nếu không có lỗi → thêm vào DB
        try {
            boolean isAdded = categoryDAO.addCategory(categoryName.trim(), description.trim(), status);
            if (isAdded) {
                request.setAttribute("successMessage", "✅ Category [" + categoryName + "] added successfully!");
                response.sendRedirect("addCategory?message=success");
            } else {
                request.setAttribute("errorMessage", "❌ Failed to add category to database.");
                request.getRequestDispatcher("addCategory.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            request.getRequestDispatcher("addCategory.jsp").forward(request, response);
        }
    }
}