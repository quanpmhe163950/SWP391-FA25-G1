<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="model.PurchaseOrder" %>

<%
    List<PurchaseOrder> orders = (List<PurchaseOrder>) request.getAttribute("orders");
    Map<Integer, String> supplierNames = (Map<Integer, String>) request.getAttribute("supplierNames");

    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
    String statusFilter = request.getParameter("status") != null ? request.getParameter("status") : "";
%>

<!DOCTYPE html>
<html>
<head>
    <title>Danh sách đơn đặt hàng</title>
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

        .navbar h1 {
            font-size: 20px;
            color: #2c3e50;
        }

        .navbar .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .navbar .username {
            color: #333;
            font-weight: 500;
        }

        .navbar button {
            background-color: #e74c3c;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 8px 14px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .navbar button:hover { background-color: #c0392b; }

        /* CONTENT */
        .main-content {
            flex: 1;
            padding: 25px 35px;
            overflow-y: auto;
        }

        .search-box {
            margin-bottom: 20px;
            padding: 15px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            margin-top: 15px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        th {
            background: #f0f0f0;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 12px;
            border-top: 1px solid #eee;
        }

        .btn {
            padding: 8px 12px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn:hover { background: #0056b3; }

        .btn-green {
            background: #27ae60;
        }

        .btn-green:hover {
            background: #1e874b;
        }

        .status-pending { color: orange; }
        .status-partial { color: #cc9900; }
        .status-received { color: green; }
        .status-cancelled { color: red; }

        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-thumb { background: #bbb; border-radius: 8px; }
                /* ===== Header giống home ===== */
        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

    </style>
</head>
<body>

    <!-- ✅ Sidebar -->
    <jsp:include page="admin-panel.jsp" />
    <jsp:include page="user-info.jsp" />
    <div class="main-container">

        <!-- ✅ Navbar -->
        <div class="navbar">
            <h1>Danh sách đơn đặt hàng</h1>

            <div class="user-info">
                <span class="username">Welcome, Admin</span>
                <form action="logout" method="post" style="margin:0;">
                    <button type="submit">Logout</button>
                </form>
            </div>
        </div>

        <!-- ✅ MAIN CONTENT -->
        <div class="main-content">

            <!-- ✅ SEARCH BAR -->
            <form action="purchase-order" method="get" class="search-box">
                <input type="hidden" name="action" value="">

                <label>Tên nhà cung cấp:</label>
                <input type="text" name="keyword" value="<%= keyword %>"
                       placeholder="Nhập tên..."
                       style="padding: 6px; width: 200px;">

                &nbsp;&nbsp;

                <label>Trạng thái:</label>
                <select name="status" style="padding: 6px;">
                    <option value="">-- Tất cả --</option>
                    <option value="pending"   <%= "pending".equals(statusFilter) ? "selected" : "" %>>Đã tạo</option>
                    <option value="partial"   <%= "partial".equals(statusFilter) ? "selected" : "" %>>Nhận 1 phần</option>
                    <option value="received"  <%= "received".equals(statusFilter) ? "selected" : "" %>>Nhận hết</option>
                    <option value="cancelled" <%= "cancelled".equals(statusFilter) ? "selected" : "" %>>Đã hủy</option>
                </select>

                &nbsp;&nbsp;

                <button class="btn" type="submit">Tìm kiếm</button>

                <a href="purchase-order?action=create" class="btn btn-green">
                    + Tạo đơn mới
                </a>
            </form>


            <!-- ✅ ORDER TABLE -->
            <table>
                <tr>
                    <th>ID</th>
                    <th>Nhà cung cấp</th>
                    <th>Người tạo</th>
                    <th>Ngày tạo</th>
                    <th>Ngày nhận</th>
                    <th>Trạng thái</th>
                    <th style="width:120px">Hành động</th>
                </tr>

                <% if (orders == null || orders.isEmpty()) { %>

                    <tr>
                        <td colspan="7" style="text-align:center; padding:25px;">
                            Không có đơn hàng nào.
                        </td>
                    </tr>

                <% } else { 
                       for (PurchaseOrder o : orders) {
                           String supplierName = supplierNames.get(o.getPurchaseOrderID());
                %>

                <tr>
                    <td><%= o.getPurchaseOrderID() %></td>
                    <td><%= supplierName %></td>
                    <td><%= o.getCreatedBy() %></td>
                    <td><%= o.getOrderDate() %></td>
                    <td><%= o.getReceiveDate() == null ? "-" : o.getReceiveDate() %></td>

                    <td class="status-<%= o.getStatus() %>">
                        <% if ("pending".equals(o.getStatus())) { %>Đã tạo
                        <% } else if ("partial".equals(o.getStatus())) { %>Nhận 1 phần
                        <% } else if ("received".equals(o.getStatus())) { %>Đã nhận hết
                        <% } else { %>Đã hủy <% } %>
                    </td>

                    <td>
                        <a class="btn btn-green"
                           href="purchase-order?action=detail&id=<%= o.getPurchaseOrderID() %>">
                            Xem
                        </a>
                    </td>
                </tr>

                <%  }
                   }
                %>
            </table>

        </div> <!-- End main-content -->

    </div> <!-- End main-container -->

</body>
</html>
