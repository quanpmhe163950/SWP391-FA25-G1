<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Ingredient Management</title>
    <style>
        body { font-family: Arial; margin: 30px; }
        table { border-collapse: collapse; width: 100%; margin-top: 10px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background-color: #f0f0f0; }
        a.btn { text-decoration: none; background-color: #4CAF50; color: white; padding: 6px 10px; border-radius: 4px; }
        a.btn-edit { background-color: #2196F3; }
        a.btn-del { background-color: #f44336; }
        a.btn-add { background-color: #008CBA; margin-bottom: 10px; display: inline-block; }
    </style>
</head>
<body>

<h2>Ingredient List</h2>
<a href="${pageContext.request.contextPath}/admin/ingredient?action=add" class="btn btn-add">+ Add New Ingredient</a>

<table>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Unit</th>
        <th>Stock Quantity</th>
        <th>Price</th>
        <th>Actions</th>
    </tr>

    <c:forEach var="i" items="${list}">
        <tr>
            <td>${i.id}</td>
            <td>${i.name}</td>
            <td>${i.unit}</td>
            <td>${i.quantity}</td>
            <td>${i.price}</td>
            <td>
                <a href="${pageContext.request.contextPath}/admin/ingredient?action=edit&id=${i.id}" class="btn btn-edit">Edit</a>
                <a href="${pageContext.request.contextPath}/admin/ingredient?action=delete&id=${i.id}" class="btn btn-del"
                   onclick="return confirm('Are you sure you want to delete this ingredient?');">Delete</a>
            </td>
        </tr>
    </c:forEach>

    <c:if test="${empty list}">
        <tr><td colspan="6">No ingredients found.</td></tr>
    </c:if>
</table>

</body>
</html>
