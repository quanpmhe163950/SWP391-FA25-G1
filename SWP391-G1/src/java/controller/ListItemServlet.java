/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ItemDAO;
import model.Item;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "ListItemServlet", urlPatterns = {"/listItem"})
public class ListItemServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        // 🟢 Lấy thông báo từ session (do servlet khác set)
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");

        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("errorMessage");
        }

        // Lấy thông báo từ URL (ví dụ sau khi thêm mới)
        String message = request.getParameter("message");
        String itemName = request.getParameter("item");
        if ("success".equals(message) && itemName != null && !itemName.trim().isEmpty()) {
            request.setAttribute("successMessage", "✅ Item [" + itemName + "] added successfully!");
        }

        // Gọi DAO
        ItemDAO dao = new ItemDAO();
        Map<Integer, String> availableCategoryMap = new HashMap<>();
        Map<Integer, String> unavailableCategoryMap = new HashMap<>();

        List<Item> availableItems = dao.getItemsByStatus("Available", availableCategoryMap);
        List<Item> unavailableItems = dao.getItemsByStatus("Unavailable", unavailableCategoryMap);

        request.setAttribute("availableItems", availableItems);
        request.setAttribute("unavailableItems", unavailableItems);
        request.setAttribute("availableCategoryMap", availableCategoryMap);
        request.setAttribute("unavailableCategoryMap", unavailableCategoryMap);

        RequestDispatcher dispatcher = request.getRequestDispatcher("listItem.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}