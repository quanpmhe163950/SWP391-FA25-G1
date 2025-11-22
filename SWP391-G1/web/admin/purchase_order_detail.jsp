<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PurchaseOrder" %>
<%@ page import="model.PurchaseOrderItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    PurchaseOrder order = (PurchaseOrder) request.getAttribute("order");
    List<PurchaseOrderItem> items = (List<PurchaseOrderItem>) request.getAttribute("items");
    Map<Integer, String> ingredientNames = (Map<Integer, String>) request.getAttribute("ingredientNames");
    Map<Integer, String> ingredientUnits = (Map<Integer, String>) request.getAttribute("ingredientUnits");
    String supplierName = (String) request.getAttribute("supplierName");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết đơn đặt hàng</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }
        .layout {
            display: flex;
            width: 100%;
            height: 100vh;
        }
        .left-panel {
            width: 250px;
            background: #fff;
            box-shadow: 2px 0 6px rgba(0,0,0,0.08);
        }
        .right-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .user-info-container {
            height: 60px;
            background: white;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding-right: 25px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .main-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 25px 35px;
            overflow-y: auto;
        }
        .box {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            padding: 10px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }
        th { background: #f0f0f0; font-weight: 600; }
        tr:hover { background-color: #fafafa; }
        .btn {
            padding: 10px 16px;
            background: #3498db;
            color: white;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 15px;
        }
        .btn:hover { background: #2c80c9; }
        .input-receive {
            width: 80px;
            padding: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .save-btn-container { margin-top: 15px; text-align: right; }
    </style>
</head>
<body>
<div class="layout">

    <!-- Sidebar -->
    <div class="left-panel">
        <jsp:include page="admin-panel.jsp" />
    </div>

    <!-- Right panel -->
    <div class="right-panel">
        <div class="user-info-container">
            <jsp:include page="user-info.jsp" />
        </div>

        <div class="main-container">

            <!-- Thông tin đơn hàng -->
            <div class="box">
                <h3>Thông tin đơn hàng</h3>
                <p><b>Nhà cung cấp:</b> <%= supplierName %></p>
                <p><b>Ngày tạo:</b> <%= order.getOrderDate() %></p>
                <p>
                    <b>Trạng thái:</b>
                    <span style="font-weight:600; color:
                        <%= order.getStatus().equals("pending") ? "orange" :
                            order.getStatus().equals("partial") ? "#cc9900" :
                            order.getStatus().equals("received") ? "green" : "red" %>">
                        <%= 
                            order.getStatus().equals("pending") ? "Chờ nhận" :
                            order.getStatus().equals("partial") ? "Nhận một phần" :
                            order.getStatus().equals("received") ? "Đã nhận" : "Đã hủy"
                        %>
                    </span>
                </p>
            </div>

            <!-- FORM nhận hàng -->
            <form action="receive-order" method="post">
                <input type="hidden" name="orderId" value="<%= order.getPurchaseOrderID() %>">

                <div class="box">
                    <h3>Chi tiết nguyên liệu</h3>

                    <table>
                        <tr>
                            <th>Tên nguyên liệu</th>
                            <th>Đơn vị nhập</th>
                            <th>Đơn vị kho</th>
                            <th>Đơn vị kho/Đơn vị nhập</th>
                            <th>Số lượng đặt</th>
                            <th>Đã nhận</th>
                            <th>Giá mỗi đơn vị nhập</th>
                            <th>Tổng phải trả</th>
                        </tr>

                        <% if (items == null || items.isEmpty()) { %>
                            <tr>
                                <td colspan="8" style="text-align:center; padding: 15px;">
                                    Chưa có nguyên liệu nào.
                                </td>
                            </tr>
                        <% } else {
                            double orderTotal = 0;
                            for (PurchaseOrderItem item : items) {
                                double maxSub = item.getUnitQuantity();
                                double receivedSub = item.getQuantityReceivedSubUnits();
                                double pricePerUnit = item.getPricePerUnit();
                                double totalPrice = pricePerUnit * item.getQuantityReceivedSubUnits();
                                orderTotal += totalPrice;
                        %>

                        <tr>
                            <td><%= ingredientNames.get(item.getIngredientID()) %></td>
                            <td><%= item.getUnitType() %></td>
                            <td><%= ingredientUnits.get(item.getIngredientID()) %></td>
                            <td><%= item.getSubQuantityPerUnit() %></td>
                            <td><%= item.getUnitQuantity() %></td>
                            <td>
                                <input
                                    type="number"
                                    min="0"
                                    max="<%= maxSub %>"
                                    step="1"
                                    class="input-receive"
                                    name="receivedSubUnits[<%= item.getPurchaseOrderItemID() %>]"
                                    value="<%= receivedSub %>"
                                >
                            </td>
                            <td><%= String.format("%,.0f", pricePerUnit) %> VND</td>
                            <td><%= String.format("%,.0f", totalPrice) %> VND</td>
                        </tr>

                        <% } %>

                        <!-- Tổng cộng -->
                        <tr style="font-weight:600; background:#f9f9f9;">
                            <td colspan="7" style="text-align:right;">Tổng cộng:</td>
                            <td><%= String.format("%,.0f", orderTotal) %> VND</td>
                        </tr>

                        <% } %>
                    </table>

                    <div class="save-btn-container">
                        <button type="submit" class="btn">✔ LƯU KẾT QUẢ NHẬN HÀNG</button>
                    </div>
                </div>
            </form>

        </div>
    </div>
</div>
</body>
</html>
