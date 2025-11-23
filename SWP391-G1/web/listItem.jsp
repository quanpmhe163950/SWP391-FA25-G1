<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="model.Item"%>
<%@page import="model.ItemSizePrice"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Item List</title>

    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* Main container */
        .main-container {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        /* Navbar */
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

        .navbar button:hover {
            background-color: #c0392b;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 25px 35px;
            overflow-y: auto;
        }

        h2 {
            margin-top: 5px;
            color: #333;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            background-color: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            border: 1px solid #eee;
            padding: 10px;
            text-align: left;
            vertical-align: top;
        }

        th {
            background-color: #fafafa;
        }

        .size-price {
            font-size: 13px;
            color: #444;
            line-height: 1.4em;
        }

        a {
            text-decoration: none;
            color: #3498db;
        }

        .success {
            color: green;
            font-weight: bold;
        }

        .error {
            color: red;
            font-weight: bold;
        }
        #searchInput {
            display: block;
            width: 300px;
            padding: 10px 15px;
            border-radius: 20px;
            border: 1px solid #ddd;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            margin: 20px auto;
            transition: all 0.3s;
        }

        #searchInput:focus {
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.5);
            outline: none;
        }
    </style>
    </head>

    <body>

        <!-- ✅ Import sidebar -->
        <jsp:include page="admin/admin-panel.jsp"/>

    <!-- ✅ Main container -->
    <div class="main-container">

        <!-- ✅ Navbar + user info -->
        <div class="navbar">
            <h1>Item List</h1>
            <jsp:include page="admin/user-info.jsp"/>
        </div>

        <!-- ✅ Page content -->
        <div class="main-content">

            <h2>🍕 Item List</h2>

            <% if (request.getAttribute("successMessage") != null) { %>
            <div class="success"><%= request.getAttribute("successMessage") %></div>
            <% } %>
            <input type="text" id="searchInput" placeholder="Search item..."
                   style="width: 300px; padding: 8px 12px; border-radius: 6px; border: 1px solid #ccc; margin-bottom: 20px;">
            <a href="addItem">➕ Add New Item</a><br><br>

            <%
                List<Item> availableItems = (List<Item>) request.getAttribute("availableItems");
                List<Item> unavailableItems = (List<Item>) request.getAttribute("unavailableItems");
                Map<Integer, String> availableCategoryMap = (Map<Integer, String>) request.getAttribute("availableCategoryMap");
                Map<Integer, String> unavailableCategoryMap = (Map<Integer, String>) request.getAttribute("unavailableCategoryMap");
            %>

            <!-- ✅ AVAILABLE ITEMS -->
            <h3>🟢 Available Items</h3>
            <% if (availableItems != null && !availableItems.isEmpty()) { %>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Item Name</th>
                    <th>Description</th>
                    <th>Sizes & Prices</th>
                    <th>Category</th>
                    <th>Status</th>
                    <th>Image</th>
                    <th>Action</th>
                </tr>

                <% for (Item i : availableItems) { %>
                <tr>
                    <td><%= i.getItemID() %></td>
                    <td><%= i.getName() %></td>
                    <td><%= i.getDescription() != null ? i.getDescription() : "" %></td>

                    <td class="size-price">
                        <% if (i.getSizePriceList() != null && !i.getSizePriceList().isEmpty()) { %>
                        <% for (ItemSizePrice isp : i.getSizePriceList()) { %>
                        <div><b><%= isp.getSize() %></b>: <%= isp.getPrice() %></div>
                        <% } %>
                        <% } else { %>
                        <i>No sizes</i>
                        <% } %>
                    </td>

                    <td><%= availableCategoryMap.get(i.getItemID()) %></td>
                    <td><%= i.getStatus() %></td>

                    <td>
                        <% if (i.getImagePath() != null && !i.getImagePath().isEmpty()) { %>
                        <img src="<%= i.getImagePath() %>" width="60" height="60">
                        <% } else { %>
                        <i>No image</i>
                        <% } %>
                    </td>

                    <td>
                        <a href="editItem?itemID=<%= i.getItemID() %>">✏️ Edit</a> 
                    </td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
            <p><i>No available items.</i></p>
            <% } %>

            <!-- ✅ UNAVAILABLE ITEMS -->
            <h3>🔴 Unavailable Items</h3>
            <% if (unavailableItems != null && !unavailableItems.isEmpty()) { %>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Item Name</th>
                    <th>Description</th>
                    <th>Sizes & Prices</th>
                    <th>Category</th>
                    <th>Status</th>
                    <th>Image</th>
                    <th>Action</th>
                </tr>

                <% for (Item i : unavailableItems) { %>
                <tr>
                    <td><%= i.getItemID() %></td>
                    <td><%= i.getName() %></td>
                    <td><%= i.getDescription() != null ? i.getDescription() : "" %></td>

                    <td class="size-price">
                        <% if (i.getSizePriceList() != null && !i.getSizePriceList().isEmpty()) { %>
                        <% for (ItemSizePrice isp : i.getSizePriceList()) { %>
                        <div><b><%= isp.getSize() %></b>: <%= isp.getPrice() %></div>
                        <% } %>
                        <% } else { %>
                        <i>No sizes</i>
                        <% } %>
                    </td>

                    <td><%= unavailableCategoryMap.get(i.getItemID()) %></td>
                    <td><%= i.getStatus() %></td>

                    <td>
                        <% if (i.getImagePath() != null && !i.getImagePath().isEmpty()) { %>
                        <img src="<%= i.getImagePath() %>" width="60" height="60">
                        <% } else { %>
                        <i>No image</i>
                        <% } %>
                    </td>

                    <td><a href="editItem?itemID=<%= i.getItemID() %>">✏️ Edit</a></td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
            <p><i>No unavailable items.</i></p>
            <% } %>

        </div>
    </div>
    <script>
        document.getElementById("searchInput").addEventListener("keyup", function () {
            const keyword = this.value.toLowerCase();
            const rows = document.querySelectorAll("table tbody tr");

            rows.forEach(row => {
                const name = (row.querySelector(".item-name")?.innerText || "").toLowerCase();
                const match = name.includes(keyword);
                row.style.display = match ? "" : "none";
            });
        });
    </script>
</body>
</html>