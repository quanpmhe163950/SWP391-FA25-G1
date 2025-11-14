<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>

<head>
    <meta charset="UTF-8" />
    <title>Quản lý Combo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css" />
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid #aaa;
            padding: 6px 12px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        button {
            cursor: pointer;
            margin: 0 3px;
        }
        input[type="text"], textarea {
            width: 250px;
        }
        img {
            background: #fff;
            border: 1px solid #ddd;
        }
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
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0,0,0,0.5);
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        .modal-content {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            width: 400px;
            position: relative;
        }
        .close {
            position: absolute;
            top: 8px;
            right: 10px;
            cursor: pointer;
            font-size: 20px;
        }
    </style>
</head>
<body>

    <div class="header-bar">
        <h1>Quản lý Combo</h1>
        <button class="back-btn" onclick="window.location.href = '${pageContext.request.contextPath}/HomePageController'">⬅️ Quay lại Trang chủ</button>
    </div>

    <button onclick="openAddComboModal()">➕ Thêm Combo mới</button>

    <table>
        <tr>
            <th>ID</th>
            <th>Tên Combo</th>
            <th>Mô tả</th>
            <th>Giá</th>
            <th>Hình ảnh</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>
        <c:choose>
            <c:when test="${empty comboList}">
                <tr><td colspan="7">⚠️ Chưa có combo nào!</td></tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="c" items="${comboList}">
                    <tr>
                        <td>${c.comboID}</td>
                        <td><c:out value="${c.comboName}" /></td>
                        <td><c:out value="${c.description}" /></td>
                        <td>${c.price}</td>
                        <td><img src="${pageContext.request.contextPath}/${c.imagePath}" width="80" height="80" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.jpg';"></td>
                        <td>${c.status}</td>
                        <td>
                            <button class="editBtn"
                                    data-id="${c.comboID}"
                                    data-comboName="${fn:escapeXml(c.comboName)}"
                                    data-description="${fn:escapeXml(c.description)}"
                                    data-price="${c.price}"
                                    data-imagePath="${c.imagePath}"
                                    data-status="${c.status}">
                                ✏️ Sửa
                            </button>
                            <button onclick="confirmDelete('${c.comboID}')">🗑️ Xóa</button>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </table>

    <!-- Modal thêm combo -->
    <div id="addComboModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeAddComboModal()">&times;</span>
            <h2>Thêm Combo Mới</h2>
            <form action="${pageContext.request.contextPath}/ComboController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add" />
                <label>Tên combo:</label><br/>
                <input type="text" name="comboName" required /><br/><br/>
                <label>Mô tả:</label><br/>
                <textarea name="description" rows="3"></textarea><br/><br/>
                <label>Giá:</label><br/>
                <input type="text" name="price" required /><br/><br/>
                <label>Hình ảnh:</label><br/>
                <input type="file" name="imagePath" accept="image/*" /><br/><br/>
                <label>Trạng thái:</label><br/>
                <input type="text" name="status" value="Active" /><br/><br/>
                <input type="submit" value="Tạo Combo" />
            </form>
        </div>
    </div>

    <!-- Modal sửa combo -->
    <div id="editComboModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditComboModal()">&times;</span>
            <h2>Sửa Combo</h2>
            <form action="${pageContext.request.contextPath}/ComboController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="comboID" id="editComboID" />
                <label>Tên combo:</label><br/>
                <input type="text" id="editComboName" name="comboName" required /><br/><br/>
                <label>Mô tả:</label><br/>
                <textarea id="editDescription" name="description" rows="3"></textarea><br/><br/>
                <label>Giá:</label><br/>
                <input type="text" id="editPrice" name="price" required /><br/><br/>
                <label>Ảnh hiện tại:</label><br/>
                <img id="currentImageCombo" src="" width="100" /><br/><br/>
                <label>Chọn ảnh mới (nếu muốn):</label><br/>
                <input type="file" name="imagePath" accept="image/*" /><br/><br/>
                <label>Trạng thái:</label><br/>
                <input type="text" id="editStatus" name="status" /><br/><br/>
                <input type="submit" value="Cập nhật Combo" />
            </form>
        </div>
    </div>

    <script>
        function openAddComboModal() {
            document.getElementById('addComboModal').style.display = 'flex';
        }
        function closeAddComboModal() {
            document.getElementById('addComboModal').style.display = 'none';
        }
        function openEditComboModal(id, comboName, description, price, imagePath, status) {
            document.getElementById('editComboModal').style.display = 'flex';
            document.getElementById('editComboID').value = id;
            document.getElementById('editComboName').value = comboName;
            document.getElementById('editDescription').value = description;
            document.getElementById('editPrice').value = price;
            document.getElementById('currentImageCombo').src = imagePath;
            document.getElementById('editStatus').value = status;
        }
        function closeEditComboModal() {
            document.getElementById('editComboModal').style.display = 'none';
        }
        function confirmDelete(id) {
            if (confirm('Bạn có chắc muốn xóa combo này không?')) {
                window.location.href = '${pageContext.request.contextPath}/ComboController?action=delete&id=' + id;
            }
        }
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.editBtn').forEach(function (btn) {
                btn.onclick = function () {
                    openEditComboModal(
                            this.dataset.id,
                            this.dataset.comboname,
                            this.dataset.description,
                            this.dataset.price,
                            this.dataset.imagepath,
                            this.dataset.status
                            );
                };
            });
        });
    </script>
</body>
</html>
