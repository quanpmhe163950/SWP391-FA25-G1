<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Customer Account Management</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 15px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f7f7f7; }
        .btn { padding: 6px 10px; border-radius: 4px; border: none; cursor: pointer; color: white; }
        .btn-toggle { background-color: #6c757d; }
        form.inline { display: inline; }
        .filter-box { margin-bottom: 10px; }
    </style>
</head>
<body>

<h2>Customer Account Management</h2>

<form method="get" action="${pageContext.request.contextPath}/admin/account" class="filter-box">
    <label>Phone:
        <input type="text" name="phone" value="${param.phone != null ? param.phone : ''}" />
    </label>
    <button type="submit">Search</button>
</form>

<table>
    <tr>
        <th>Username</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Created Date</th>
        <th>Status</th>
        <th>Action</th>
    </tr>

    <c:forEach var="u" items="${list}">
        <tr>
            <td>${u.username}</td>
            <td>${u.fullName}</td>
            <td>${u.email}</td>
            <td>${u.phone}</td>
            <td><fmt:formatDate value="${u.createDate}" pattern="yyyy-MM-dd HH:mm" /></td>
            <td>${u.active ? "Active" : "Inactive"}</td>
            <td>
                <form class="inline" action="${pageContext.request.contextPath}/admin/account" method="post">
                    <input type="hidden" name="action" value="toggleActive" />
                    <input type="hidden" name="userId" value="${u.userID}" />
                    <input type="hidden" name="active" value="${u.active ? 0 : 1}" />
                    <button type="submit" class="btn btn-toggle">
                        ${u.active ? "Deactivate" : "Activate"}
                    </button>
                </form>
            </td>
        </tr>
    </c:forEach>

    <c:if test="${empty list}">
        <tr><td colspan="7" style="text-align:center;">No customer accounts found.</td></tr>
    </c:if>
</table>

</body>
</html>
