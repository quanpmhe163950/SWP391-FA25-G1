<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Tài khoản khách hàng</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
            }

            .navbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 30px;
                background: #f8f8f8;
                border-bottom: 1px solid #ddd;
            }
            .navbar img {
                display: block;
            }
            .user-info {
                display: flex;
                align-items: center;
                font-size: 18px;
            }

            .account-container {
                display: flex;
                gap: 20px;
                margin-top: 20px;
                font-size: 20px;
            }
            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-content {
                display: none;
                position: absolute;
                background-color: #f9f9f9;
                min-width: 160px;
                box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
                z-index: 1;
                border-radius: 4px;
                right: 0;
            }

            .dropdown-content a {
                color: black;
                padding: 12px 16px;
                text-decoration: none;
                display: block;
                font-family: Arial, sans-serif;
            }

            .dropdown-content a:hover {
                background-color: #fff0e6;
                color: #ff6600;
            }

            .dropdown-content.show {
                display: block;
            }

            .menu-left {
                width: 200px;
                background: #fafafa;
                border: 1px solid #ddd;
                border-radius: 6px;
                padding: 15px;
            }
            .edit-info {
                display: block;
                padding: 8px 0;
                font-size: 25px;
                color: #ff6600; /* ĐÃ ĐỔI */
                cursor: pointer;
                border-bottom: 1px solid #eee;
                margin: 20px auto;
                transition: all 0.2s ease;
            }
            .edit-info:hover {
                color: #e55a00;
                padding-left: 8px;
            }
            .edit-info:last-child {
                border-bottom: none;
            }

            .content-right {
                flex: 1;
                min-height: 300px;
                border-left: 1px solid #ddd;
                padding-left: 20px;
            }
            .content {
                padding: 10px;
                font-size: 20px;
            }
            .edit-btn {
                float: right;
                cursor: pointer;
                font-size: 18px;
                color: #ff6600; /* ĐÃ ĐỔI */
                text-decoration: underline;
                font-weight: 600;
            }
            .edit-btn:hover {
                color: #e55a00;
            }
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 20px;
            }
            td {
                padding: 10px;
                vertical-align: middle;
            }
            .label-col {
                width: 30%;
                font-weight: bold;
            }
            .value-col {
                width: 40%;
            }
            .action-col {
                width: 30%;
                text-align: right;
            }
            footer {
                background: #222;
                color: #ccc;
                text-align: center;
                padding: 15px;
                font-size: 0.95em;
                margin-top: 20px;
            }
            .edit-info.active {
                color: #028F46; 
                font-weight: bold;
                border-left: 4px solid #028F46;
                padding-left: 8px;
                background: #fff8f0;
            }

           
            .user-info span {
                color: #ff6600;
                font-weight: 600;
            }

           
            .account-title span {
                color: #ff6600;
                font-weight: bold;
            }
        </style>
    </head>
    <body onload="showInformation()">

        <div class="navbar">
            <div><img src="images/logo.jpg" alt="Logo" width="250"></div>
            <div class="user-info">
                <div class="dropdown">
                    <button style="background:none;border:none;padding:0;cursor:pointer;" type="button" onclick="toggleDropdown()">
                        <img src="images/account.png" alt="User" width="40" style="margin-right:10px;">
                    </button>
                    <div id="dropdownMenu" class="dropdown-content">
                        <a href="#">Tài Khoản</a>
                        <a href="#">Đăng xuất</a>
                    </div>
                </div>
                <span>${account.fullName}</span>
            </div>
        </div>

        <table>
            <tr>
                <td>
                    <h3 style="margin-left: 20px; font-size: 25px;">Tài khoản của</h3>
                    <span style="color: #ff6600;margin-left: 20px; font-size: 25px;">${account.fullName}</span>
                </td>

            </tr>



        </table> 

        <div class="account-container">
            <div class="menu-left">
                <a class="edit-info" href="cusinfor">Thông tin khách hàng</a>
                <a class="edit-info"href="orderhistory">Lịch sử mua hàng</a>

                <span class="edit-info" onclick="showVoucher()">Voucher của tôi</span>
                <a class="edit-info" href="changepass">Đổi mật khẩu</a>
            </div>

            <div class="content-right" id="contentArea">
                <jsp:include page="${pageContent}" />
            </div>
        </div>


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
            function showVoucher() {
                alert("Chưa làm cái này");
            }
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
