<%-- 
    Document   : listItem
    Created on : Oct 31, 2025, 2:49:20 PM
    Author     : admin
--%>

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
            font-family: Arial, sans-serif;
            margin: 30px;
        }
        table {
            border-collapse: collapse;
            width: 90%;
            margin-bottom: 30px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
            vertical-align: top;
        }
        th {
            background-color: #f5f5f5;
        }
        a {
            text-decoration: none;
            color: blue;
        }
        .success {
            color: green;
            font-weight: bold;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        h3 {
            color: #333;
        }
        .size-price {
            font-size: 13px;
            color: #333;
            line-height: 1.4em;
        }
    </style>
</head>
<body>

<h2>🍕 Item List</h2>

<% if (request.getAttribute("successMessage") != null) { %>
    <div class="success"><%= request.getAttribute("successMessage") %></div>
<% } %>

<a href="addItem">➕ Add New Item</a><br><br>

<%
    List<Item> availableItems = (List<Item>) request.getAttribute("availableItems");
    List<Item> unavailableItems = (List<Item>) request.getAttribute("unavailableItems");
    Map<Integer, String> availableCategoryMap = (Map<Integer, String>) request.getAttribute("availableCategoryMap");
    Map<Integer, String> unavailableCategoryMap = (Map<Integer, String>) request.getAttribute("unavailableCategoryMap");
%>

<!-- 🟢 Available Items -->
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
            <a href="editItem?itemID=<%= i.getItemID() %>">✏️ Edit</a> |
            <a href="deleteItem?itemID=<%= i.getItemID() %>" 
               onclick="return confirm('Mark this item as unavailable?');">🗑️ Delete</a>
        </td>
    </tr>
    <% } %>
</table>
<% } else { %>
<p><i>No available items.</i></p>
<% } %>

<!-- 🔴 Unavailable Items -->
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
        <td>
            <a href="editItem?itemID=<%= i.getItemID() %>">✏️ Edit</a>
        </td>
    </tr>
    <% } %>
</table>
<% } else { %>
<p><i>No unavailable items.</i></p>
<% } %>

</body>
</html>