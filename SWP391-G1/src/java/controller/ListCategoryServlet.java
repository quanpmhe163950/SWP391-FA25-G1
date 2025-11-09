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
import java.util.List;

@WebServlet(name = "ListCategoryServlet", urlPatterns = {"/listCategory"})
public class ListCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CategoryDAO dao = new CategoryDAO();

        List<Category> availableList = dao.getCategoriesByStatus("Available");
        List<Category> unavailableList = dao.getCategoriesByStatus("Unavailable");

        request.setAttribute("availableCategories", availableList);
        request.setAttribute("unavailableCategories", unavailableList);

        request.getRequestDispatcher("listCategory.jsp").forward(request, response);
    }
}
