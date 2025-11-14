class<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Promotion Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
        <style>
            /* Nội dung chính */
            .main-content {
                flex: 1;
                padding: 25px;
                background: #f4f6f8;
                overflow-y: auto;
            }

            .page-title {
                font-size: 26px;
                color: #2c3e50;
                margin: 0 0 20px 0;
                font-weight: 600;
            }

            .btn {
                display: inline-block;
                padding: 10px 18px;
                background: #3498db;
                color: white;
                text-decoration: none;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                transition: 0.3s;
            }
            .btn:hover {
                background: #2980b9;
            }

            .btn-danger {
                background: #e74c3c;
            }
            .btn-danger:hover {
                background: #c0392b;
            }

            /* Bảng */
            .promo-table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
                margin-top: 10px;
            }

            .promo-table th {
                background: #2c3e50;
                color: white;
                padding: 15px;
                text-align: left;
                font-weight: 600;
            }

            .promo-table td {
                padding: 14px 15px;
                border-bottom: 1px solid #eee;
            }

            .promo-table tr:hover {
                background: #f8f9fa;
            }

            .status-active {
                color: #27ae60;
                font-weight: bold;
            }
            .status-inactive {
                color: #c0392b;
                font-weight: bold;
            }

            .actions a {
                margin-right: 8px;
                font-size: 13px;
                padding: 5px 10px;
                border-radius: 4px;
            }

            .no-data {
                text-align: center;
                padding: 40px;
                color: #7f8c8d;
                font-style: italic;
            }
        </style>
    </head>
    <body>

        <!-- === INCLUDE ADMIN PANEL (SIDEBAR + CSS) === -->
        <%@ include file="admin-panel.jsp" %>

        <!-- === MAIN CONTENT === -->
        <div class="main-content">
            <h1 class="page-title">Promotion Management</h1>

            <!-- Nút thêm mới -->
            <a href="${pageContext.request.contextPath}/admin/promotion?action=add" class="btn">
                Add New Promotion
            </a>

            <br><br>

            <!-- === BẢNG DANH SÁCH PROMOTION === -->
            <c:choose>
                <c:when test="${not empty promotions}">
                    <table class="promo-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Code</th>
                                <th>Mô tả</th>
                                <th>Loại</th>
                                <th>Giá trị</th>
                                <th>Ngày bắt đầu</th>
                                <th>Ngày kết thúc</th>
                                <th>Điều kiện</th>
                                <th>Trạng thái</th>
                                <th width="140">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${promotions}">
                                <tr>
                                    <td><strong>#${p.promoId}</strong></td>
                                    <td>
                                        <code style="background:#eee;padding:2px 6px;border-radius:3px;">
                                            ${p.code}
                                        </code>
                                    </td>
                                    <td>${p.description}</td>

                                    <!-- Cột Loại -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.discountType == 'PERCENT'}">Phần trăm (%)</c:when>
                                            <c:otherwise>Tiền mặt (VNĐ)</c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- Cột Giá trị -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.discountType == 'PERCENT'}">
                                                <strong style="color:#27ae60;">
                                                    <fmt:formatNumber value="${p.value}" pattern="#,##0.##"/>%
                                                </strong>
                                            </c:when>
                                            <c:otherwise>
                                                <strong style="color:#f39c12;">
                                                    <fmt:formatNumber value="${p.value}" pattern="#,##0"/> VNĐ
                                                </strong>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td><fmt:formatDate value="${p.startDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${p.endDate}" pattern="dd/MM/yyyy"/></td>

                                    <td>${p.applyCondition}</td>

                                    <td>
                                        <span class="${p.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                            ${p.status == 'ACTIVE' ? 'Đang hoạt động' : 'Tạm dừng'}
                                        </span>
                                    </td>

                                    <td class="actions">
                                        <a href="${pageContext.request.contextPath}/admin/promotion?action=edit&id=${p.promoId}" 
                                           class="btn" style="background:#f39c12;font-size:12px;padding:6px 10px;">
                                            Sửa
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/promotion?action=delete&id=${p.promoId}"
                                           class="btn btn-danger" style="font-size:12px;padding:6px 10px;"
                                           onclick="return confirm('Xóa mã giảm giá [${p.code}]? Hành động này không thể hoàn tác!')">
                                            Xóa
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <p>Not found.</p>
                        <a href="${pageContext.request.contextPath}/admin/promotion?action=add" class="btn">Create your first promotion</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>