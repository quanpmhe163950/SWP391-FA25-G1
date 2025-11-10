<%-- 
    Document   : listCategory
    Created on : Oct 31, 2025, 11:13:52 AM
    Author     : admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Category"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Category List</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; }
        table { border-collapse: collapse; width: 70%; margin-bottom: 30px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f5f5f5; }
        a { text-decoration: none; color: blue; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        h3 { color: #333; }
    </style>
</head>
<%
    String message = (String) session.getAttribute("message");
    if (message != null) {
%>
    <script>
        alert("<%= message %>");
    </script>
<%
        session.removeAttribute("message"); // Xóa để không hiện lại khi refresh
    }
%>
<body>

    <h2>📂 Category List</h2>

    <% if (session.getAttribute("successMessage") != null) { %>
        <p class="success"><%= session.getAttribute("successMessage") %></p>
        <% session.removeAttribute("successMessage"); %>
    <% } %>

    <% if (session.getAttribute("errorMessage") != null) { %>
        <p class="error"><%= session.getAttribute("errorMessage") %></p>
        <% session.removeAttribute("errorMessage"); %>
    <% } %>

    <a href="addCategory.jsp">➕ Add New Category</a><br><br>

    <%
        List<Category> availableList = (List<Category>) request.getAttribute("availableCategories");
        List<Category> unavailableList = (List<Category>) request.getAttribute("unavailableCategories");
    %>

    <h3>🟢 Available Categories</h3>
    <% if (availableList != null && !availableList.isEmpty()) { %>
        <table>
            <tr>
                <th>ID</th>
                <th>Category Name</th>
                <th>Description</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <% for (Category c : availableList) { %>
            <tr>
                <td><%= c.getCategoryID() %></td>
                <td><%= c.getCategoryName() %></td>
                <td><%= c.getDescription() != null ? c.getDescription() : "" %></td>
                <td><%= c.getStatus() %></td>
                <td>
                    <a href="editCategory?categoryID=<%= c.getCategoryID() %>">✏️ Edit</a> |
                    <a href="deleteCategory?categoryID=<%= c.getCategoryID() %>" 
                       onclick="return confirm('Are you sure to mark this category as unavailable?');">🗑️ Delete</a> |
                    <a href="addItem?categoryID=<%= c.getCategoryID() %>" style="color: green;">➕ Add Product</a>
                </td>
            </tr>
            <% } %>
        </table>
    <% } else { %>
        <p><i>No available categories.</i></p>
    <% } %>

    <h3>🔴 Unavailable Categories</h3>
    <% if (unavailableList != null && !unavailableList.isEmpty()) { %>
        <table>
            <tr>
                <th>ID</th>
                <th>Category Name</th>
                <th>Description</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <% for (Category c : unavailableList) { %>
            <tr>
                <td><%= c.getCategoryID() %></td>
                <td><%= c.getCategoryName() %></td>
                <td><%= c.getDescription() != null ? c.getDescription() : "" %></td>
                <td><%= c.getStatus() %></td>
                <td>
                    <a href="editCategory?categoryID=<%= c.getCategoryID() %>">✏️ Edit</a>
                </td>
            </tr>
            <% } %>
        </table>
    <% } else { %>
        <p><i>No unavailable categories.</i></p>
    <% } %>

</body>
</html>