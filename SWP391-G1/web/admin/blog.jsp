<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Blog</title>
    <link rel="stylesheet" href="../css/admin.css">
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 20px 30px;
            overflow-y: auto;
        }

        .header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .back-btn {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.2s ease;
        }

        .back-btn:hover {
            background-color: #45a049;
        }

        table { border-collapse: collapse; width: 100%; background: #fff; }
        th, td { border: 1px solid #ccc; padding: 8px 12px; text-align: center; }
        th { background: #f2f2f2; }
        button { cursor: pointer; margin: 0 3px; padding: 5px 8px; border-radius: 5px; border: none; }
        img { background: #fff; border: 1px solid #ddd; }

        .modal {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex; justify-content: center; align-items: center;
        }

        .modal-content {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            width: 420px;
            position: relative;
        }

        .modal-content input, .modal-content textarea {
            width: 100%;
            margin-top: 5px;
            margin-bottom: 15px;
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .modal-content input[type="submit"] {
            background: #1abc9c;
            color: #fff;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }

        .modal-content input[type="submit"]:hover {
            background: #16a085;
        }

        .close {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 20px;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <jsp:include page="admin-panel.jsp" />
    <!-- Header user info -->
    <jsp:include page="user-info.jsp" />

    <!-- Main content -->
    <div class="main-content">

        <div class="header-bar">
            <h1>Quản lý Blog</h1>
            <button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/admin/home.jsp'">
                ⬅️ Quay lại Trang chủ
            </button>
        </div>

        <%
            boolean isManager = false;
            Object _acct = session.getAttribute("account");
            if (_acct != null && _acct instanceof model.User) {
                isManager = ((model.User) _acct).getRoleID() == 3;
            }
        %>

        <% if (isManager) { %>
            <button onclick="openAddBlogModal()">➕ Thêm bài viết</button>
        <% } %>

        <br><br>

        <table>
            <tr>
                <th>ID</th>
                <th>Tiêu đề</th>
                <th>Hình ảnh</th>
                <th>Ngày đăng</th>
                <th>Người đăng</th>
                <th>Thao tác</th>
            </tr>
            <c:if test="${empty blogList}">
                <tr>
                    <td colspan="6">Chưa có bài viết nào</td>
                </tr>
            </c:if>
            <c:forEach var="b" items="${blogList}">
                <tr>
                    <td>${b.blogID}</td>
                    <td><c:out value="${b.title}" /></td>
                    <td>
                        <img src="../images/${b.image}" width="80" height="80"
                             onerror="this.onerror=null;this.src='../images/default.jpg';">
                    </td>
                    <td>${b.createdDate}</td>
                    <td><c:out value="${b.createdByName}" /></td>
                    <td>
                        <button class="editBtn"
                            data-id="${b.blogID}"
                            data-title="${fn:escapeXml(b.title)}"
                            data-content="${fn:escapeXml(b.content)}"
                            data-image="${b.image}">
                            ✏️ Sửa
                        </button>
                        <button onclick="confirmDelete('${b.blogID}')">🗑️ Xóa</button>
                    </td>
                </tr>
            </c:forEach>
        </table>

    </div>

    <!-- Modal thêm blog -->
    <div id="addBlogModal" class="modal" style="display:none;">
        <div class="modal-content">
            <span class="close" onclick="closeAddBlogModal()">&times;</span>
            <h2>Thêm bài viết mới</h2>
            <form action="${pageContext.request.contextPath}/BlogController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                <label>Tiêu đề:</label>
                <input type="text" name="title" required>
                <label>Nội dung:</label>
                <textarea name="content" rows="5" required></textarea>
                <label>Hình ảnh:</label>
                <input type="file" name="image" accept="image/*">
                <input type="submit" value="Đăng bài">
            </form>
        </div>
    </div>

    <!-- Modal sửa blog -->
    <div id="editBlogModal" class="modal" style="display:none;">
        <div class="modal-content">
            <span class="close" onclick="closeEditBlogModal()">&times;</span>
            <h2>Sửa bài viết</h2>
            <form action="${pageContext.request.contextPath}/BlogController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="blogID" id="editBlogID">
                <label>Tiêu đề:</label>
                <input type="text" id="editTitle" name="title" required>
                <label>Nội dung:</label>
                <textarea id="editContent" name="content" rows="5" required></textarea>
                <label>Ảnh hiện tại:</label>
                <img id="currentImage" src="" width="100"><br><br>
                <label>Chọn ảnh mới (nếu muốn):</label>
                <input type="file" name="image" accept="image/*">
                <input type="submit" value="Cập nhật bài viết">
            </form>
        </div>
    </div>

    <script>
        function openAddBlogModal() {
            document.getElementById("addBlogModal").style.display = "flex";
        }
        function closeAddBlogModal() {
            document.getElementById("addBlogModal").style.display = "none";
        }
        function openEditBlogModal(id, title, content, image) {
            document.getElementById("editBlogModal").style.display = "flex";
            document.getElementById("editBlogID").value = id;
            document.getElementById("editTitle").value = title;
            document.getElementById("editContent").value = content;
            document.getElementById("currentImage").src = "../images/" + image;
        }
        function closeEditBlogModal() {
            document.getElementById("editBlogModal").style.display = "none";
        }
        function confirmDelete(id) {
            if (confirm("Bạn có chắc muốn xóa bài viết này không?")) {
                window.location.href = "${pageContext.request.contextPath}/BlogController?action=delete&id=" + id;
            }
        }
        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll('.editBtn').forEach(function(btn) {
                btn.onclick = function() {
                    openEditBlogModal(
                        this.dataset.id,
                        this.dataset.title,
                        this.dataset.content,
                        this.dataset.image
                    );
                }
            });
        });
    </script>
</body>
</html>
