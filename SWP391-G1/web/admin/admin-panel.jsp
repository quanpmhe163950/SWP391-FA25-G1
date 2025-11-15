<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String currentPath = request.getRequestURI();
%>

<style>
    .sidebar-wrapper {
        width: 250px;
        height: 100vh;
        background-color: #2c3e50;
        color: white;
        overflow-y: auto;
        overflow-x: hidden;
        padding: 20px;
        box-sizing: border-box;
        flex-shrink: 0;   /* BẮT FLEX KHÔNG ĐƯỢC ÉP SIDEBAR THU NHỎ */
    }

    .menu-item {
        padding: 12px 15px;
        margin: 6px 0;
        border-radius: 8px;
        display: block;
        color: white;
        text-decoration: none;
    }

    .menu-item:hover {
        background-color: #34495e;
    }

    .menu-item.active {
        background-color: #1abc9c;
        font-weight: bold;
    }
</style>

<div class="sidebar-wrapper">
    <h2>Admin Panel</h2>

    <a class="menu-item <%= currentPath.contains("/admin/home.jsp") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/admin/home.jsp">Dashboard</a>

    <a class="menu-item <%= currentPath.contains("/admin/account") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/admin/account">Customer Management</a>

    <a class="menu-item <%= currentPath.contains("/admin/staff") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/admin/staff">Staff Management</a>

    <a class="menu-item <%= currentPath.contains("/admin/ingredient") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/admin/ingredient">Inventory</a>

    <a class="menu-item <%= currentPath.contains("/admin/supplier-ingredient") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/admin/supplier-ingredient">Suppliers</a>

    <a class="menu-item <%= currentPath.contains("/admin/purchase-order") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/admin/purchase-order">Purchase Orders</a>

    <a class="menu-item <%= currentPath.contains("/listCategory") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/listCategory">Categories</a>

    <a class="menu-item <%= currentPath.contains("/listItem") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/listItem">Products</a>

    <a class="menu-item <%= currentPath.contains("/admin/recipe") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/admin/recipe">Recipes</a>

    <a class="menu-item <%= currentPath.contains("/admin/blog") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/admin/blog?action=listForHome">Blog</a>

    <a class="menu-item <%= currentPath.contains("/ComboController") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/ComboController">Combo</a>
    
    <a class="menu-item <%= currentPath.contains("/admin/promotion") ? "active" : "" %>"
       href="${pageContext.request.contextPath}/admin/promotion">Promotion</a>
</div>

