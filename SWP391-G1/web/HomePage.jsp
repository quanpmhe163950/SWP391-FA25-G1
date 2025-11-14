<%@page import="java.util.List, model.Combo, model.Blog, dal.ComboDAO, dal.BlogDAO" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Pizza Management - Home</title>
    <style>
    /* CSS giữ nguyên từ bạn với tùy chỉnh nhỏ cho hợp nhất */
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background: #fff8f0;
        color: #333;
        display: flex;
        flex-direction: column;
        height: 100vh;
    }
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
            <a href="<%= request.getContextPath() %>/login" style="color: red; font-weight: bold;">Logout</a>
        </div>
    </div>
</header>

<div class="container">
    <div class="menu">
        <h2>Pizza</h2>
        <div class="menu-grid">
            <!-- Sample static dishes -->
            <div class="item-card"><h3>Margherita</h3><a href="#">Order</a></div>
            <div class="item-card"><h3>Pepperoni</h3><a href="#">Order</a></div>
            <div class="item-card"><h3>Hawaiian</h3><a href="#">Order</a></div>
            <div class="item-card"><h3>BBQ Chicken</h3><a href="#">Order</a></div>
            <div class="item-card"><h3>Vegetarian</h3><a href="#">Order</a></div>
            <!-- etc... -->
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
        </div>

        <h2>Combos</h2>
        <div class="menu-grid">
            <%
                List<Combo> combos = (List<Combo>) request.getAttribute("comboList");
                if (combos == null) {
                    combos = (List<Combo>) session.getAttribute("comboList");
                }
                if (combos == null) {
                    try {
                        combos = new ComboDAO().getAllCombos();
                    } catch (Exception e) {
                        combos = null;
                    }
                }
                if (combos != null && !combos.isEmpty()) {
                    for (Combo c : combos) {
            %>
            <div class="item-card">
                <h3><%= c.getComboName() %></h3>
                <p><%= c.getDescription() %></p>
                <p>Price: <%= c.getPrice() %> VNĐ</p>
                <% if (c.getImagePath() != null && !c.getImagePath().isEmpty()) { %>
                    <img src="<%= request.getContextPath() + "/" + c.getImagePath() %>" alt="Combo Image" style="max-width: 100%; margin-top: 8px;" />
                <% } %>
                <a href="#">Order</a>
            </div>
            <%      }
                } else {
            %>
            <div class="item-card">No combos available.</div>
            <% } %>
        </div>

        <h2>Blog</h2>
        <div class="menu-grid">
            <%
                List<Blog> blogs = (List<Blog>) request.getAttribute("blogList");
                if (blogs == null) {
                    blogs = (List<Blog>) session.getAttribute("blogList");
                }
                if (blogs == null) {
                    try {
                        blogs = new BlogDAO().getAllBlogs();
                    } catch (Exception e) {
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
                <img src="<%= request.getContextPath() + "/images/" + post.getImage() %>" alt="" style="max-width: 100%; margin-top: 8px;" />
                <% } %>
            </div>
            <%      }
                } else {
            %>
            <div class="item-card">
                <h3>Pizza – Most loved dish in the world</h3>
                <p>Did you know the origin of pizza started in Italy in the 18th century? Explore more in upcoming blog posts.</p>
            </div>
            <div class="item-card"><h3>The secret to crispy pizza crust</h3><p>Admin shares how to select dough, ferment yeast, and bake perfect crust.</p></div>
            <div class="item-card"><h3>Pizza House brand story</h3><p>From a small shop in Hanoi to a widespread chain across Vietnam.</p></div>
            <div class="item-card"><h3>Top selling pizzas this month</h3><p>List of customer favorites compiled by Admin.</p></div>
            <% } %>
        </div>
    </div>
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

        <div class="payment-section">
            <h3>Payment Method</h3>
            <div class="payment-grid">
                <div class="payment-card">QR Code</div>
                <div class="payment-card">Card</div>
                <div class="payment-card">Cash</div>
                <div class="payment-card">VN Pay</div>
            </div>
        </div>

        <button class="checkout-btn">Checkout</button>
    </div>
</div>

<script>
    document.getElementById("tableNumber").textContent = 5;
    const paymentCards = document.querySelectorAll('.payment-card');
    paymentCards.forEach(card => {
        card.addEventListener('click', () => {
            paymentCards.forEach(c => c.classList.remove('active'));
            card.classList.add('active');
        });
    });
    document.querySelector('.checkout-btn').addEventListener('click', () => {
        const active = document.querySelector('.payment-card.active');
        if (active) {
            alert(`You selected payment method: ${active.textContent}`);
        } else {
            alert('Please select a payment method!');
        }
    });
</script>

</body>
</html>
