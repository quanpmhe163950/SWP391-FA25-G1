<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Đánh giá - Admin</title>
        <style>
            body {
                font-family: Arial;
                background: #f4f4f4;
                margin: 0;
                padding: 20px;
            }
            .container {
                max-width: 1100px;
                margin: auto;
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h1 {
                color: #2c3e50;
                text-align: center;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                padding: 12px;
                border: 1px solid #ddd;
                text-align: left;
            }
            th {
                background: #2c3e50;
                color: white;
            }
            tr:nth-child(even) {
                background: #f9f9f9;
            }
            .stars {
                color: #ffcc00;
            }
            .delete-btn {
                background: #e74c3c;
                color: white;
                padding: 6px 12px;
                text-decoration: none;
                border-radius: 4px;
                font-size: 14px;
            }
            .delete-btn:hover {
                background: #c0392b;
            }
            .message {
                padding: 10px;
                margin: 10px 0;
                border-radius: 5px;
                text-align: center;
            }
            .success {
                background: #d4edda;
                color: #155724;
            }
            .error {
                background: #f8d7da;
                color: #721c24;
            }
            .back {
                display: block;
                text-align: center;
                margin-top: 20px;
                color: #666;
            }
            td, th {
                padding: 16px 12px !important; /* TĂNG CHIỀU CAO DÒNG */
            }
        </style>
    </head>
    <body>
        <%@ include file="admin-panel.jsp" %>
        <div class="container">
            <h1>Quản lý Đánh giá</h1>

            <c:if test="${not empty message}">
                <div class="message ${message.contains('thành công') ? 'success' : 'error'}">
                    ${message}
                </div>
            </c:if>

            <c:if test="${not empty reviews}">
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Khách hàng</th>
                        <th>Sản phẩm</th>
                        <th>Điểm</th>
                        <th>Bình luận</th>
                        <th>Ngày</th>
                        <th>Hành động</th>
                    </tr>
                    <c:forEach var="r" items="${reviews}">
                        <tr>
                            <td>${r.reviewID}</td>
                            <td>${r.customerName}</td>
                            <td>${r.itemName}</td>
                            <td><span class="stars">
                                    <c:forEach begin="1" end="${r.rating}">★</c:forEach>
                                    <c:forEach begin="${r.rating + 1}" end="5">☆</c:forEach>
                                </span> (${r.rating}/5)</td>
                            <td>${r.comment}</td>
                            <td><fmt:formatDate value="${r.reviewDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <a href="reviews?action=delete&id=${r.reviewID}"
                                   class="delete-btn"
                                   onclick="return confirm('Xóa đánh giá này?')">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>

            <c:if test="${empty reviews}">
                <p style="text-align:center; color:#999; margin:40px;">Chưa có đánh giá nào.</p>
            </c:if>

            <a href="adminreview" class="back">Quay lại Dashboard</a>
        </div>
    </body>
</html>