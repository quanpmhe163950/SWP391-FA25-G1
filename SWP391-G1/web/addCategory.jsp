<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Category</title>

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

        /* Main content */
        .main-content {
            flex: 1;
            padding: 30px 40px;
            overflow-y: auto;
        }

        .form-box {
            background: white;
            padding: 25px 30px;
            width: 480px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        label { font-weight: bold; display: block; margin-top: 12px; }

        input[type=text],
        textarea,
        select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            margin-top: 4px;
            font-size: 14px;
        }

        textarea { resize: none; height: 90px; }

        .submit-btn {
            margin-top: 18px;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        .submit-btn:hover { background-color: #0056b3; }

        .success-message { color: green; font-weight: bold; margin-bottom: 10px; }
        .error-message { color: red; font-weight: bold; margin-bottom: 10px; }
        .error { color: red; font-size: 0.9em; }
        
        a { color: #007bff; text-decoration: none; }
        a:hover { text-decoration: underline; }

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
        <h1>Add New Category</h1>
        <jsp:include page="admin/user-info.jsp" />
    </div>

    <!-- ✅ Main Content -->
    <div class="main-content">

        <% 
            String successMessage = (String) request.getAttribute("successMessage");
            String errorMessage = (String) request.getAttribute("errorMessage");
            Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
        %>

        <div class="form-box">

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
                <span class="error">
                    <%= errors != null && errors.get("categoryNameError") != null ? errors.get("categoryNameError") : "" %>
                </span>

                <!-- Description -->
                <label for="description">Description:</label>
                <textarea id="description" name="description"><%= request.getAttribute("description") != null ? request.getAttribute("description") : "" %></textarea>
                <span class="error">
                    <%= errors != null && errors.get("descriptionError") != null ? errors.get("descriptionError") : "" %>
                </span>

                <!-- Status -->
                <label for="status">Status:</label>
                <select id="status" name="status">
                    <option value="Available" <%= "Available".equals(request.getAttribute("status")) ? "selected" : "" %>>Available (Active)</option>
                    <option value="Unavailable" <%= "Unavailable".equals(request.getAttribute("status")) ? "selected" : "" %>>Unavailable</option>
                </select>

                <button type="submit" class="submit-btn">Add Category</button>

                <p style="margin-top: 12px;">
                    <a href="listCategory">← Back to Category List</a>
                </p>

            </form>
        </div>

    </div>

</div>

</body>
</html>
