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
            /* --- (Giữ nguyên style của bạn, chỉ rút gọn ở đây để dễ đọc) --- */
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
                margin:0;
                padding:0;
                box-sizing:border-box;
            }
            body {
                font-family:'Poppins',sans-serif;
                background:var(--bg);
                color:var(--text);
                line-height:1.6;
                padding-top:60px;
            }
            header{
                background:linear-gradient(135deg,var(--primary),var(--primary-dark));
                color:#fff;
                padding:6px 16px;
                display:flex;
                justify-content:space-between;
                align-items:center;
                box-shadow:0 4px 12px rgba(0,0,0,0.1);
                position:fixed;
                top:0;
                left:0;
                width:100%;
                z-index:1000;
                transition:transform .1s ease-out;
                transform:translateY(0);
            }
            .logo img{
                width:200px;
                height:auto;
                transition:transform .3s ease;
            }
            .auth-buttons{
                display:flex;
                gap:12px;
            }
            .btn-auth{
                background:rgba(255,255,255,.2);
                color:white;
                border:2px solid white;
                padding:6px 16px;
                font-size:.9em;
                font-weight:600;
                border-radius:25px;
                text-decoration:none;
                transition:all .3s .3s ease;
                backdrop-filter: blur(5px);
            }
            .btn-auth:hover{
                background:white;
                color:var(--primary);
                transform:translateY(-2px)
            }
            .btn-register{
                background:white;
                color:var(--primary)
            }
            .tab-menu{
                display:flex;
                justify-content:center;
                background:white;
                padding:15px 0;
                box-shadow:0 2px 8px rgba(0,0,0,.08);
                flex-wrap:wrap;
                position:fixed;
                left:0;
                width:100%;
                z-index:999;
                transition:top .3s ease;
            }
            .tab-btn{
                background:none;
                border:none;
                padding:12px 28px;
                font-size:1.1em;
                font-weight:600;
                color:var(--gray);
                cursor:pointer;
                transition:all .3s ease;
                position:relative;
            }
            .tab-btn.active{
                color:var(--primary)
            }
            .tab-btn.active::after{
                content:'';
                position:absolute;
                bottom:-6px;
                left:50%;
                transform:translateX(-50%);
                width:60px;
                height:4px;
                background:var(--primary);
                border-radius:2px;
            }
            .hero-slider{
                position:relative;
                width:100%;
                height:520px;
                margin-top:90px;
                overflow:hidden;
            }
            .slide{
                position:absolute;
                width:100%;
                height:100%;
                background-size:cover;
                background-position:center;
                display:flex;
                align-items:center;
                justify-content:center;
                opacity:0;
                transform:scale(1.05);
                transition:opacity 1s ease, transform 3s ease;
            }
            .slide.active{
                opacity:1;
                transform:scale(1)
            }
            .hero-content{
                text-align:center;
                color:white;
                text-shadow:0 6px 24px rgba(0,0,0,.7)
            }
            .hero-content h2{
                font-size:3.4em;
                font-weight:700;
                margin-bottom:12px
            }
            .container{
                max-width:1200px;
                margin:0 auto;
                padding:0 20px
            }
            .products{
                padding:30px 0 60px
            }
            .product-grid{
                display:grid;
                grid-template-columns:repeat(auto-fill,minmax(280px,1fr));
                gap:28px;
                margin-top:20px
            }
            .product-card{
                background:var(--white);
                border-radius:16px;
                overflow:hidden;
                box-shadow:0 6px 16px rgba(0,0,0,.1);
                display:none;
                opacity:0;
                transform:translateY(20px);
                transition:all .3s ease;
            }
            .product-card.show{
                display:block;
                opacity:1;
                transform:translateY(0);
                animation:fadeInUp .5s ease forwards
            }
            .product-card img{
                width:100%;
                height:240px;
                object-fit:cover;
                border-bottom:4px solid var(--primary)
            }
            .product-info{
                padding:22px;
                text-align:center
            }
            .product-info h3{
                color:var(--primary);
                font-size:1.35em;
                margin-bottom:10px;
                font-weight:600
            }
            .price{
                font-size:1.5em;
                font-weight:700;
                color:#2e7d32
            }
            footer{
                background:linear-gradient(135deg,var(--primary) 0%,var(--primary-dark) 100%);
                color:#fff;
                text-align:center;
                padding:20px 0;
                font-size:1.05em;
                margin-top:40px
            }
            @keyframes fadeInUp{
                from{
                    opacity:0;
                    transform:translateY(20px)
                }
                to{
                    opacity:1;
                    transform:translateY(0)
                }
            }
            /* Dropdown user */
            .user-dropdown{
                position:relative;
                display:inline-block
            }
            .dropdown-toggle{
                background:rgba(255,255,255,.18);
                border:2px solid white;
                color:white;
                padding:6px 14px;
                border-radius:28px;
                display:flex;
                align-items:center;
                gap:8px;
                font-weight:600;
                cursor:pointer;
                backdrop-filter:blur(6px)
            }
            .avatar{
                width:32px;
                height:32px;
                border-radius:50%;
                object-fit:cover;
                border:2px solid white
            }
            .dropdown-menu{
                position:absolute;
                top:120%;
                right:0;
                background:white;
                min-width:180px;
                border-radius:12px;
                box-shadow:0 8px 22px rgba(0,0,0,.15);
                overflow:hidden;
                opacity:0;
                visibility:hidden;
                transform:translateY(-8px);
                transition:all .3s ease;
                z-index:1000
            }
            .user-dropdown.open .dropdown-menu{
                opacity:1;
                visibility:visible;
                transform:translateY(0)
            }
            .dropdown-item{
                display:block;
                padding:12px 16px;
                color:#333;
                text-decoration:none;
                font-size:.95em
            }
            .dropdown-item.logout{
                color:#ff4d4f;
                font-weight:600
            }
            /* Blog */
            .blog-grid{
                display:grid;
                grid-template-columns:repeat(auto-fill,minmax(280px,1fr));
                gap:28px;
                margin-top:20px;
                padding-bottom:60px
            }
            .blog-card{
                background:var(--white);
                border-radius:16px;
                overflow:hidden;
                box-shadow:0 6px 16px rgba(0,0,0,.1);
                opacity:0;
                transform:translateY(20px);
                transition:all .3s ease
            }
            .blog-card img{
                width:100%;
                height:240px;
                object-fit:cover;
                border-bottom:4px solid var(--primary)
            }
            .blog-content{
                padding:20px;
                text-align:center
            }
            .blog-content h3{
                color:var(--primary);
                font-size:1.3em;
                margin-bottom:10px
            }
            .blog-content p{
                font-size:.95em;
                color:#555;
                height:auto;
                overflow:visible;
                display:block
            }
            @media (max-width:768px){
                body{
                    padding-top:110px
                }
                header{
                    flex-direction:column;
                    padding:10px;
                    text-align:center
                }
                .logo img{
                    width:160px
                }
            }
        </style>
    </head>
    <body>
        <p>Debug: ${blogList.size()}</p>


        <!-- HEADER -->
        <header>
            <div class="logo">
                <img src="image/logonotbg.png" alt="Pizza Delicioso">
            </div>
            <div class="auth-buttons">
                <%
                    HttpSession sess = request.getSession(false);
                    User user = (sess != null) ? (User) sess.getAttribute("account") : null;
                    if (user != null) {
                        String displayName = (user.getFullName() != null && !user.getFullName().isBlank())
                            ? user.getFullName() : user.getUsername();
                %>
                <div class="user-dropdown">
                    <button class="dropdown-toggle" type="button" id="userToggle">
                        <img src="image/account.png" alt="User" class="avatar">
                        <span class="username"><%= displayName %></span>
                        <i class="arrow-down"></i>
                    </button>
                    <div class="dropdown-menu">
                        <a href="cusinfo" class="dropdown-item">Thông tin cá nhân</a>
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
            <button class="tab-btn" data-category="blog">Blog</button>
        </div>

        <!-- CHUẨN BỊ BIẾN 'blogs' --> 
        <c:choose>
            <c:when test="${not empty blogList}">
                <c:set var="blogs" value="${blogList}" />
            </c:when>
            <c:otherwise>
                <c:set var="blogs" value="${blogList}" />
            </c:otherwise>
        </c:choose>

        <!-- HERO SLIDER - HIỂN THỊ ẢNH + TITLE CỦA BLOG -->
        <div class="hero-slider" id="hero-slider">
            <c:if test="${not empty blogList}">
                <c:forEach var="blog" items="${blogList}" varStatus="status">
                    <div class="slide ${status.first ? 'active' : ''}"
                         style="background-image: url('${pageContext.request.contextPath}/${blog.image}');">
                        <div class="hero-content">
                            <h2>${fn:escapeXml(blog.title)}</h2>
                        </div>
                    </div>
                </c:forEach>
            </c:if>

            <c:if test="${empty blogList}">
                <div class="slide active" style="background:#ddd; display:flex; align-items:center; justify-content:center;">
                    <div class="hero-content">
                        <h2>Không có bài viết nào</h2>
                    </div>
                </div>
            </c:if>

        </div>

        <!-- PRODUCTS -->
        <div class="container">
            <div class="products" id="products-section">
                <div class="product-grid">
                    <c:forEach var="item" items="${fullMenuList}">
                        <c:set var="catName" value="${not empty item.categoryName ? fn:toLowerCase(fn:trim(item.categoryName)) : 'all'}" />
                        <c:set var="cleanCat" value="${fn:replace(fn:replace(fn:replace(catName, ' ', ''), 'đ', 'd'), 'ồ', 'o')}" />
                        <c:set var="finalCat" value="all" />
                        <c:if test="${fn:contains(cleanCat, 'pizza')}"><c:set var="finalCat" value="pizza" /></c:if>
                        <c:if test="${fn:contains(cleanCat, 'pasta') or fn:contains(cleanCat, 'salad')}"><c:set var="finalCat" value="pasta" /></c:if>
                        <c:if test="${fn:contains(cleanCat, 'extra') or fn:contains(cleanCat, 'doanthêm')}"><c:set var="finalCat" value="extra" /></c:if>
                        <c:if test="${fn:contains(cleanCat, 'drink') or fn:contains(cleanCat, 'nuoc')}"><c:set var="finalCat" value="drink" /></c:if>

                            <div class="product-card" data-category="${finalCat}" data-item-id="${item.itemID}">
                            <img src="${pageContext.request.contextPath}/${item.imagePath}" alt="${fn:escapeXml(item.name)}">
                            <div class="product-info">
                                <h3>${fn:escapeXml(item.name)}</h3>
                                <p>${fn:escapeXml(item.description)}</p>
                                <select class="size-select" onchange="updatePrice(this, ${item.itemID})">
                                    <c:forEach var="sizePrice" items="${item.sizePriceList}">
                                        <option value="${sizePrice.size}" data-price="${sizePrice.price}" ${sizePrice.size == 'Vừa' ? 'selected' : ''}>
                                            ${sizePrice.size}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="price" id="price-${item.itemID}">
                                    <fmt:formatNumber value="${item.defaultPrice}" type="number" groupingUsed="true"/>đ
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- BLOG SECTION (mặc định ẩn, hiển thị khi click Tab Blog) -->
            <div id="blog-section" style="display:none; margin-top:40px;">
                <h2 style="text-align:center; color:var(--primary); margin-bottom:20px;">Bài Viết Mới</h2>
                <div class="blog-grid">
                    <c:forEach var="blog" items="${blogs}">
                        <div class="blog-card">
                            <img src="${pageContext.request.contextPath}/${blog.image}" alt="${fn:escapeXml(blog.title)}">
                            <div class="blog-content">
                                <h3>${fn:escapeXml(blog.title)}</h3>
                                <p>${fn:escapeXml(blog.content)}</p>
                                <p style="color:var(--gray); font-size:0.9em; margin-top:8px;">
                                    Đăng: <fmt:formatDate value="${blog.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                    <c:if test="${not empty blog.updatedDate}"> | Cập nhật: <fmt:formatDate value="${blog.updatedDate}" pattern="dd/MM/yyyy HH:mm" /></c:if>
                                    | Author ID: ${blog.authorID}
                                </p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- FOOTER -->
            <footer>
                <p>© 2025 SWP391-G1-PizzaShop – Thực đơn chỉ dành để xem | Liên hệ: 0898 260 423</p>
            </footer>
        </div>

        <!-- JAVASCRIPT -->
        <script>
            function updatePrice(select, itemId) {
                const price = select.selectedOptions[0].dataset.price;
                const formatted = new Intl.NumberFormat('vi-VN').format(price);
                document.getElementById('price-' + itemId).innerHTML = formatted + 'đ';
            }

            document.addEventListener('DOMContentLoaded', () => {
                // ===== HEADER DI CHUỘT =====
                const header = document.querySelector('header');
                let mouseX = 0, mouseY = 0;
                let headerX = 0, headerY = 0;
                document.addEventListener('mousemove', e => {
                    mouseX = e.clientX / window.innerWidth - 0.5;
                    mouseY = e.clientY / window.innerHeight - 0.5;
                });
                const animateHeader = () => {
                    headerX += (mouseX * 30 - headerX) * 0.1;
                    headerY += (mouseY * 15 - headerY) * 0.1;
                    header.style.transform = `translate(${headerX}px, ${headerY}px)`;
                    requestAnimationFrame(animateHeader);
                };
                requestAnimationFrame(animateHeader);

                // ===== TAB MENU & PRODUCT FILTER =====
                const tabButtons = document.querySelectorAll('.tab-btn');
                const productCards = document.querySelectorAll('.product-card');
                const blogSection = document.getElementById('blog-section');
                const productsSection = document.getElementById('products-section');

                tabButtons.forEach(btn => {
                    btn.addEventListener('click', () => {
                        const category = btn.dataset.category;

                        // XÓA ACTIVE
                        tabButtons.forEach(b => b.classList.remove('active'));
                        btn.classList.add('active');

                        if (category === 'blog') {
                            // Ẩn sản phẩm, hiện phần blog
                            if (productsSection)
                                productsSection.style.display = 'none';
                            if (blogSection) {
                                blogSection.style.display = 'block';
                                blogSection.scrollIntoView({behavior: 'smooth', block: 'start'});
                            }
                        } else {
                            // Hiện sản phẩm, ẩn blog
                            if (productsSection)
                                productsSection.style.display = 'block';
                            if (blogSection)
                                blogSection.style.display = 'none';

                            // LỌC SẢN PHẨM
                            productCards.forEach((card, i) => {
                                const cardCat = card.dataset.category;
                                const shouldShow = (category === 'all') || (cardCat === category);

                                if (shouldShow) {
                                    card.style.opacity = '0';
                                    card.style.visibility = 'visible';
                                    card.style.display = 'block';

                                    setTimeout(() => {
                                        card.style.opacity = '1';
                                        card.classList.add('show');
                                    }, i * 50);
                                } else {
                                    card.style.opacity = '0';
                                    card.classList.remove('show');

                                    setTimeout(() => {
                                        card.style.visibility = 'hidden';
                                        card.style.display = 'none';
                                    }, 300);
                                }
                            });
                        }
                    });
                });

                // MẶC ĐỊNH: HIỆN "TẤT CẢ"
                const btnAll = document.querySelector('.tab-btn[data-category="all"]');
                if (btnAll)
                    btnAll.click();

                // ===== HERO SLIDER =====
                const slides = document.querySelectorAll('.slide');
                if (slides.length > 0) {
                    let currentSlide = 0;
                    const showSlide = index => {
                        slides.forEach(s => s.classList.remove('active'));
                        slides[index].classList.add('active');
                    };
                    setInterval(() => {
                        currentSlide = (currentSlide + 1) % slides.length;
                        showSlide(currentSlide);
                    }, 4000);
                }

                // ===== FADE-IN BLOG =====
                const blogCards = document.querySelectorAll('.blog-card');
                blogCards.forEach((card, i) => {
                    setTimeout(() => {
                        card.style.opacity = 1;
                        card.style.transform = 'translateY(0)';
                    }, i * 100);
                });

                // ===== DROPDOWN USER =====
                const userDropdown = document.querySelector('.user-dropdown');
                if (userDropdown) {
                    const toggleBtn = userDropdown.querySelector('.dropdown-toggle');
                    toggleBtn.addEventListener('click', e => {
                        e.stopPropagation();
                        userDropdown.classList.toggle('open');
                        toggleBtn.classList.toggle('active');
                    });

                    document.addEventListener('click', () => {
                        if (userDropdown.classList.contains('open')) {
                            userDropdown.classList.remove('open');
                            toggleBtn.classList.remove('active');
                        }
                    });
                }

                // ===== CẬP NHẬT VỊ TRÍ TAB MENU =====
                const tabMenu = document.querySelector('.tab-menu');
                const hero = document.querySelector('.hero-slider');

                const updateTabMenu = () => {
                    if (tabMenu)
                        tabMenu.style.top = header.offsetHeight + 'px';
                };
                const updateHeroPosition = () => {
                    if (hero && tabMenu)
                        hero.style.marginTop = (header.offsetHeight + tabMenu.offsetHeight) + 'px';
                };
                window.addEventListener('resize', () => {
                    updateTabMenu();
                    updateHeroPosition();
                });
                updateTabMenu();
                updateHeroPosition();
            });
        </script>
    </body>
</html>
