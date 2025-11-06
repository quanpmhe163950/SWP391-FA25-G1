<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>Customer Account Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 20px 30px;
            background-color: #f9fbfd;
        }

        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 15px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f7f7f7;
        }
        .btn {
            padding: 6px 10px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            color: white;
        }
        .btn-toggle {
            background-color: #6c757d;
        }
        form.inline {
            display: inline;
        }
        .filter-box {
            margin-bottom: 10px;
        }
        h2 {
            margin-top: 0;
        }
        /* Phân trang */
        .pagination {
            margin-top: 15px;
            text-align: center;
        }
        .pagination a {
            display: inline-block;
            padding: 6px 10px;
            margin: 2px;
            border: 1px solid #ccc;
            border-radius: 4px;
            text-decoration: none;
            color: #333;
        }
        .pagination a.active {
            background-color: #3498db;
            color: white;
            border-color: #2980b9;
        }
        .pagination a:hover {
            background-color: #ddd;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <jsp:include page="admin-panel.jsp" />

    <!-- Main content -->
    <div class="main-content">
        <div class="header-bar">
            <h2>Customer Account Management</h2>
            <!-- ✅ Thêm phần user-info -->
            <jsp:include page="user-info.jsp" />
        </div>

        <form method="get" action="${pageContext.request.contextPath}/admin/account" class="filter-box">
            <label>Phone:
                <input type="text" name="phone" value="${param.phone != null ? param.phone : ''}" />
            </label>
            <button type="submit">Search</button>
        </form>

        <!-- Cấu hình phân trang -->
        <c:set var="pageSize" value="10" />
        <c:set var="page" value="${param.page != null ? param.page : 1}" />
        <c:set var="total" value="${fn:length(list)}" />
        <c:set var="totalPages" value="${total % pageSize == 0 ? total / pageSize : (total / pageSize) + 1}" />
        <c:if test="${totalPages == 0}">
            <c:set var="totalPages" value="1" />
        </c:if>
        <c:set var="start" value="${(page - 1) * pageSize}" />
        <c:set var="end" value="${start + pageSize - 1}" />

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

            <c:choose>
                <c:when test="${not empty list}">
                    <c:forEach var="u" items="${list}" varStatus="st">
                        <c:if test="${st.index >= start && st.index <= end}">
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
                        </c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="7" style="text-align:center;">No customer accounts found.</td></tr>
                </c:otherwise>
            </c:choose>
        </table>

        <!-- Pagination -->
        <div class="pagination">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="${pageContext.request.contextPath}/admin/account?page=${i}${param.phone != null ? '&phone=' + param.phone : ''}"
                   class="${i == page ? 'active' : ''}">${i}</a>
            </c:forEach>
        </div>
    </div>

</body>
</html>
