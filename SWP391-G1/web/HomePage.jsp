<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="model.User" %>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Pizza Delicioso - Menu</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary: #ff6600;
                --primary-dark: #e55a00;
                --text: #333;
                --bg: #f8f8f8;
                --white: #fff;
                --gray: #777;
                --light-gray: #eee;
            }
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                font-family: 'Poppins', sans-serif;
                background-color: var(--bg);
                color: var(--text);
                line-height: 1.6;
                padding-top: 60px; /* Đẩy nội dung xuống dưới header */
            }

            /* === HEADER - NHỎ GỌN + DI CHUỘT === */
            header {
                background: linear-gradient(135deg, var(--primary), var(--primary-dark));
                color: white;
                padding: 6px 16px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                z-index: 1000;
                transition: transform 0.1s ease-out;
                transform: translateY(0);
            }

            .logo img {
                width: 200px;
                height: auto;
                transition: transform 0.3s ease;
            }
            .logo img:hover {
                transform: scale(1.05);
            }

            .auth-buttons {
                display: flex;
                gap: 12px;
            }

            .btn-auth {
                background: rgba(255, 255, 255, 0.2);
                color: white;
                border: 2px solid white;
                padding: 6px 16px;
                font-size: 0.9em;
                font-weight: 600;
                border-radius: 25px;
                text-decoration: none;
                transition: all 0.3s 0.3s ease;
                backdrop-filter: blur(5px);
            }
            .btn-auth:hover {
                background: white;
                color: var(--primary);
                transform: translateY(-2px);
            }
            .btn-register {
                background: white;
                color: var(--primary);
            }
            .btn-register:hover {
                background: var(--light-gray);
                color: var(--primary-dark);
            }

            /* === TAB MENU === */
            .tab-menu {
                display: flex;
                justify-content: center;
                background: white;
                padding: 15px 0;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                flex-wrap: wrap;
                position: fixed;
                left: 0;
                width: 100%;
                z-index: 999;
                transition: top 0.3s ease;
            }
            .tab-btn {
                background: none;
                border: none;
                padding: 12px 28px;
                font-size: 1.1em;
                font-weight: 600;
                color: var(--gray);
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
            }
            .tab-btn:hover {
                color: var(--primary);
            }
            .tab-btn.active {
                color: var(--primary);
            }
            .tab-btn.active::after {
                content: '';
                position: absolute;
                bottom: -6px;
                left: 50%;
                transform: translateX(-50%);
                width: 60px;
                height: 4px;
                background: var(--primary);
                border-radius: 2px;
            }

            /* === HERO === */
            /* === HERO – ẢNH TO HƠN === */
            .hero {
                background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)),
                    url('https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');
                background-size: cover;
                background-position: center;
                height: 500px;
                display: flex;
                align-items: center;
                justify-content: center;
                text-align: center;
                color: white;
                margin: 0 0 50px;
                position: relative;
            }
            .hero h2 {
                font-size: 3.5em;
                text-shadow: 0 4px 12px rgba(0,0,0,0.7);
                margin-bottom: 16px;
            }
            .hero p {
                font-size: 1.6em;
                text-shadow: 0 2px 8px rgba(0,0,0,0.6);
            }

            @media (max-width: 768px) {
                .hero {
                    height: 380px;
                }
                .hero h2 {
                    font-size: 2.3em;
                }
                .hero p {
                    font-size: 1.2em;
                }
            }

            /* === PRODUCTS === */
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }
            .products {
                padding: 30px 0 60px;
            }
            .product-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 28px;
                margin-top: 20px;
            }

            .product-card {
                background: var(--white);
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 6px 16px rgba(0,0,0,0.1);
                display: none;
                opacity: 0;
                transform: translateY(20px);
                transition: all 0.3s ease;
            }
            .product-card.show {
                display: block;
                opacity: 1;
                transform: translateY(0);
                animation: fadeInUp 0.5s ease forwards;
            }
            .product-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 16px 30px rgba(0,0,0,0.18);
            }

            /* Ảnh to hơn, đẹp hơn */
            .product-card img {
                width: 100%;
                height: 240px; /* Tăng từ 190px → 240px */
                object-fit: cover;
                border-bottom: 4px solid var(--primary);
            }

            .product-info {
                padding: 22px;
                text-align: center;
            }
            .product-info h3 {
                color: var(--primary);
                font-size: 1.35em;
                margin-bottom: 10px;
                font-weight: 600;
            }
            .product-info p {
                font-size: 0.98em;
                color: #555;
                margin-bottom: 14px;
                height: 50px;
                overflow: hidden;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
            }
            .price {
                font-size: 1.5em;
                font-weight: 700;
                color: #2e7d32;
            }

            footer {
                background: #222;
                color: #ccc;
                text-align: center;
                padding: 25px;
                font-size: 0.95em;
                margin-top: 40px;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @media (max-width: 768px) {
                body {
                    padding-top: 110px;
                }
                header {
                    flex-direction: column;
                    padding: 10px;
                    text-align: center;
                }
                .logo img {
                    width: 160px;
                }
                .auth-buttons {
                    margin-top: 8px;
                    gap: 10px;
                }
                .btn-auth {
                    padding: 6px 14px;
                    font-size: 0.85em;
                }
                .hero {
                    margin: 120px 0 40px;
                }
                .hero h2 {
                    font-size: 2em;
                }
                .hero p {
                    font-size: 1.1em;
                }
                .tab-btn {
                    padding: 10px 18px;
                    font-size: 1em;
                }
            }
            /* === DROPDOWN USER - BẢN TO HƠN XÍ === */
            .user-dropdown {
                position: relative;
                display: inline-block;
            }

            /* Nút bấm avatar + tên */
            .dropdown-toggle {
                background: rgba(255, 255, 255, 0.18);
                border: 2px solid white;
                color: white;
                padding: 6px 14px;           /* to hơn nhẹ */
                border-radius: 28px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;                    /* giãn cách hơn chút */
                font-weight: 600;
                font-size: 0.95em;           /* tăng chữ nhẹ */
                transition: all 0.3s ease;
                backdrop-filter: blur(6px);
            }

            .dropdown-toggle:hover {
                background: white;
                color: var(--primary);
            }

            /* Avatar */
            .avatar {
                width: 32px;                 /* to hơn xí */
                height: 32px;
                border-radius: 50%;
                object-fit: cover;
                border: 2px solid white;
            }

            /* Tên người dùng */
            .username {
                font-size: 0.95em;
                line-height: 1;
            }

            /* Mũi tên */
            .arrow-down {
                width: 0;
                height: 0;
                border-left: 5px solid transparent;
                border-right: 5px solid transparent;
                border-top: 5px solid white;
                transition: transform 0.3s ease;
            }

            .dropdown-toggle.active .arrow-down {
                transform: rotate(180deg);
                border-top-color: var(--primary);
            }

            /* Menu dropdown */
            .dropdown-menu {
                position: absolute;
                top: 120%;
                right: 0;
                background: white;
                min-width: 180px;            /* rộng hơn tí */
                border-radius: 12px;
                box-shadow: 0 8px 22px rgba(0,0,0,0.15);
                overflow: hidden;
                opacity: 0;
                visibility: hidden;
                transform: translateY(-8px);
                transition: all 0.3s ease;
                z-index: 1000;
            }

            /* Khi mở menu */
            .user-dropdown.open .dropdown-menu {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            /* Item trong menu */
            .dropdown-item {
                display: block;
                padding: 12px 16px;          /* to hơn xí */
                color: #333;
                text-decoration: none;
                font-size: 0.95em;
                transition: background 0.25s;
            }

            .dropdown-item:hover {
                background: #f2f2f2;
            }

            /* Logout item */
            .dropdown-item.logout {
                color: #ff4d4f;
                font-weight: 600;
            }

            .dropdown-item.logout:hover {
                background: #fff0f0;
            }

        </style>
    </head>
    <body>

        <!-- HEADER -->
        <header>
            <div class="logo">
                <img src="images/logonotbg.png" alt="Pizza Delicioso">
            </div>
            <div class="auth-buttons">
                <%
                    HttpSession sess = request.getSession(false);
                    User user = (sess != null) ? (User) sess.getAttribute("account") : null;

                    if (user != null) {
                        String displayName = (user.getFullName() != null && !user.getFullName().isBlank())
                            ? user.getFullName() : user.getUsername();
                %>
                <!-- USER ĐÃ LOGIN - DROPDOWN GỌN -->
                <div class="user-dropdown">
                    <button class="dropdown-toggle" type="button" id="userToggle">
                        <img src="images/account.png" alt="User" class="avatar">
                        <span class="username"><%= displayName %></span>
                        <i class="arrow-down"></i>
                    </button>
                    <div class="dropdown-menu">
                        <a href="cusinfor" class="dropdown-item">Thông tin cá nhân</a>
                        <a href="logout" class="dropdown-item logout">Đăng xuất</a>
                    </div>
                </div>
                <%
                    } else {
                %>
                <a href="login" class="btn-auth">Đăng Nhập</a>
                <a href="register" class="btn-auth btn-register">Đăng Ký</a>
                <%
                    }
                %>
            </div>
        </header>

        <!-- TAB MENU -->
        <div class="tab-menu">
            <button class="tab-btn active" data-category="all">Tất cả</button>
            <button class="tab-btn" data-category="pizza">Pizza</button>
            <button class="tab-btn" data-category="pasta">Pasta/Salad</button>
            <button class="tab-btn" data-category="extra">Đồ ăn thêm</button>
            <button class="tab-btn" data-category="drink">Nước uống</button>
        </div>

        <!-- HERO -->
        <section class="hero">
            <div>
                <h2>Bùng Nổ Hương Vị Từ Thiên Đường Ý</h2>
                <p>Thực đơn hoàn hảo cho mọi bữa ăn – pizza, pasta và hơn thế nữa!</p>
            </div>
        </section>

        <!-- PRODUCTS -->
        <div class="container">
            <div class="products">
                <div class="product-grid">

                    <c:forEach var="item" items="${menuList}">
                        <!-- Chuẩn hóa category tiếng Việt có dấu -->
                        <c:set var="cat" value="${fn:toLowerCase(fn:replace(fn:replace(fn:replace(item.category, 'Đ', 'd'), 'ồ', 'o'), 'ă', 'a'))}" />
                        <c:set var="finalCat">
                            <c:choose>
                                <c:when test="${cat == 'pizza'}">pizza</c:when>
                                <c:when test="${fn:contains(cat, 'pasta') or fn:contains(cat, 'salad')}">pasta</c:when>
                                <c:when test="${fn:contains(cat, 'do an them') or fn:contains(cat, 'extra')}">extra</c:when>
                                <c:when test="${fn:contains(cat, 'drink') or fn:contains(cat, 'nuoc') or fn:contains(cat, 'nước')}">drink</c:when>
                                <c:otherwise>all</c:otherwise>
                            </c:choose>
                        </c:set>

                        <div class="product-card" data-category="${finalCat}">
                            <img src="${pageContext.request.contextPath}/${item.imagePath}" alt="${item.name}">
                            <div class="product-info">
                                <h3>${item.name}</h3>
                                <p>${item.description}</p>
                                <div class="price">
                                    <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/>đ
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                </div>
            </div>
        </div>

        <!-- FOOTER -->
        <footer>
            <p>© 2025 SWP391-G1-PizzaShop – Thực đơn chỉ dành để xem | Liên hệ: 0898 260 423</p>
        </footer>

        <!-- JAVASCRIPT -->
        <script>
            // === HEADER DI CHUỘT ===
            document.addEventListener("DOMContentLoaded", function () {
                const toggle = document.querySelector(".dropdown-toggle");
                const dropdown = document.querySelector(".user-dropdown");

                toggle.addEventListener("click", function (e) {
                    e.stopPropagation();
                    dropdown.classList.toggle("open");
                    toggle.classList.toggle("active");
                });

                // Ẩn dropdown khi bấm ra ngoài
                document.addEventListener("click", function () {
                    dropdown.classList.remove("open");
                    toggle.classList.remove("active");
                });
            });
            const header = document.querySelector('header');
            let mouseX = 0, mouseY = 0;
            let headerX = 0, headerY = 0;

            document.addEventListener('mousemove', (e) => {
                mouseX = e.clientX / window.innerWidth - 0.5;
                mouseY = e.clientY / window.innerHeight - 0.5;
            });

            function updateHeader() {
                headerX += (mouseX * 30 - headerX) * 0.1;
                headerY += (mouseY * 15 - headerY) * 0.1;
                header.style.transform = `translate(${headerX}px, ${headerY}px)`;
                requestAnimationFrame(updateHeader);
            }
            requestAnimationFrame(updateHeader);

            // === CẬP NHẬT VỊ TRÍ TAB MENU ===
            function updateTabMenu() {
                const headerHeight = header.offsetHeight;
                document.querySelector('.tab-menu').style.top = headerHeight + 'px';
            }
            window.addEventListener('resize', updateTabMenu);
            document.addEventListener('DOMContentLoaded', updateTabMenu);

            function updateHeroPosition() {
                const header = document.querySelector('header');
                const tabMenu = document.querySelector('.tab-menu');
                const hero = document.querySelector('.hero');
                const totalHeight = header.offsetHeight + tabMenu.offsetHeight;
                hero.style.marginTop = totalHeight + 'px';
            }
            window.addEventListener('resize', updateHeroPosition);
            document.addEventListener('DOMContentLoaded', updateHeroPosition);

            // === LỌC SẢN PHẨM ===
            document.addEventListener('DOMContentLoaded', function () {
                const tabButtons = document.querySelectorAll('.tab-btn');
                const productCards = document.querySelectorAll('.product-card');

                tabButtons.forEach(btn => {
                    btn.addEventListener('click', () => {
                        tabButtons.forEach(b => b.classList.remove('active'));
                        btn.classList.add('active');

                        const category = btn.getAttribute('data-category');

                        productCards.forEach((card, index) => {
                            const cardCat = card.getAttribute('data-category');
                            const shouldShow = category === 'all' || cardCat === category;

                            if (shouldShow) {
                                card.style.display = 'block';
                                setTimeout(() => {
                                    requestAnimationFrame(() => card.classList.add('show'));
                                }, index * 50);
                            } else {
                                card.classList.remove('show');
                                setTimeout(() => {
                                    if (!card.classList.contains('show')) {
                                        card.style.display = 'none';
                                    }
                                }, 300);
                            }
                        });
                    });
                });

                // Hiển thị mặc định
                document.querySelector('.tab-btn[data-category="all"]').click();
            });
        </script>
    </body>
</html>