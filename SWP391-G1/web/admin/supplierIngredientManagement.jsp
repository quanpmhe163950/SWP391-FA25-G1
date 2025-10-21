<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.*" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Nhà cung cấp & Nguyên liệu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f6fa;
            margin: 0;
            padding: 20px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        form.search-bar {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 15px;
        }
        form.search-bar input[type="text"] {
            padding: 8px;
            width: 200px;
        }
        form.search-bar input[type="submit"],
        form.search-bar a {
            background: #0078D7;
            color: white;
            padding: 8px 16px;
            border: none;
            text-decoration: none;
            cursor: pointer;
        }
        form.search-bar a {
            background: #888;
        }
        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin: 15px 0;
        }
        button {
            background: #2ecc71;
            color: white;
            border: none;
            padding: 8px 14px;
            cursor: pointer;
        }
        button.info {
            background: #3498db;
        }
        button.warning {
            background: #f39c12;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }
        table th, table td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }
        table th {
            background: #0078D7;
            color: white;
        }
        .modal {
            display: none;
            position: fixed;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center; align-items: center;
        }
        .modal-content {
            background: white;
            padding: 20px;
            width: 350px;
            border-radius: 5px;
            position: relative;
        }
        .modal-content h3 {
            margin-top: 0;
        }
        .modal-content label {
            display: block;
            margin-top: 10px;
        }
        .modal-content input {
            width: 100%;
            padding: 6px;
        }
        .modal-content .close {
            position: absolute;
            right: 10px;
            top: 8px;
            cursor: pointer;
            color: #aaa;
        }
        .modal-content .close:hover {
            color: #000;
        }
        .no-data {
            text-align: center;
            background: #fff;
            padding: 20px;
            border: 1px solid #ddd;
        }
    </style>
</head>
<body>
    <h2>Quản lý Nhà cung cấp & Nguyên liệu</h2>

    <!-- Thanh tìm kiếm -->
    <form class="search-bar" action="supplier-ingredient" method="get">
        <input type="text" name="supplierName" placeholder="Tên nhà cung cấp" value="${supplierName != null ? supplierName : ''}">
        <input type="text" name="ingredientName" placeholder="Tên nguyên liệu" value="${ingredientName != null ? ingredientName : ''}">
        <input type="submit" value="Tìm kiếm">
        <a href="supplier-ingredient">Làm mới</a>
    </form>

    <!-- Các nút thao tác -->
    <div class="action-buttons">
        <button onclick="openModal('addSupplierModal')">+ Thêm Nhà cung cấp</button>
        <button class="info" onclick="openModal('addIngredientModal')">+ Gán Nguyên liệu cho Nhà cung cấp</button>
    </div>

    <!-- Bảng dữ liệu -->
    <%
        List<IngredientSupplier> list = (List<IngredientSupplier>) request.getAttribute("list");
        if (list == null || list.isEmpty()) {
    %>
        <div class="no-data">Không có dữ liệu phù hợp</div>
    <% } else { %>
        <table>
            <thead>
            <tr>
                <th>#</th>
                <th>Nhà cung cấp</th>
                <th>Nguyên liệu</th>
                <th>Đơn vị</th>
                <th>Giá nhập</th>
                <th>Lần cập nhật cuối</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <%
                int i = 1;
                for (IngredientSupplier is : list) {
            %>
            <tr>
                <td><%= i++ %></td>
                <td><%= is.getSupplier().getSupplierName() %></td>
                <td><%= is.getIngredient().getIngredientName() %></td>
                <td><%= is.getIngredient().getUnit() %></td>
                <td><%= is.getPrice() %></td>
                <td><%= is.getLastUpdated() %></td>
                <td>
                    <button class="warning" onclick="openUpdateModal(<%= is.getId() %>, <%= is.getPrice() %>)">Cập nhật giá</button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>

    <!-- Modal: Thêm nhà cung cấp -->
    <div id="addSupplierModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('addSupplierModal')">&times;</span>
            <h3>Thêm Nhà cung cấp mới</h3>
            <form action="supplier-ingredient" method="post">
                <input type="hidden" name="action" value="addSupplier">
                <label>Tên nhà cung cấp:</label>
                <input type="text" name="supplierName" required>
                <label>Tên người liên hệ:</label>
                <input type="text" name="contactName" required>
                <label>Số điện thoại:</label>
                <input type="text" name="phone" required>
                <label>Địa chỉ:</label>
                <input type="text" name="address" required>
                <input type="submit" value="Thêm" style="margin-top:10px; background:#2ecc71; color:white; border:none; padding:8px 12px;">
            </form>
        </div>
    </div>

    <!-- Modal: Gán nguyên liệu -->
    <div id="addIngredientModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('addIngredientModal')">&times;</span>
            <h3>Gán Nguyên liệu cho Nhà cung cấp</h3>
            <form action="supplier-ingredient" method="post">
                <input type="hidden" name="action" value="addIngredient">
                <label>ID Nguyên liệu:</label>
                <input type="number" name="ingredientID" required>
                <label>ID Nhà cung cấp:</label>
                <input type="number" name="supplierID" required>
                <label>Giá nhập:</label>
                <input type="number" step="0.01" name="price" required>
                <input type="submit" value="Gán" style="margin-top:10px; background:#3498db; color:white; border:none; padding:8px 12px;">
            </form>
        </div>
    </div>

    <!-- Modal: Cập nhật giá -->
    <div id="updatePriceModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('updatePriceModal')">&times;</span>
            <h3>Cập nhật giá nhập</h3>
            <form action="supplier-ingredient" method="post">
                <input type="hidden" name="action" value="updatePrice">
                <input type="hidden" name="id" id="updateID">
                <label>Giá mới:</label>
                <input type="number" step="0.01" name="newPrice" id="updatePrice" required>
                <input type="submit" value="Cập nhật" style="margin-top:10px; background:#f39c12; color:white; border:none; padding:8px 12px;">
            </form>
        </div>
    </div>

    <script>
        function openModal(id) {
            document.getElementById(id).style.display = 'flex';
        }
        function closeModal(id) {
            document.getElementById(id).style.display = 'none';
        }
        function openUpdateModal(id, price) {
            document.getElementById('updateID').value = id;
            document.getElementById('updatePrice').value = price;
            openModal('updatePriceModal');
        }
        window.onclick = function(event) {
            document.querySelectorAll('.modal').forEach(modal => {
                if (event.target === modal) modal.style.display = 'none';
            });
        }
    </script>
</body>
</html>
