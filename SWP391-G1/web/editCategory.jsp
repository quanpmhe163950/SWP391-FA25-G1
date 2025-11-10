<%-- 
    Document   : editCategory
    Created on : Oct 31, 2025, 11:24:12 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Category"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Category</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background-color: #f5f5f5;
                margin: 0;
            }
            .container {
                background: white;
                padding: 30px 40px;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                width: 450px;
            }
            h2 {
                text-align: center;
                color: #333;
                margin-bottom: 25px;
            }
            .form-row {
                display: flex;
                flex-direction: column;
                margin-bottom: 15px;
            }
            label {
                font-weight: bold;
                margin-bottom: 5px;
            }
            input[type="text"], select, textarea {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 6px;
                resize: none;
            }
            textarea {
                height: 80px;
            }
            .button-group {
                display: flex;
                justify-content: space-between;
                margin-top: 20px;
            }
            input[type="submit"], a {
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 6px;
                font-weight: bold;
                text-align: center;
            }
            input[type="submit"] {
                background-color: #4CAF50;
                color: white;
                border: none;
            }
            a {
                background-color: #ccc;
                color: black;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>✏️ Edit Category</h2>

            <%
                Category category = (Category) request.getAttribute("category");
                if (category == null) {
            %>
            <p>Category not found!</p>
            <% } else { %>
            <form action="editCategory" method="post">
                <input type="hidden" name="categoryID" value="<%= category.getCategoryID() %>">

                <!-- Category Name -->
                <div class="form-row">
                    <label>Category Name:</label>
                    <input type="text" name="categoryName"
                           value="<%= request.getAttribute("categoryName") != null 
                                    ? request.getAttribute("categoryName") 
                                    : category.getCategoryName() %>" required>
                </div>

                <!-- Description (optional) -->
                <div class="form-row">
                    <label>Description:</label>
                    <textarea name="description"><%= 
    request.getAttribute("description") != null 
        ? request.getAttribute("description") 
        : (category.getDescription() != null ? category.getDescription() : "") 
                        %></textarea>
                </div>

                <!-- Status -->
                <div class="form-row">
                    <label>Status:</label>
                    <select name="status">
                        <option value="Available" <%= "Available".equals(category.getStatus()) ? "selected" : "" %>>Available</option>
                        <option value="Unavailable" <%= "Unavailable".equals(category.getStatus()) ? "selected" : "" %>>Unavailable</option>
                    </select>
                </div>

                <div class="button-group">
                    <input type="submit" value="💾 Save Changes">
                    <a href="listCategory">Cancel</a>
                </div>
            </form>
            <% } %>
        </div>
    </body>
</html>
