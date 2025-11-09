<%-- 
    Document   : deleteCategory
    Created on : Oct 31, 2025, 1:52:27 PM
    Author     : admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Category</title>
</head>
<body>
    <h2>⚠️ Confirm Delete</h2>
    <p>Are you sure you want to delete this category?</p>

    <form action="deleteCategory" method="post">
        <input type="hidden" name="categoryID" value="<%= request.getAttribute("categoryID") %>">
        <input type="submit" value="✅ Yes, Delete">
        <a href="listCategory">❌ Cancel</a>
    </form>
</body>
</html>