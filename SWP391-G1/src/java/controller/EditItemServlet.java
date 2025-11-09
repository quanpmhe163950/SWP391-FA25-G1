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
import java.io.*;
import java.nio.file.Files;
import java.util.*;

@WebServlet(name = "EditItemServlet", urlPatterns = {"/editItem"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024,   // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class EditItemServlet extends HttpServlet {

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
            Item item = dao.getItemById(itemID);

            if (item == null) {
                request.getSession().setAttribute("errorMessage", "❌ Item not found!");
                response.sendRedirect("listItem");
            } else {
                request.setAttribute("item", item);
                request.getRequestDispatcher("editItem.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("listItem");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Map<String, String> errors = new HashMap<>();
        HttpSession session = request.getSession();

        try {
            String itemIDStr = request.getParameter("itemID");
            String name = request.getParameter("name");
            String status = request.getParameter("status");
            String description = request.getParameter("description"); // 🔹 Lấy mô tả

            if (itemIDStr == null || itemIDStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Missing item ID.");
                response.sendRedirect("listItem");
                return;
            }
            int itemID = Integer.parseInt(itemIDStr.trim());

            // Validate name
            String trimmedName = name == null ? "" : name.trim();
            if (trimmedName.isEmpty()) {
                errors.put("nameError", "Name cannot be empty.");
            } else if (!trimmedName.matches(".*[a-zA-Z].*")) {
                errors.put("nameError", "Name must contain at least one letter.");
            } else if (!trimmedName.matches("^[\\p{L}0-9\\s'\\-.,]+$")) {
                errors.put("nameError", "Name contains invalid characters.");
            }

            ItemDAO dao = new ItemDAO();
            Item existingItem = dao.getItemById(itemID);
            if (existingItem == null) {
                session.setAttribute("errorMessage", "Item not found.");
                response.sendRedirect("listItem");
                return;
            }

            int categoryID = existingItem.getCategoryID();
            String oldImagePath = existingItem.getImagePath();

            // Upload image (nếu có)
            Part filePart = request.getPart("image");
            String imagePath = oldImagePath;

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = new File(filePart.getSubmittedFileName()).getName();
                String uploadDir = getServletContext().getRealPath("/") + "uploads" + File.separator + "items";
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }

                String filePath = uploadDir + File.separator + fileName;
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, new File(filePath).toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                }
                imagePath = "uploads/items/" + fileName;
            }

            // Lấy size & price
            String[] sizeNames = request.getParameterValues("sizeName");
            String[] sizePrices = request.getParameterValues("sizePrice");
            Map<String, Double> sizePriceMap = new LinkedHashMap<>();

            if (sizeNames != null && sizePrices != null && sizeNames.length == sizePrices.length) {
                Set<String> sizeCheckSet = new HashSet<>(); // để phát hiện trùng tên size
                for (int i = 0; i < sizeNames.length; i++) {
                    String size = sizeNames[i].trim();
                    if (!size.isEmpty()) {
                        String normalized = size.toLowerCase();
                        if (sizeCheckSet.contains(normalized)) {
                            errors.put("sizeError", "Duplicate size name detected: \"" + size + "\"");
                            break;
                        }
                        sizeCheckSet.add(normalized);

                        try {
                            double price = Double.parseDouble(sizePrices[i]);
                            sizePriceMap.put(size, price);
                        } catch (NumberFormatException e) {
                            errors.put("priceError", "Invalid price format for size: " + size);
                        }
                    }
                }
            }

            // Nếu có lỗi => quay lại form edit, giữ lại dữ liệu người nhập
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("item", existingItem);
                request.setAttribute("name", name);
                request.setAttribute("status", status);
                request.setAttribute("description", description);
                request.getRequestDispatcher("editItem.jsp").forward(request, response);
                return;
            }

            // Cập nhật item
            Item updatedItem = new Item();
            updatedItem.setItemID(itemID);
            updatedItem.setName(name.trim());
            updatedItem.setDescription(description == null ? "" : description.trim()); // 🔹 Lưu mô tả
            updatedItem.setCategoryID(categoryID);
            updatedItem.setStatus(status);
            updatedItem.setImagePath(imagePath);

            boolean updated = dao.updateItem(updatedItem, sizePriceMap);

            if (updated) {
                session.setAttribute("successMessage", "✅ Item [" + updatedItem.getName() + "] updated successfully!");
            } else {
                session.setAttribute("errorMessage", "❌ Failed to update item!");
            }

            response.sendRedirect("listItem");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            response.sendRedirect("listItem");
        }
    }
}
