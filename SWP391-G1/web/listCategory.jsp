<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Category"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Category List</title>

    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* Main container */
        .main-container {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        /* Navbar */
        .navbar {
            background-color: white;
            height: 60px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 25px;
        }

        .navbar h1 {
            font-size: 20px;
            color: #2c3e50;
        }

        /* Content */
        .main-content {
            flex: 1;
            padding: 25px 35px;
            overflow-y: auto;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }

        th {
            background-color: #f5f5f5;
            font-weight: bold;
        }

        a {
            text-decoration: none;
            color: #3498db;
            font-weight: 500;
        }

        h2 {
            margin-bottom: 10px;
            color: #333;
        }

        h3 {
            margin-top: 25px;
            color: #555;
        }

        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }

        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-thumb { background: #bbb; border-radius: 8px; }
    </style>
</head>

<body>

<!-- ✅ Sidebar -->
<jsp:include page="admin/admin-panel.jsp" />

<!-- ✅ Main container -->
<div class="main-container">

    <!-- ✅ Navbar -->
    <div class="navbar">
        <h1>Category Management</h1>
        <jsp:include page="admin/user-info.jsp" />
    </div>

    <!-- ✅ Main Content -->
    <div class="main-content">

        <h2>📂 Category List</h2>

        <% if (session.getAttribute("successMessage") != null) { %>
            <p class="success"><%= session.getAttribute("successMessage") %></p>
            <% session.removeAttribute("successMessage"); %>
        <% } %>

        <% if (session.getAttribute("errorMessage") != null) { %>
            <p class="error"><%= session.getAttribute("errorMessage") %></p>
            <% session.removeAttribute("errorMessage"); %>
        <% } %>

        <a href="addCategory.jsp">➕ Add New Category</a>
        <br><br>

        <% 
            List<Category> availableList = (List<Category>) request.getAttribute("availableCategories");
            List<Category> unavailableList = (List<Category>) request.getAttribute("unavailableCategories");
        %>

        <!-- ✅ Available -->
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

        <!-- ✅ Unavailable -->
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

    </div> <!-- end main-content -->

</div> <!-- end main-container -->

</body>
</html>
