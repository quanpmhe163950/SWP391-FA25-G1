<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    body {
        margin: 0;
        font-family: "Segoe UI", Arial, sans-serif;
        background-color: #f4f6f8;
        display: flex;
        height: 100vh;
        overflow: hidden;
    }

    /* Sidebar */
    .sidebar {
        width: 250px;
        background-color: #2c3e50;
        color: white;
        display: flex;
        flex-direction: column;
        padding: 20px;
    }

    .sidebar h2 {
        text-align: center;
        margin-bottom: 30px;
        font-size: 22px;
    }

    .menu-item {
        padding: 12px 15px;
        margin: 6px 0;
        cursor: pointer;
        border-radius: 8px;
        transition: background 0.3s;
        color: white;
        text-decoration: none;
    }

    .menu-item:hover {
        background-color: #34495e;
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

    /* Scrollbar */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-thumb {
        background: #bbb;
        border-radius: 8px;
    }
</style>

<!-- Sidebar -->
<div class="sidebar">
    <h2>Admin Panel</h2>
    <a class="menu-item" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
    <a class="menu-item" href="${pageContext.request.contextPath}/admin/account">User Management</a>
    <a class="menu-item" href="${pageContext.request.contextPath}/admin/staff">Staff Management</a>
    <a class="menu-item" href="${pageContext.request.contextPath}/admin/ingredient">Inventory</a>
    <a class="menu-item" href="${pageContext.request.contextPath}/admin/supplier-ingredient">Suppliers</a>
    <a class="menu-item" href="${pageContext.request.contextPath}/admin/purchase">Purchase Orders</a>
    <a class="menu-item" href="${pageContext.request.contextPath}/admin/food">Products</a>
    <a class="menu-item" href="${pageContext.request.contextPath}/admin/recipe">Recipes</a>
    <a class="menu-item" href="${pageContext.request.contextPath}/admin/feedback">Feedback</a>
</div>
