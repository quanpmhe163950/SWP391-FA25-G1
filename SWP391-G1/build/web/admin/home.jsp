<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        }

        .menu-item:hover {
            background-color: #34495e;
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

        /* Content */
        .main-content {
            flex: 1;
            padding: 25px 35px;
            overflow-y: auto;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .card {
            background-color: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .card h3 {
            margin-bottom: 10px;
            color: #333;
        }

        .chart-container {
            background-color: white;
            padding: 20px;
            margin-top: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        canvas {
            width: 100% !important;
            max-height: 350px;
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
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a class="menu-item" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
<a class="menu-item" href="${pageContext.request.contextPath}/admin/account">User Management</a>
<a class="menu-item" href="${pageContext.request.contextPath}/admin/staff">Staff Management</a>
<a class="menu-item" href="${pageContext.request.contextPath}/admin/ingredient">Inventory</a>

<div class="menu-item">Suppliers</div>
<div class="menu-item">Purchase Orders</div>
<div class="menu-item">Products</div>
<div class="menu-item">Recipes</div>
<div class="menu-item">Feedback</div>

    </div>

    <!-- Main container -->
    <div class="main-container">
        <!-- Navbar -->
        <div class="navbar">
            <h1>Dashboard Overview</h1>
            <div class="user-info">
                <span class="username">Welcome, Admin</span>
                <form action="logout" method="post" style="margin: 0;">
                    <button type="submit">Logout</button>
                </form>
            </div>
        </div>

        <!-- Main content -->
        <div class="main-content">
            <div class="cards">
                <div class="card">
                    <h3>Total Revenue</h3>
                    <p>$25,430</p>
                </div>
                <div class="card">
                    <h3>Orders Today</h3>
                    <p>128</p>
                </div>
                <div class="card">
                    <h3>Top Product</h3>
                    <p>Latte Coffee</p>
                </div>
                <div class="card">
                    <h3>Low Stock Items</h3>
                    <p>5 Ingredients</p>
                </div>
            </div>

            <!-- Charts -->
            <div class="chart-container">
                <h3>Monthly Revenue</h3>
                <canvas id="revenueChart"></canvas>
            </div>

            <div class="chart-container">
                <h3>Top Selling Products</h3>
                <canvas id="topProductsChart"></canvas>
            </div>

            <div class="chart-container">
                <h3>Ingredient Stock Levels</h3>
                <canvas id="stockChart"></canvas>
            </div>
        </div>
    </div>

    <script>
        // Revenue Chart
        new Chart(document.getElementById("revenueChart"), {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Revenue ($)',
                    data: [12000, 15000, 18000, 22000, 20000, 25430],
                    borderColor: '#e74c3c',
                    backgroundColor: 'rgba(231, 76, 60, 0.2)',
                    fill: true,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                scales: { y: { beginAtZero: true } }
            }
        });

        // Top Products Chart
        new Chart(document.getElementById("topProductsChart"), {
            type: 'bar',
            data: {
                labels: ['Latte', 'Espresso', 'Cappuccino', 'Mocha', 'Matcha'],
                datasets: [{
                    label: 'Units Sold',
                    data: [320, 280, 250, 220, 190],
                    backgroundColor: ['#3498db', '#9b59b6', '#2ecc71', '#e67e22', '#e74c3c']
                }]
            },
            options: {
                responsive: true,
                scales: { y: { beginAtZero: true } }
            }
        });

        // Stock Chart
        new Chart(document.getElementById("stockChart"), {
            type: 'doughnut',
            data: {
                labels: ['Milk', 'Sugar', 'Coffee Beans', 'Matcha Powder', 'Chocolate Syrup'],
                datasets: [{
                    data: [80, 60, 90, 30, 50],
                    backgroundColor: ['#1abc9c', '#f39c12', '#9b59b6', '#2ecc71', '#e74c3c']
                }]
            },
            options: {
                responsive: true
            }
        });
    </script>
</body>
</html>
