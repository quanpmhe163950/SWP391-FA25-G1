<%-- 
    Document   : addCategory
    Created on : Oct 24, 2025, 4:28:39 PM
    Author     : admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pizza Shop - Add Category</title>
    <style>
        /* Đặt form giữa màn hình */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #f5f5f5;
        }

        /* Hộp chứa form */
        .form-container {
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 25px 30px;
            width: 480px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h1 {
            color: #333;
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 24px;
        }

        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }

        input[type=text],
        select,
        textarea {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }

        textarea {
            resize: none; /* Không cho kéo */
            height: 100px; /* Cố định chiều cao */
        }

        .error {
            color: red;
            font-size: 0.9em;
            margin-left: 3px;
        }

        .success-message {
            color: green;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .error-message {
            color: red;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .submit-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
        }

        .submit-btn:hover {
            background-color: #0056b3;
        }

        a {
            color: #007bff;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        p {
            margin-top: 8px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>Add New Category</h1>

        <%
            String successMessage = (String) request.getAttribute("successMessage");
            String errorMessage = (String) request.getAttribute("errorMessage");
            java.util.Map<String, String> errors = (java.util.Map<String, String>) request.getAttribute("errors");
        %>

        <% if (successMessage != null) { %>
        <div class="success-message"><%= successMessage %></div>
        <% } else if (errorMessage != null) { %>
        <div class="error-message"><%= errorMessage %></div>
        <% } %>

        <form action="addCategory" method="post">
            <!-- Category Name -->
            <label for="categoryName">Category Name:</label>
            <input type="text" id="categoryName" name="categoryName" required
                   value="<%= request.getAttribute("categoryName") != null ? request.getAttribute("categoryName") : "" %>">
            <span class="error"><%= errors != null && errors.get("categoryNameError") != null ? errors.get("categoryNameError") : "" %></span>

            <!-- Description -->
            <label for="description">Description:</label>
            <textarea id="description" name="description"><%= request.getAttribute("description") != null ? request.getAttribute("description") : "" %></textarea>
            <span class="error"><%= errors != null && errors.get("descriptionError") != null ? errors.get("descriptionError") : "" %></span>

            <!-- Status -->
            <label for="status">Status:</label>
            <select id="status" name="status">
                <option value="Available" <%= "Available".equals(request.getAttribute("status")) ? "selected" : "" %>>Available (Hoạt động)</option>
                <option value="Unavailable" <%= "Unavailable".equals(request.getAttribute("status")) ? "selected" : "" %>>Unavailable (Ngừng hoạt động)</option>
            </select>

            <button type="submit" class="submit-btn">Add Category</button>

            <p><a href="addItem">Đến trang thêm món ăn</a></p>
            <p><a href="listCategory">Đến trang danh sách danh mục</a></p>
        </form>
    </div>
</body>
</html>
