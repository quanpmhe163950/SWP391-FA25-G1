<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Blog Management</title>
    <link rel="stylesheet" href="../css/admin.css">
    <script>
        // mở/đóng modal thêm blog
        function openAddBlogModal() {
            document.getElementById("addBlogModal").style.display = "block";
        }
        function closeAddBlogModal() {
            document.getElementById("addBlogModal").style.display = "none";
        }

        // mở modal sửa blog
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

        // xác nhận xóa
        function confirmDelete(id) {
            if (confirm("Bạn có chắc muốn xóa bài viết này không?")) {
                window.location.href = "${pageContext.request.contextPath}/BlogController?action=delete&id=" + id;
            }
        }
    </script>
</head>
<body>
    <h1>Quản lý Blog</h1>

    <%-- Kiểm tra xem account trong session có phải Manager (roleID == 3) không --%>
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

    <table border="1" width="100%">
    <tr>
        <th>ID</th>
        <th>Tiêu đề</th>
        <th>Hình ảnh</th>
        <th>Ngày đăng</th>
        <th>Người đăng</th>
        <th>Thao tác</th>
    </tr>

        <!-- Nếu không có dữ liệu từ DB, hiển thị sample row tạm thời để xem giao diện -->
        <c:if test="${empty blogList}">
            <tr>
                <td>0</td>
                <td>Sample: Giới thiệu Pizza Shop</td>
                <td><img src="../images/sample.jpg" width="100" alt="sample"></td>
                <td><%= new java.util.Date() %></td>
                <td>System</td>
                <td>—</td>
            </tr>
        </c:if>

        <c:forEach var="b" items="${blogList}">
            <tr>
                <td>${b.blogID}</td>
                <td>${b.title}</td>
                <td><img src="../images/${b.image}" width="100"></td>
                <td>${b.createdAt}</td>
                <td>${b.createdByName}</td>
                <td>
                    <% if (isManager) { %>
                        <button onclick="openEditBlogModal('${b.blogID}', '${b.title}', `${b.content}`, '${b.image}')">✏️ Sửa</button>
                        <button onclick="confirmDelete('${b.blogID}')">🗑️ Xóa</button>
                    <% } else { %>
                        —
                    <% } %>
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

                <label>Tiêu đề:</label><br>
                <input type="text" name="title" required><br><br>

                <label>Nội dung:</label><br>
                <textarea name="content" rows="5" cols="50" required></textarea><br><br>

                <label>Hình ảnh:</label><br>
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
                <textarea id="editContent" name="content" rows="5" cols="50" required></textarea><br><br>

                <label>Ảnh hiện tại:</label><br>
                <img id="currentImage" src="" width="100"><br><br>

                <label>Chọn ảnh mới (nếu muốn):</label><br>
                <input type="file" name="image" accept="image/*"><br><br>

                <input type="submit" value="Cập nhật bài viết">
            </form>
        </div>
    </div>
</body>
</html>
