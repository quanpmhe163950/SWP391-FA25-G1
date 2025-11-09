<%-- 
    Document   : addItem.jsp
    Created on : Oct 10, 2025, 3:33:32 PM
    Author     : admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="model.Category"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pizza Shop - Add Item</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                height: 100vh; /* Chiều cao toàn màn hình */
                display: flex;
                justify-content: center; /* Căn giữa ngang */
                align-items: center;     /* Căn giữa dọc */
                background-color: #f5f5f5;
            }
            .form-container {
                background-color: #f9f9f9;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 25px 30px;
                width: 500px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            h2 {
                color: #333;
                margin-top: 0;
            }
            label {
                font-weight: bold;
                display: block;
                margin-top: 10px;
            }
            input[type=text],
            input[type=number],
            select,
            textarea {
                width: 100%;
                padding: 8px;
                margin-top: 5px;
                margin-bottom: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 14px;
            }
            textarea {
                resize: none; /* Không cho kéo */
                height: 120px; /* Cố định chiều cao */
            }
            .btn-submit {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 10px 18px;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
            }
            .btn-submit:hover {
                background-color: #0056b3;
            }
            .error-global {
                color: red;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .success {
                color: green;
                font-weight: bold;
                margin-bottom: 10px;
            }
            .error {
                color: red;
                font-size: 20px;
            }
            .size-row {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 8px;
            }

            .size-row input {
                flex: 1;
            }

            .btn-add {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 6px 10px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
            }

            .btn-add:hover {
                background-color: #218838;
            }

            .btn-remove {
                background-color: #dc3545;
                color: white;
                border: none;
                padding: 4px 8px;
                border-radius: 4px;
                cursor: pointer;
            }

            .btn-remove:hover {
                background-color: #c82333;
            }

        </style>
    </head>

    <body>

        <div class="form-container">
            <h2>Add New Item</h2>

            <%-- Hiển thị thông báo tổng thể --%>
            <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="error-global"><%= request.getAttribute("errorMessage") %></p>
            <% } %>

            <% if (request.getAttribute("successMessage") != null) { %>
            <p class="success"><%= request.getAttribute("successMessage") %></p>
            <% } %>

            <%
                Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
                String itemName = (String) request.getAttribute("itemName");
                String description = (String) request.getAttribute("description");
                String status = (String) request.getAttribute("status");

                String categoryID = null;
                // ✅ Thêm logic tự động lấy categoryID từ URL nếu có
                if (request.getAttribute("categoryID") != null) {
                    categoryID = (String) request.getAttribute("categoryID");
                } else if (request.getParameter("categoryID") != null) {
                    categoryID = request.getParameter("categoryID");
                }

                List<Category> categoryList = (List<Category>) request.getAttribute("categoryList");
            %>

            <form action="addItem" method="POST" enctype="multipart/form-data">

                <%-- Item Name --%>
                <label for="itemName">Item name:</label><br>
                <input type="text" id="itemName" name="itemName" 
                       value="<%= itemName != null ? itemName : "" %>" required>
                <span class="error"><%= (errors != null && errors.get("itemNameError") != null) ? errors.get("itemNameError") : "" %></span>
                <br>

                <%-- Description --%>
                <label for="description">Description:</label><br>
                <textarea id="description" name="description" rows="3"><%= description != null ? description : "" %></textarea>
                <br>

                <%-- Category --%>
                <label for="categoryID">Category:</label><br>
                <select id="categoryID" name="categoryID" required>
                    <option value="">-- Select Category --</option>
                    <%
                        if (categoryList != null) {
                            for (Category category : categoryList) {
                                boolean selected = (categoryID != null && categoryID.equals(String.valueOf(category.getCategoryID())));
                    %>
                    <option value="<%= category.getCategoryID() %>" <%= selected ? "selected" : "" %>>
                        <%= category.getCategoryName() %>
                    </option>
                    <%
                            }
                        }
                    %>
                </select>
                <span class="error"><%= (errors != null && errors.get("categoryError") != null) ? errors.get("categoryError") : "" %></span>
                <br>

                <%-- Sizes & Prices --%>
                <h3>Size & Price</h3>
                <div id="sizes-container">
                    <% 
                        // Nếu người dùng nhập sai và reload lại form, giữ dữ liệu size/price đã nhập
                        String[] sizes = request.getParameterValues("size");
                        String[] prices = request.getParameterValues("price");
                        if (sizes != null && prices != null) {
                            for (int i = 0; i < sizes.length; i++) {
                    %>
                    <div class="size-row">
                        <input type="text" name="size" value="<%= sizes[i] %>" placeholder="Size (e.g. Lon cao, Nhỏ, Combo...)" required>
                        <input type="number" name="price" value="<%= prices[i] %>" placeholder="Price" step="0.01" required>
                        <button type="button" class="btn-remove" onclick="removeRow(this)">❌</button>
                    </div>
                    <% 
                            }
                        } else { 
                    %>
                    <div class="size-row">
                        <input type="text" name="size" placeholder="Size (e.g. Lon cao, Nhỏ, Combo...)" required>
                        <input type="number" name="price" placeholder="Price" step="0.01" required>
                    </div>
                    <% } %>
                </div>

                <button type="button" class="btn-add" onclick="addSizeRow()">+ Add another size</button>
                <span class="error"><%= (errors != null && errors.get("sizeError") != null) ? errors.get("sizeError") : "" %></span>
                <br><br>

                <%-- Status --%>
                <label for="status">Status:</label><br>
                <select id="status" name="status" required>
                    <option value="Available" <%= "Available".equals(status) ? "selected" : "" %>>Available</option>
                    <option value="Unavailable" <%= "Unavailable".equals(status) ? "selected" : "" %>>Unavailable</option>
                </select>
                <br>

                <%-- Image --%>
                <label for="image">Image:</label><br>
                <input type="file" id="image" name="image" accept=".jpg,.jpeg,.png">
                <span class="error"><%= (errors != null && errors.get("imageError") != null) ? errors.get("imageError") : "" %></span>
                <br><br>

                <button type="submit">Add Item</button>
            </form>
        </div>

    </body>
</html>
<script>
    function addSizeRow() {
        const container = document.getElementById('sizes-container');
        const div = document.createElement('div');
        div.className = 'size-row';
        div.innerHTML = `
        <input type="text" name="size" placeholder="Size (e.g. Lon cao, Nhỏ, Combo...)" required>
        <input type="number" name="price" placeholder="Price" step="0.01" required>
        <button type="button" class="btn-remove" onclick="removeRow(this)">❌</button>
    `;
        container.appendChild(div);
    }

    function removeRow(button) {
        button.parentElement.remove();
    }
</script>