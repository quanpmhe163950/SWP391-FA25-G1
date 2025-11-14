<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8" />
    <title>Combo Management</title>

    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* ======= Nội dung bên phải ======= */
        .main-content {
            flex: 1;
            padding: 25px;
            overflow-y: auto;
        }

        h2 {
            margin-bottom: 15px;
            color: #333;
        }

        .btn {
            padding: 7px 12px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            color: #fff;
            transition: 0.2s;
        }
        .btn:hover { opacity: 0.9; }

        .btn-add { background: #28a745; }
        .btn-edit { background: #007bff; }
        .btn-delete { background: #dc3545; }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            text-align: center;
        }
        th {
            background: #f8f9fa;
            font-weight: 600;
        }
        tr:hover { background: #f1f7ff; }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100vw; height: 100vh;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 2000;
        }
        .modal-content {
            background: #fff;
            padding: 20px;
            width: 420px;
            border-radius: 8px;
            position: relative;
        }
        .close {
            position: absolute;
            top: 8px;
            right: 10px;
            cursor: pointer;
            font-size: 22px;
        }

        input[type="text"], textarea {
            width: 100%;
            padding: 7px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
    </style>
</head>
<body>

    <!-- Sidebar + user info -->
    <jsp:include page="admin-panel.jsp" />
    <jsp:include page="user-info.jsp" />

    <!-- Nội dung chính -->
    <div class="main-content">
        <h2>Combo Management</h2>

        <button class="btn btn-add" onclick="openAddComboModal()">+ Add New Combo</button>

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
                    <tr><td colspan="7">No combo found.</td></tr>
                </c:when>

                <c:otherwise>
                    <c:forEach var="c" items="${comboList}">
                        <tr>
                            <td>${c.comboID}</td>
                            <td>${c.comboName}</td>
                            <td>${c.description}</td>
                            <td>${c.price}</td>
                            <td>
                                <img src="${pageContext.request.contextPath}/${c.imagePath}"
                                     width="70" height="70"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                            </td>
                            <td>${c.status}</td>
                            <td>
                                <button class="btn btn-edit editBtn"
                                    data-id="${c.comboID}"
                                    data-comboname="${fn:escapeXml(c.comboName)}"
                                    data-description="${fn:escapeXml(c.description)}"
                                    data-price="${c.price}"
                                    data-imagepath="${c.imagePath}"
                                    data-status="${c.status}">
                                    Edit
                                </button>

                                <button class="btn btn-delete"
                                    onclick="confirmDelete('${c.comboID}')">
                                    Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </table>
    </div>


    <!-- Modal thêm -->
    <div id="addComboModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeAddComboModal()">&times;</span>
            <h3>Thêm Combo mới</h3>

            <form action="${pageContext.request.contextPath}/ComboController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add" />

                <label>Tên combo</label>
                <input type="text" name="comboName" required><br><br>

                <label>Mô tả</label>
                <textarea name="description" rows="3"></textarea><br><br>

                <label>Giá</label>
                <input type="text" name="price" required><br><br>

                <label>Hình ảnh</label>
                <input type="file" name="imagePath" accept="image/*"><br><br>

                <label>Trạng thái</label>
                <input type="text" name="status" value="Active"><br><br>

                <button type="submit" class="btn btn-add">Create</button>
            </form>
        </div>
    </div>

    <!-- Modal sửa -->
    <div id="editComboModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditComboModal()">&times;</span>
            <h3>Sửa Combo</h3>

            <form action="${pageContext.request.contextPath}/ComboController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="comboID" id="editComboID">

                <label>Tên combo</label>
                <input type="text" id="editComboName" name="comboName" required><br><br>

                <label>Mô tả</label>
                <textarea id="editDescription" name="description" rows="3"></textarea><br><br>

                <label>Giá</label>
                <input type="text" id="editPrice" name="price" required><br><br>

                <label>Ảnh hiện tại</label>
                <img id="currentImageCombo" width="100"><br><br>

                <label>Ảnh mới (nếu muốn)</label>
                <input type="file" name="imagePath" accept="image/*"><br><br>

                <label>Trạng thái</label>
                <input type="text" id="editStatus" name="status"><br><br>

                <button type="submit" class="btn btn-edit">Update</button>
            </form>
        </div>
    </div>

    <script>
        function openAddComboModal() {
            document.getElementById("addComboModal").style.display = "flex";
        }
        function closeAddComboModal() {
            document.getElementById("addComboModal").style.display = "none";
        }

        function openEditComboModal(id, name, desc, price, img, status) {
            document.getElementById("editComboModal").style.display = "flex";
            document.getElementById("editComboID").value = id;
            document.getElementById("editComboName").value = name;
            document.getElementById("editDescription").value = desc;
            document.getElementById("editPrice").value = price;
            document.getElementById("currentImageCombo").src = img;
            document.getElementById("editStatus").value = status;
        }
        function closeEditComboModal() {
            document.getElementById("editComboModal").style.display = "none";
        }

        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll(".editBtn").forEach(btn => {
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

        function confirmDelete(id) {
            if (confirm("Bạn có chắc muốn xóa combo này không?")) {
                window.location.href =
                    "${pageContext.request.contextPath}/ComboController?action=delete&id=" + id;
            }
        }
    </script>

</body>
</html>
