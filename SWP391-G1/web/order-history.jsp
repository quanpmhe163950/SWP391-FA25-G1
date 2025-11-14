<%@ page contentType="text/html; charset=UTF-8" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<div class="content">
    <h2 style="text-align:center; color:#ff6600;">Lịch sử mua hàng</h2>
    <table>
        <tr>
            <th>Mã đơn</th>
            <th>Ngày mua</th>
            <th>Sản phẩm</th>
            <th>Tổng tiền (VNĐ)</th>
            <th>Đánh giá</th> 
        </tr>
        <c:forEach var="o" items="${historyList}">
            <tr>
                <td>${o.orderID}</td>
                <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                <td>${o.itemName}</td>
                <td>
                    <fmt:formatNumber value="${o.totalPrice}" type="currency" currencySymbol="" groupingUsed="true"/> VNĐ
                </td>
                <td>
                    <c:choose>
                        <c:when test="${o.rating != null}">
                            <a href="review?itemID=${o.itemID}&orderId=${o.orderID}"
                               class="btn" style="background:#4CAF50;color:white;padding:6px 12px;border-radius:4px;text-decoration:none;">
                                Sửa (${o.rating}★)
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="review?itemID=${o.itemID}&orderId=${o.orderID}"
                               class="btn" style="background:#ff6600;color:white;padding:6px 12px;border-radius:4px;text-decoration:none;">
                                Đánh giá
                            </a>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
    </table>

    <c:if test="${empty historyList}">
        <p style="text-align:center; color:#999; margin-top:30px;">
            Bạn chưa có đơn hàng nào. 
            <a href="menu.jsp" style="color:#ff6600;">Mua sắm ngay!</a>
        </p>
    </c:if>
</div>