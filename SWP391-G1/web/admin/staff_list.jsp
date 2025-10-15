<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Staff Management</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 10px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f7f7f7; }
        .btn { padding: 6px 10px; border-radius: 4px; text-decoration: none; color: #fff; cursor: pointer; }
        .btn-add { background: #28a745; }
        .btn-update { background: #007bff; display: none; }
        .btn-toggle { background: #6c757d; }
        form.inline { display: inline; }
        .filter-form { margin-top: 10px; }
        input[type="text"], select { padding: 5px; }
    </style>
    <script>
        // Chỉ hiện nút Save khi role khác với role ban đầu
        function enableSave(selectElem, originalRole) {
            const form = selectElem.closest('form');
            const saveBtn = form.querySelector('.btn-update');
            if (selectElem.value != originalRole) {
                saveBtn.style.display = 'inline-block';
            } else {
                saveBtn.style.display = 'none';
            }
        }
    </script>
</head>
<body>

<h2>Staff Management</h2>

<a class="btn btn-add" href="${pageContext.request.contextPath}/admin/staff?action=add">+ Add New Staff</a>

<form method="get" action="${pageContext.request.contextPath}/admin/staff" class="filter-form">
    <label>Role:
        <select name="role" onchange="this.form.submit()">
            <option value="">All</option>
            <option value="4" ${roleFilter == 4 ? 'selected' : ''}>Staff</option>
            <option value="3" ${roleFilter == 3 ? 'selected' : ''}>Manager</option>
        </select>
    </label>

    <label style="margin-left:10px;">Username:
        <input type="text" name="username" value="${param.username}" placeholder="Search username..." />
    </label>
    <button type="submit" class="btn btn-toggle">Filter</button>
</form>

<table>
    <tr>
        <th>Username</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Role</th>
        <th>Start Date</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>

    <c:forEach var="u" items="${list}">
        <tr>
            <td>${u.username}</td>
            <td>${u.fullName}</td>
            <td>${u.email}</td>
            <td>${u.phone}</td>
            <td>
                <form class="inline" action="${pageContext.request.contextPath}/admin/staff" method="post">
                    <input type="hidden" name="action" value="updateRole" />
                    <input type="hidden" name="userId" value="${u.userID}" />
                    <select name="roleId" onchange="enableSave(this, '${u.roleID}')">
                        <option value="4" ${u.roleID == 4 ? 'selected' : ''}>Staff</option>
                        <option value="3" ${u.roleID == 3 ? 'selected' : ''}>Manager</option>
                    </select>
                    <button type="submit" class="btn btn-update">Save</button>
                </form>
            </td>
            <td><fmt:formatDate value="${u.startDate}" pattern="dd/MM/yyyy" /></td>
            <td>${u.active ? 'Active' : 'Inactive'}</td>
            <td>
                <form class="inline" action="${pageContext.request.contextPath}/admin/staff" method="post">
                    <input type="hidden" name="action" value="toggleActive" />
                    <input type="hidden" name="userId" value="${u.userID}" />
                    <input type="hidden" name="active" value="${u.active ? 0 : 1}" />
                    <button type="submit" class="btn btn-toggle">${u.active ? 'Deactivate' : 'Activate'}</button>
                </form>
            </td>
        </tr>
    </c:forEach>

    <c:if test="${empty list}">
        <tr><td colspan="8">No staff accounts found.</td></tr>
    </c:if>
</table>

</body>
</html>
