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
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #aaa; padding: 6px 12px; text-align: center; }
        th { background: #f2f2f2; }
        button { cursor: pointer; margin: 0 3px; }
        input[type="text"], textarea { width: 250px; }
        img { background: #fff; border: 1px solid #ddd; }

        .header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
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
    </style>
</head>
<body>

    <div class="header-bar">
        <h1>Quản lý Blog</h1>
        <button class="back-btn" onclick="window.location.href='http://localhost:8080/SWP391-G1-PizzaShop/HomePage.jsp'">
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
                <td>0</td>
                <td>Sample: Giới thiệu Pizza Shop</td>
                <td>
                    <img src="../images/sample.jpg" width="80" height="80"
                         onerror="this.onerror=null;this.style.background='red';this.src='';">
                </td>
                <td><%= new java.util.Date() %></td>
                <td>System</td>
                <td>—</td>
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

    <!-- Modal thêm blog -->
    <div id="addBlogModal" class="modal" style="display:none;">
        <div class="modal-content">
            <span class="close" onclick="closeAddBlogModal()">&times;</span>
            <h2>Thêm bài viết mới</h2>
            <form action="${pageContext.request.contextPath}/BlogController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                <label>Tiêu đề:</label>
                <input type="text" name="title" required><br><br>
                <label>Nội dung:</label><br>
                <textarea name="content" rows="5" required></textarea><br><br>
                <label>Hình ảnh:</label>
                <input type="file" name="image" accept="image/*"><br><br>
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
                <label>Tiêu đề:</label><br>
                <input type="text" id="editTitle" name="title" required><br><br>
                <label>Nội dung:</label><br>
                <textarea id="editContent" name="content" rows="5" required></textarea><br><br>
                <label>Ảnh hiện tại:</label><br>
                <img id="currentImage" src="" width="100"><br><br>
                <label>Chọn ảnh mới (nếu muốn):</label>
                <input type="file" name="image" accept="image/*"><br><br>
                <input type="submit" value="Cập nhật bài viết">
            </form>
        </div>
    </div>

    <!-- Script xử lý sự kiện và modal -->
    <script>
        function openAddBlogModal() {
            document.getElementById("addBlogModal").style.display = "block";
        }
        function closeAddBlogModal() {
            document.getElementById("addBlogModal").style.display = "none";
        }
        function openEditBlogModal(id, title, content, image) {
            document.getElementById("editBlogModal").style.display = "block";
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
        // Xử lý nút Sửa (an toàn với mọi ký tự)
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
