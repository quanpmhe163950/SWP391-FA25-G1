<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPath" value="${pageContext.request.servletPath}" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Sản phẩm - Admin</title>
        <style>
            :root {
                --primary: #2c3e50;
                --hover: #1a252f;
                --success: #d4edda;
                --error: #f8d7da;
                --border: #ddd;
                --bg-even: #f9f9f9;
            }
            body {
                font-family: 'Segoe UI', sans-serif;
                background: #f0f2f5;
                margin: 0;
                padding: 25px;
                color: #444;
                font-size: 16px; /* TĂNG FONT */
            }
            .container {
                max-width: 1350px;
                margin: auto;
                background: white;
                padding: 35px;
                border-radius: 16px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.12);
                max-height: 80vh;
                overflow-y: auto;
                overflow-x: hidden;
            }
            h1 {
                color: var(--primary);
                text-align: center;
                margin: 0 0 12px;
                font-size: 32px; /* TĂNG TIÊU ĐỀ */
                font-weight: 700;
            }
            .subtitle {
                text-align: center;
                color: #777;
                margin-bottom: 30px;
                font-size: 18px;
            }

            /* FILTER BAR */
            .filter-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                flex-wrap: wrap;
                gap: 15px;
            }
            .filter-group {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .filter-group label {
                font-weight: 600;
                color: var(--primary);
                font-size: 16px;
            }
            .filter-group select {
                padding: 10px 14px;
                border: 1px solid var(--border);
                border-radius: 8px;
                font-size: 15px;
                min-width: 180px;
                background: white;
            }

            .message {
                padding: 14px;
                margin: 15px 0;
                border-radius: 10px;
                text-align: center;
                font-weight: 500;
                font-size: 16px;
            }
            .success {
                background: var(--success);
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .error {
                background: var(--error);
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                font-size: 16px; /* TĂNG CHỮ BẢNG */
            }
            th {
                background: var(--primary);
                color: white;
                padding: 18px 14px;
                text-align: left;
                font-weight: 600;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            td {
                padding: 18px 14px;
                border-bottom: 1px solid var(--border);
                vertical-align: middle;
            }
            tr:nth-child(even) {
                background: var(--bg-even);
            }
            tr:hover {
                background: #eef5ff;
                transition: 0.2s;
            }

            .actions a {
                margin: 0 6px;
                padding: 8px 14px;
                border-radius: 8px;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
            }
            .edit-btn {
                background: #3498db;
                color: white;
            }
            .edit-btn:hover {
                background: #2980b9;
            }
            .delete-btn {
                background: #e74c3c;
                color: white;
            }
            .delete-btn:hover {
                background: #c0392b;
            }

            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.55);
                justify-content: center;
                align-items: center;
                z-index: 1000;
            }
            .modal.active {
                display: flex;
            }
            .modal-content {
                background: white;
                padding: 30px;
                border-radius: 16px;
                width: 560px;
                max-width: 92%;
                box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            }
            .modal h3 {
                margin: 0 0 20px;
                color: var(--primary);
                font-size: 22px;
            }
            .form-group {
                margin-bottom: 18px;
            }
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #333;
                font-size: 15px;
            }
            .form-group input, .form-group select {
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 15px;
            }
            .modal-actions {
                text-align: right;
                margin-top: 25px;
            }
            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                font-size: 15px;
            }
            .btn-save {
                background: #27ae60;
                color: white;
            }
            .btn-cancel {
                background: #95a5a6;
                color: white;
                margin-left: 12px;
            }

            .back {
                display: block;
                text-align: center;
                margin-top: 35px;
                color: var(--primary);
                font-weight: 600;
                text-decoration: none;
                font-size: 17px;
            }
            .back:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <%@ include file="admin-panel.jsp" %>
        <div class="container">
            <h1>Quản lý Sản phẩm</h1>
            <p class="subtitle">Xem, sửa, xóa món ăn trong menu</p>

            <!-- FILTER BAR -->
            <div class="filter-bar">
                <div class="filter-group">
                    <label>Lọc theo danh mục:</label>
                    <select onchange="filterByCategory(this.value)">
                        <option value="">Tất cả</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div style="font-size:14px; color:#777;">
                    Tổng: <strong>${items.size()}</strong> món
                </div>
            </div>

            <c:if test="${not empty message}">
                <div class="message ${message.contains('thành công') ? 'success' : 'error'}">${message}</div>
            </c:if>

            <c:if test="${not empty items}">
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Tên món</th>
                        <th>Giá</th>
                        <th>Danh mục</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td><strong>#${item.itemID}</strong></td>
                            <td><strong>${item.name}</strong></td>
                            <td><strong><fmt:formatNumber value="${item.price}" pattern="#,##0"/> VNĐ</strong></td>
                            <td><span style="background:#e3f2fd; padding:4px 10px; border-radius:6px; font-size:13px;">${item.category}</span></td>
                            <td>
                                <span style="padding:5px 10px; border-radius:6px; font-size:13px; font-weight:600;
                                      background:${item.status == 'Available' ? '#d4edb8' : '#fadbd8'};
                                      color:${item.status == 'Available' ? '#27ae60' : '#e74c3c'};">
                                    ${item.status}
                                </span>
                            </td>
                            <td class="actions">
                                <a href="#" class="edit-btn" onclick="openEditModal(${item.itemID}, '${item.name}', '${item.description}', ${item.price}, '${item.category}', '${item.status}', '${item.imagePath}', ${item.categoryID})">Sửa</a>
                                <a href="adminmenu?action=delete&id=${item.itemID}" class="delete-btn" onclick="return confirm('Xóa món này?')">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>

            <c:if test="${empty items}">
                <p style="text-align:center; color:#999; font-size:18px; margin:50px 0;">
                    Không có món ăn nào trong danh mục này.
                </p>
            </c:if>

            <a href="${pageContext.request.contextPath}/admin" class="back">Quay lại Admin Panel</a>
        </div>

        <!-- Modal Sửa -->
        <div id="editModal" class="modal">
            <div class="modal-content">
                <h3>Chỉnh sửa sản phẩm</h3>
                <form action="adminmenu" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editItemID" name="itemID">

                    <div class="form-group"><label>Tên món</label><input type="text" id="editName" name="name" required></div>
                    <div class="form-group"><label>Mô tả</label><input type="text" id="editDesc" name="description"></div>
                    <div class="form-group"><label>Giá</label><input type="number" step="0.01" id="editPrice" name="price" required></div>
                    <div class="form-group"><label>Danh mục</label><input type="text" id="editCategory" name="category" required></div>
                    <div class="form-group"><label>Trạng thái</label>
                        <select id="editStatus" name="status">
                            <option value="Available">Available</option>
                            <option value="Unavailable">Unavailable</option>
                        </select>
                    </div>
                    <div class="form-group"><label>Đường dẫn ảnh</label><input type="text" id="editImage" name="imagePath"></div>
                    <div class="form-group"><label>Category ID</label><input type="number" id="editCatID" name="categoryID" required></div>

                    <div class="modal-actions">
                        <button type="submit" class="btn btn-save">Lưu thay đổi</button>
                        <button type="button" class="btn btn-cancel" onclick="closeEditModal()">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openEditModal(id, name, desc, price, category, status, image, catID) {
                document.getElementById('editItemID').value = id;
                document.getElementById('editName').value = name;
                document.getElementById('editDesc').value = desc || '';
                document.getElementById('editPrice').value = price;
                document.getElementById('editCategory').value = category;
                document.getElementById('editStatus').value = status;
                document.getElementById('editImage').value = image || '';
                document.getElementById('editCatID').value = catID;
                document.getElementById('editModal').classList.add('active');
            }
            function closeEditModal() {
                document.getElementById('editModal').classList.remove('active');
            }
            function filterByCategory(category) {
                const url = new URL(window.location);
                if (category) {
                    url.searchParams.set('category', category);
                } else {
                    url.searchParams.delete('category');
                }
                window.location = url;
            }
        </script>
    </body>
</html>