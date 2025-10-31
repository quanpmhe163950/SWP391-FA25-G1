<%-- 
    Document   : HomePage
    Created on : 30 thg 9, 2025, 06:16:05
    Author     : dotha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Blog, dal.BlogDAO" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Pizza Management - Home</title>
        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background: #fff8f0;
                color: #333;
                display: flex;
                flex-direction: column;
                height: 100vh;
            }

            /* Header */
            header {
                background: #d32f2f;
                color: white;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 10px 20px;
                position: sticky;
                top: 0;
                z-index: 10;
            }
            header .logo {
                font-size: 20px;
                font-weight: bold;
                text-decoration: none;
                color: white;
            }
            header .search-bar input {
                padding: 6px 10px;
                border: none;
                border-radius: 20px;
                width: 250px;
            }
            header .user {
                position: relative;
                cursor: pointer;
            }
            header .user img {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                border: 2px solid white;
            }
            header .dropdown {
                display: none;
                position: absolute;
                right: 0;
                top: 50px;
                background: white;
                color: black;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
                overflow: hidden;
                min-width: 150px;
            }
            header .dropdown a {
                display: block;
                padding: 10px;
                text-decoration: none;
                color: black;
                transition: background 0.3s;
            }
            header .dropdown a:hover {
                background: #f5f5f5;
            }
            header .user:hover .dropdown {
                display: block;
            }

            /* Layout */
            .container {
                display: flex;
                flex: 1;
                overflow: hidden;
            }
            .menu {
                flex: 3;
                padding: 20px;
                overflow-y: auto;
                background: #fff;
            }
            .menu h2 {
                color: #d32f2f;
                margin: 20px 0 10px;
            }
            .menu-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                gap: 15px;
            }
            .item-card {
                background: #fff8f0;
                border-radius: 10px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                text-align: center;
                padding: 12px;
                transition: transform 0.2s, background 0.3s;
                cursor: pointer;
            }
            .item-card:hover {
                transform: translateY(-5px);
            }
            .item-card h3 {
                margin: 5px 0 10px;
                font-size: 15px;
                color: #333;
            }
            .item-card a {
                display: inline-block;
                padding: 5px 10px;
                background: #ffca28;
                border-radius: 20px;
                text-decoration: none;
                color: #333;
                font-weight: bold;
                transition: background 0.3s;
            }
            .item-card a:hover {
                background: #ffc107;
            }

            /* Bill Section */
            .bill {
                flex: 1;
                background: #fff;
                padding: 20px;
                border-left: 2px solid #f0f0f0;
                box-shadow: -2px 0 6px rgba(0,0,0,0.1);
                position: sticky;
                right: 0;
                top: 0;
                height: 100vh;
                overflow-y: auto;
            }
            .bill h2 {
                color: #d32f2f;
            }
            .bill .item {
                display: flex;
                justify-content: space-between;
                margin: 10px 0;
            }
            .bill .summary {
                border-top: 1px solid #ccc;
                margin-top: 15px;
                padding-top: 10px;
            }
            .bill .summary div {
                display: flex;
                justify-content: space-between;
                margin: 5px 0;
            }
            .bill .summary strong {
                font-size: 16px;
            }

            /* Payment Methods */
            .payment-section h3 {
                color: #d32f2f;
                margin-top: 20px;
            }
            .payment-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
                gap: 10px;
                margin-top: 10px;
            }
            .payment-card {
                background: #fff8f0;
                border-radius: 10px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                text-align: center;
                padding: 12px;
                transition: transform 0.2s, background 0.3s;
                cursor: pointer;
            }
            .payment-card:hover {
                transform: translateY(-3px);
            }
            .payment-card.active {
                background: #ffca28;
                font-weight: bold;
            }

            .checkout-btn {
                margin-top: 20px;
                padding: 12px;
                width: 100%;
                background: #d32f2f;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 16px;
                transition: background 0.3s;
            }
            .checkout-btn:hover {
                background: #b71c1c;
            }
        </style>
    </head>
    <body>

        <header>
            <a href="#" class="logo">
                <img src="image\z7061951110269_97de656e010792553d34b34b6d1df40c.jpg" alt="Pizza Food Logo" style="height:50px;">
            </a>
            <div class="search-bar">
                <input type="text" placeholder="Search...">
            </div>
            <div class="user">
                <img src="https://i.pravatar.cc/40" alt="User Avatar">
                <div class="dropdown">
                    <a href="#">Login</a>
                    <a href="#">Register</a>
                    <a href="#">Profile</a>
                </div>
            </div>
        </header>

        <div class="container">
            <!-- Menu -->
            <div class="menu">
                <h2>Pizza</h2>
                <div class="menu-grid">
                    <div class="item-card"><h3>Margherita</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Pepperoni</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Hawaiian</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>BBQ Chicken</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Vegetarian</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Meat Lovers</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Seafood</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Mexican</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Four Cheese</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Spicy Sausage</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Mushroom</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Bacon</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Spinach</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Truffle</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Greek</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Buffalo</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Carbonara</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Smoked Salmon</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Asian Fusion</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Supreme</h3><a href="#">Order</a></div>
                </div>

                <h2>Hamburgers</h2>
                <div class="menu-grid">
                    <div class="item-card"><h3>Classic Burger</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Cheese Burger</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Bacon Burger</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Chicken Burger</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Veggie Burger</h3><a href="#">Order</a></div>
                </div>

                <h2>Drinks</h2>
                <div class="menu-grid">
                    <div class="item-card"><h3>Coke</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Sprite</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Pepsi</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Fanta</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Iced Tea</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Lemonade</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Orange Juice</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Apple Juice</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Mineral Water</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Coffee</h3><a href="#">Order</a></div>
                </div>

                <h2>Combos</h2>
                <div class="menu-grid">
                    <div class="item-card"><h3>Pizza + Drink</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Pizza + Burger</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Family Combo</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Student Combo</h3><a href="#">Order</a></div>
                    <div class="item-card"><h3>Party Combo</h3><a href="#">Order</a></div>
                </div>

                <!-- Blog Section -->
                <h2>Blog</h2>
                <div class="menu-grid">
                    <%
                        // Lấy danh sách blog từ request (BlogController?action=listForHome sẽ đặt attribute này)
                        List<Blog> blogs = (List<Blog>) request.getAttribute("blogList");
                        if (blogs == null) {
                            // fallback: nếu không có trong request thì thử session (trường hợp redirect trước đó)
                            blogs = (List<Blog>) session.getAttribute("blogList");
                        }
                        // Nếu vẫn chưa có danh sách (truy cập trực tiếp HomePage.jsp), load trực tiếp từ DB
                        if (blogs == null) {
                            try {
                                blogs = new BlogDAO().getAllBlogs();
                            } catch (Exception _e) {
                                blogs = null;
                            }
                        }
                        if (blogs != null && !blogs.isEmpty()) {
                            for (Blog post : blogs) {
                    %>
                    <div class="item-card">
                        <h3><%= post.getTitle() %></h3>
                        <p><%= post.getContent() %></p>
                        <% if (post.getImage() != null && !post.getImage().trim().isEmpty()) { %>
                            <img src="<%= request.getContextPath() + "/images/" + post.getImage() %>" alt="" style="max-width:100%; margin-top:8px;" />
                        <% } %>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <!-- Nếu không có bài viết nào, hiển thị mẫu tĩnh -->
                    <div class="item-card"><h3>Pizza – Món ăn được yêu thích nhất thế giới</h3><p>Bạn có biết nguồn gốc của pizza bắt đầu từ Ý vào thế kỷ 18? Hãy cùng khám phá thêm trong các bài viết sắp tới.</p></div>
                    <div class="item-card"><h3>Bí quyết làm đế pizza giòn tan</h3><p>Admin chia sẻ cách chọn bột, ủ men và nướng đúng cách để có lớp đế hoàn hảo.</p></div>
                    <div class="item-card"><h3>Câu chuyện thương hiệu Pizza House</h3><p>Từ một tiệm nhỏ ở Hà Nội, Pizza House đã phát triển thành chuỗi cửa hàng khắp Việt Nam.</p></div>
                    <div class="item-card"><h3>Top pizza bán chạy nhất tháng</h3><p>Danh sách những hương vị pizza được khách hàng yêu thích nhất do Admin tổng hợp.</p></div>
                    <%
                        }
                    %>
                </div>
            </div>

            <!-- Bill Section -->
            <div class="bill">
                <h2>Your Bill</h2>
                <div class="item"><span>Table</span><span>#<span id="tableNumber">--</span></span></div>
                <div class="item"><span>Margherita</span><span>$10</span></div>
                <div class="item"><span>Pepperoni</span><span>$12</span></div>

                <div class="summary">
                    <div><span>Total Order</span><span>$22</span></div>
                    <div><span>VAT/Tax</span><span>10%</span></div>
                    <div><strong>Total Bill</strong><strong>$24.2</strong></div>
                </div>

                <!-- Payment Methods -->
                <div class="payment-section">
                    <h3>Payment Method</h3>
                    <div class="payment-grid">
                        <div class="payment-card">QR Code</div>
                        <div class="payment-card">Card</div>
                        <div class="payment-card">Cash</div>
                        <div class="payment-card">VN Pay</div>
                    </div>
                </div>

                <button class="checkout-btn">Thanh Toán</button>
            </div>
        </div>

        <script>
            // Chọn phương thức thanh toán
            document.getElementById("tableNumber").textContent = 5;
            const paymentCards = document.querySelectorAll('.payment-card');
            paymentCards.forEach(card => {
                card.addEventListener('click', () => {
                    paymentCards.forEach(c => c.classList.remove('active'));
                    card.classList.add('active');
                });
            });

            // Nút thanh toán
            document.querySelector('.checkout-btn').addEventListener('click', () => {
                const active = document.querySelector('.payment-card.active');
                if (active) {
                    alert(`Bạn đã chọn phương thức: ${active.textContent}`);
                } else {
                    alert('Vui lòng chọn phương thức thanh toán!');
                }
            });
        </script>

    </body>
</html>
