/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dal.ItemDAO;
import dal.CategoryDAO;
import model.Item;
import model.ItemSizePrice;
import model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.*;

@WebServlet("/addItem")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddItemServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("addItem.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        ItemDAO itemDAO = new ItemDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        Map<String, String> errors = new HashMap<>();

        // ======== Lấy dữ liệu từ form ========
        String itemName = request.getParameter("itemName");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String categoryID_raw = request.getParameter("categoryID");

        // Các size & giá từ form 
        String[] sizes = request.getParameterValues("size");
        String[] prices = request.getParameterValues("price");

        int categoryID = 0;
        try {
            categoryID = Integer.parseInt(categoryID_raw);
        } catch (Exception e) {
            errors.put("categoryError", "Invalid category selected");
        }

        // ======== Kiểm tra hợp lệ ========
        if (itemName == null || itemName.trim().isEmpty()) {
            errors.put("itemNameError", "Item name is required");
        } else if (itemDAO.existsByName(itemName)) {
            errors.put("itemNameError", "Item name already exists");
        }

        if (sizes == null || sizes.length == 0 || prices == null || prices.length == 0) {
            errors.put("sizeError", "At least one size and price is required");
        }

        // ======== Upload ảnh ========
        Part filePart = request.getPart("image");
        String imageFileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            imageFileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + imageFileName);
        }

        // Nếu có lỗi nhập liệu → trả lại form
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("itemName", itemName);
            request.setAttribute("description", description);
            request.setAttribute("status", status);
            request.setAttribute("categoryID", categoryID_raw);
            request.setAttribute("categoryList", categoryDAO.getAllCategories());
            request.getRequestDispatcher("addItem.jsp").forward(request, response);
            return;
        }

        // ======== Tạo đối tượng Item ========
        Item item = new Item(itemName, description, categoryID, status,
                imageFileName != null ? "uploads/" + imageFileName : null);

        // ======== Thêm các size & giá ========
        List<ItemSizePrice> sizePriceList = new ArrayList<>();
        for (int i = 0; i < sizes.length; i++) {
            String size = sizes[i];
            double price = 0;
            try {
                price = Double.parseDouble(prices[i]);
            } catch (Exception e) {
                price = 0;
            }
            if (size != null && !size.trim().isEmpty()) {
                sizePriceList.add(new ItemSizePrice(0, 0, size.trim(), price, "Active"));
            }
        }
        item.setSizePriceList(sizePriceList);

        // ======== Thêm item vào DB ========
        boolean success = itemDAO.addItem(item);

        if (success) {
            // redirect về listItem.jsp kèm thông báo
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "✅ Item added successfully!");
            response.sendRedirect("listItem");
        } else {
            request.setAttribute("errorMessage", "❌ Failed to add item. Please try again.");
            request.setAttribute("categoryList", categoryDAO.getAllCategories());
            request.getRequestDispatcher("addItem.jsp").forward(request, response);
        }
    }
}
