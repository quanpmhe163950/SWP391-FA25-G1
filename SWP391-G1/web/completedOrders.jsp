<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<style>
    #completedOrdersSection table {
        width: 100%;
        border-collapse: collapse;
        font-family: Arial, sans-serif;
        font-size: 14px;
    }

    #completedOrdersSection th, 
    #completedOrdersSection td {
        border: 1px solid #ccc;
        text-align: center;
        white-space: nowrap; /* không xuống dòng để tiết kiệm width */
    }

    #completedOrdersSection th {
        background-color: #f5f5f5;
        font-weight: 600;
        color: #333;
    }

    #completedOrdersSection tr:nth-child(even) {
        background-color: #fafafa;
    }

    #completedOrdersSection tr:hover {
        background-color: #f0f8ff;
        transition: 0.15s ease-in-out;
    }

    #completedOrdersSection button {
        margin-top: 8px;
        background-color: #3b82f6;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 14px;
        cursor: pointer;
        padding: 10px
    }

    #completedOrdersSection button:hover {
        background-color: #2563eb;
    }
</style>

<div id="completedOrdersSection">
    <form id="completedForm">
        <table border="1">
            <tr>
                <th>Select</th>
                <th>Mã đơn hàng</th>
                <th>Status</th>
            </tr>
            <c:forEach var="o" items="${completedOrders}">
                <tr>
                    <td><input type="checkbox" name="selectedOrders" value="${o.orderID}" /></td>
                    <td>${o.orderCode}</td>
                    <td>Đang chờ...</td>
                </tr>
            </c:forEach>
        </table>
        <button type="button" onclick="confirmServed()">Xác nhận đã phục vụ</button>
    </form>
</div>


