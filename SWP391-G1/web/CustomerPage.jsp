<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Tài khoản khách hàng</title>
        <style>
            :root {
                --primary: #ff6600;
                --primary-dark: #e55a00;
                --text-dark: #333;
                --success-green: #028F46;
                --bg-light: #fff8f0;
            }

            /* ===== RESET + FONT ===== */
            body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
                background: #f8f8f8;
                color: var(--text-dark);
                line-height: 1.6;
                font-weight: 600;
            }

            /* ===== NAVBAR ===== */
            .navbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 16px 40px; /* giữ nguyên như homepage */
                background: linear-gradient(135deg, var(--primary), var(--primary-dark));
                color: white;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .navbar img {
                height: auto; /* giữ nguyên logo homepage */
                width: 200px;
                transition: transform 0.3s ease;
            }

            .navbar img:hover {
                transform: scale(1.05);
            }

            .user-info {
                display: flex;
                align-items: center;
                font-size: 1em; /* giữ vừa phải, giống homepage */
                font-weight: 700;
                gap: 10px;
            }

            .user-info span {
                color: white;
            }

            /* ===== ACCOUNT + MENU LEFT ===== */
            .account-container {
                display: flex;
                gap: 25px;
                max-width: 1200px;
                margin: 30px auto 60px auto;
                padding: 0 20px;
                align-items: flex-start;
            }

            .menu-left {
                width: 300px;
                background: #fff;
                border-radius: 16px;
                padding: 25px 20px;
                box-shadow: 0 6px 20px rgba(0,0,0,0.15);
                display: flex;
                flex-direction: column;
                gap: 25px;
            }

            /* ===== ACCOUNT INFO TRONG MENU LEFT ===== */
            .menu-left .account-info {
                text-align: center;
            }

            .menu-left .account-info h3 {
                font-size: 1.6em;
                font-weight: 800;
                margin-bottom: 10px;
                color: var(--primary);
            }

            .menu-left .account-info .account-name {
                font-size: 1.4em;
                font-weight: 700;
                color: var(--success-green);
            }

            /* ===== MENU LINKS ===== */
            .menu-left .edit-info {
                display: block;
                padding: 14px 12px;
                font-size: 1.15em;
                font-weight: 700;
                color: var(--primary);
                border-radius: 8px;
                transition: all 0.25s ease;
                text-decoration: none;
            }

            .menu-left .edit-info:hover,
            .menu-left .edit-info.active {
                background-color: var(--bg-light);
                padding-left: 20px;
                font-weight: 800;
            }

            /* ===== CONTENT RIGHT ===== */
            .content-right {
                flex: 1;
                min-height: 400px;
                background: #fff;
                border-radius: 16px;
                padding: 35px 40px;
                box-shadow: 0 6px 20px rgba(0,0,0,0.12);
                font-weight: 600;
            }

            .content-right h3 {
                font-size: 1.6em;
                font-weight: 800;
                color: var(--primary);
                text-align: center;
                margin-bottom: 25px;
            }

            /* ===== TABLE THÔNG TIN ===== */
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 18px;
                margin-top: 10px;
            }

            td {
                padding: 10px;
                vertical-align: middle;
                font-size: 1.15em;
                font-weight: 600;
            }

            .label-col {
                width: 30%;
                font-weight: 700;
                color: var(--primary);
            }

            .value-col {
                width: 40%;
            }

            /* ===== DROPDOWN ===== */
            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-content {
                display: none;
                position: absolute;
                background-color: #ffffff;
                min-width: 200px;
                box-shadow: 0 8px 20px rgba(255, 102, 0, 0.25);
                z-index: 1;
                border-radius: 10px;
                border: 1px solid #ffcc99;
                right: 0;
                top: 100%;
            }

            .dropdown-content a {
                color: #333;
                padding: 14px 16px;
                text-decoration: none;
                display: block;
                font-size: 1.1em;
                font-weight: 600;
            }

            .dropdown-content a:hover {
                background-color: var(--bg-light);
                color: var(--primary);
                padding-left: 22px;
            }

            .dropdown-content.show {
                display: block;
            }

            /* ===== FOOTER ===== */
            footer {
                background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
                color: #fff;
                text-align: center;
                padding: 20px 0;
                font-size: 1.05em;
            }

            /* ===== RESPONSIVE ===== */
            @media (max-width: 768px) {
                .account-container {
                    flex-direction: column;
                    gap: 20px;
                    padding: 0 15px;
                }
                .menu-left {
                    width: 100%;
                    padding: 20px;
                }
                .content-right {
                    padding: 25px 20px;
                }
                .navbar {
                    flex-direction: column;
                    padding: 15px 20px;
                }
                .navbar img {
                    height: 60px; /* giữ nguyên */
                }

            }
            .dropdown img{
                width: 60px;
                height: auto;
            }

        </style>

    </head>
    <body>

        <div class="navbar">
            <div><img src="image/logonotbg.png" alt="Logo" width="250"></div>
            <div class="user-info">
                <div class="dropdown">
                    <button style="background:none;border:none;padding:0;cursor:pointer;" type="button" onclick="toggleDropdown()">
                        <img src="image/account.png" alt="User" width="40" style="margin-right:10px;">
                    </button>
                    <div id="dropdownMenu" class="dropdown-content">
                        <a href="cusinfo">Tài Khoản</a>
                        <a href="logout">Đăng xuất</a>
                    </div>
                </div>
                <span>${account.fullName}</span>
            </div>
        </div>
        <div class="account-container">
            <!-- LEFT MENU: Account + Menu -->
            <div class="menu-left">
                <!-- Phần Tài khoản -->
                <div class="account-info">
                    <h3>Tài khoản của</h3>
                    <span class="account-name">${account.fullName}</span>
                </div>
                <!-- Menu điều hướng -->
                
                <a class="edit-info" href="${pageContext.request.contextPath}/cusinfo">Thông tin khách hàng</a>
                <a class="edit-info" href="${pageContext.request.contextPath}/orderhistory">Lịch sử mua hàng</a>
                <a class="edit-info" href="${pageContext.request.contextPath}/changepass">Đổi mật khẩu</a>
            </div>

            <!-- RIGHT CONTENT -->
            <div class="content-right" id="contentArea">
                <c:choose>
                    <c:when test="${not empty pageContent}">
                        <jsp:include page="${pageContent}" />
                    </c:when>
                    <c:otherwise>
                        <!-- MẶC ĐỊNH: HIỂN THỊ THÔNG TIN KHÁCH HÀNG -->
                        <jsp:include page="CusInfo.jsp" />
                    </c:otherwise>
                </c:choose>
            </div>        </div>



        <script>
