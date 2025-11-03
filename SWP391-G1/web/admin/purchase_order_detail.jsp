<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PurchaseOrder" %>
<%@ page import="model.PurchaseOrderItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    PurchaseOrder order = (PurchaseOrder) request.getAttribute("order");
    List<PurchaseOrderItem> items = (List<PurchaseOrderItem>) request.getAttribute("items");
    Map<Integer, String> ingredientNames = (Map<Integer, String>) request.getAttribute("ingredientNames");
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

        .main-container {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background-color: white;
            height: 60px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 25px;
        }

        .main-content {
            flex: 1;
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
        }

        th {
            background: #f0f0f0;
            text-align: left;
        }

        .btn {
            padding: 8px 12px;
            background: #3498db;
            color: white;
            border-radius: 6px;
            text-decoration: none;
            border: none;
            cursor: pointer;
        }

        .btn-green { background: #27ae60; }
        .btn-red { background: #e74c3c; }
    </style>
</head>
<body>

    <!-- ✅ Sidebar -->
    <jsp:include page="admin-panel.jsp" />

    <div class="main-container">

        <!-- ✅ Navbar -->
        <div class="navbar">
            <h1>Chi tiết đơn đặt hàng #<%= order.getPurchaseOrderID() %></h1>

            <a href="purchase-order" class="btn">
                ← Quay lại danh sách
            </a>
        </div>

        <!-- ✅ Main Content -->
        <div class="main-content">

            <!-- ✅ Thông tin đơn -->
            <div class="box">
                <h3>Thông tin đơn hàng</h3>

                <p><b>Nhà cung cấp:</b> <%= order.getSupplierID() %></p>
                <p><b>Người tạo:</b> <%= order.getCreatedBy() %></p>
                <p><b>Ngày tạo:</b> <%= order.getOrderDate() %></p>
                <p><b>Ghi chú:</b> <%= order.getNote() == null ? "(Không có)" : order.getNote() %></p>

                <p>
                    <b>Trạng thái:</b>
                    <span style="color:
                        <%= order.getStatus().equals("pending") ? "orange" : 
                            order.getStatus().equals("partial") ? "#cc9900" :
                            order.getStatus().equals("received") ? "green" : "red" %>">
                        
                        <%= 
                            order.getStatus().equals("pending") ? "Chờ nhận" :
                            order.getStatus().equals("partial") ? "Nhận một phần" :
                            order.getStatus().equals("received") ? "Đã nhận" :
                            "Đã hủy"
                        %>
                    </span>
                </p>
            </div>

            <!-- ✅ Danh sách nguyên liệu -->
            <div class="box">
                <h3>Chi tiết nguyên liệu</h3>

                <table>
                    <tr>
                        <th>Tên nguyên liệu</th>
                        <th>Đơn vị nhập</th>
                        <th>SL / Đơn vị nhập</th>
                        <th>Số lượng đặt</th>
                        <th>Đơn giá</th>
                        <th>Tổng</th>
                    </tr>

                    <% if (items == null || items.isEmpty()) { %>
                        <tr>
                            <td colspan="6" style="text-align:center; padding: 15px;">
                                Chưa có nguyên liệu nào.
                            </td>
                        </tr>
                    <% } else { %>

                        <% for (PurchaseOrderItem item : items) { %>
                            <tr>
                                <td><%= ingredientNames != null ? ingredientNames.get(item.getIngredientID()) : "N/A" %></td>
                                <td><%= item.getUnitType() %></td>
                                <td><%= item.getSubQuantityPerUnit() %></td>
                                <td><%= item.getUnitQuantity() %></td>
                                <td><%= String.format("%,.0f", item.getPricePerUnit()) %> VND</td>
                                <td><%= String.format("%,.0f", item.getPricePerUnit() * item.getUnitQuantity()) %> VND</td>
                            </tr>
                        <% } %>

                    <% } %>
                </table>
            </div>

        </div>
    </div>

</body>
</html>
