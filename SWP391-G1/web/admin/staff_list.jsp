<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Staff Management</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* ======= Nội dung chính bên phải ======= */
        .main-content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
        }

        /* ======= Buttons ======= */
        .btn {
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            color: #fff;
            cursor: pointer;
            border: none;
            transition: background 0.2s ease;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .btn-add { background: #28a745; }
        .btn-update { background: #007bff; display: none; }
        .btn-toggle { background: #6c757d; }

        form.inline { display: inline; }

        /* ======= Bảng ======= */
        table {
            border-collapse: collapse;
            width: 100%;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            margin-top: 15px;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }

        th {
            background: #f8f9fa;
            color: #333;
            font-weight: 600;
        }

        tr:hover {
            background-color: #f1f7ff;
        }

        /* ======= Form lọc ======= */
        .filter-form {
            margin-top: 20px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        select, input[type="text"] {
            padding: 8px 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        /* ======= Thanh tìm kiếm đẹp ======= */
        .search-bar {
            position: relative;
            max-width: 300px;
        }

        .search-bar input {
            width: 100%;
            padding: 10px 14px 10px 40px;
            border: 1px solid #ccc;
            border-radius: 25px;
            background-color: #fff;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            transition: all 0.2s ease;
        }

        .search-bar input:focus {
            outline: none;
            border-color: #4a90e2;
            box-shadow: 0 0 4px rgba(74, 144, 226, 0.3);
        }

        .search-bar::before {
            content: "🔍";
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #888;
            font-size: 16px;
        }
                /* ===== Header giống home ===== */
        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

    </style>

    <script>
        // Chỉ hiện nút Save khi role thay đổi
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

    <!-- Sidebar -->
    <jsp:include page="admin-panel.jsp" />
    <jsp:include page="user-info.jsp" />
    <!-- Nội dung chính -->
    <div class="main-content">
        <h2>Staff Management</h2>

        <a class="btn btn-add" href="${pageContext.request.contextPath}/admin/staff?action=add">+ Add New Staff</a>

        <form method="get" action="${pageContext.request.contextPath}/admin/staff" class="filter-form">
            <label>Role:
                <select name="role" onchange="this.form.submit()">
                    <option value="4" ${roleFilter == 4 ? 'selected' : ''}>Staff</option>
                    <option value="3" ${roleFilter == 3 ? 'selected' : ''}>Manager</option>
                </select>
            </label>

            <div class="search-bar">
                <input type="text" name="username" value="${param.username}" placeholder="Tìm kiếm username..." />
            </div>

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
    </div>

</body>
</html>