////          function showInformation() {
//               fetch('cusinfor')
//                      .then(response => response.text())
//                      .then(html => {
//                           document.getElementById('contentArea').innerHTML = html;
//                       })
//                      .catch(err => console.log(err));
//            }
//            function editInfo() {
//                alert("Chưa làm cái này");
//            }
//            function showHistory() {
//                alert("Chưa làm cái này");
//            }

            function changePassword() {
                fetch('changepass')
                        .then(response => response.text())
                        .then(html => {
                            document.getElementById('contentArea').innerHTML = html;
                        })
                        .catch(err => console.log(err));
            }
            function toggleDropdown() {
                document.getElementById("dropdownMenu").classList.toggle("show");
            }

            window.onclick = function (event) {
                if (!event.target.closest('.dropdown')) {
                    var dropdowns = document.getElementsByClassName("dropdown-content");
                    for (var i = 0; i < dropdowns.length; i++) {
                        var openDropdown = dropdowns[i];
                        if (openDropdown.classList.contains('show')) {
                            openDropdown.classList.remove('show');
                        }
                    }
                }
            }
        </script>


        <footer>
            <p>© 2025 SWP391-G1-PizzaShop – Thực đơn chỉ dành để xem | Liên hệ: 0898 260 423</p>
        </footer>
    </body>
</html>
