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
                margin:0;
                padding:0;
            }

            .navbar {
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:15px 30px;
                background:#f8f8f8;
                border-bottom:1px solid #ddd;
            }
            .navbar img {
                display:block;
            }
            .user-info {
                display:flex;
                align-items:center;
                font-size:18px;
            }

            .account-container {
                display: flex;
                gap: 20px;
                margin-top: 20px;
                font-size: 20px;
            }

            .menu-left {
                width:200px;
                background:#fafafa;
                border:1px solid #ddd;
                border-radius:6px;
                padding:15px;

            }
            .edit-info {
                display:block;
                padding:8px 0;
                font-size:17px;
                color:#028F46;
                cursor:pointer;
                border-bottom:1px solid #eee;
                font-size: 25px;
                margin: 20px auto;
            }
            .edit-info:last-child{
                border-bottom:none;
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
                color: #1E90FF;
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
            .footer-contact {
                background-color:#028F46;
                color:#fff;
                padding:30px 20px;
                font-family:Arial,sans-serif;
            }
            .footer-container {
                display:flex;
                justify-content:space-between;
                align-items:flex-start;
                max-width:1200px;
                margin:0 auto;
                gap:50px;
            }
            .footer-left {
                display:flex;
                gap:30px;
            }
            .footer-left img {
                width:200px;
                height:auto;
            }
            .footer-info h4 {
                margin:0 0 10px;
                font-size:18px;
            }
            .footer-info p,
            .footer-info a {
                color:#fff;
                text-decoration:none;
                font-size:16px;
                line-height:1.5;
                margin:0 0 5px;
            }
            .footer-right {
                margin-top:10px;
            }
            .footer-bottom {
                text-align:center;
                margin-top:20px;
                font-size:14px;
                opacity:.8;
            }
        </style>
    </head>
    <body>
        
        <div class="navbar">
            <div><img src="images/logo.jpg" alt="Logo" width="250"></div>
            <div class="user-info"> 
                <button style="background:none;border:none;padding:0;cursor:pointer;" type="button" onclick="alert('Bạn đã bấm ảnh!')">
                    <img src="images/account.png" alt="User" width="40" style="margin-right:10px;">
                    
                </button>
                <span>${a.name}</span>
            </div>
        </div>

        <table>
            <tr>
                <td>
                    <h3 style="margin-left: 20px; font-size: 25px;">Tài khoản của</h3>
                    <span style="color: #028F46;margin-left: 20px; font-size: 25px;">${a.name}</span>
                </td>

            </tr>



        </table> 
        <div class="account-container">

            <div class="menu-left">      
                <p class="edit-info">Thông tin khách hàng</p>
                <span class="edit-info" onclick="showHistory()">Lịch sử mua hàng</span>
                <span class="edit-info" onclick="showVoucher()">Voucher của tôi</span>
                <span class="edit-info" onclick="changePassword()">Đổi mật khẩu</span>
            </div>


            <div class="content-right" id="contentArea">
                <div class="content">
                    <h2 style="text-align: center;">Thông tin chung</h2>
                    <table>
                        <tr>
                            <td class="label-col">Họ và tên</td>
                            <td class="value-col">${a.name}</td>
                            <td class="action-col">
                                <span class="edit-btn" onclick="editInfo()">Chỉnh sửa thông tin</span>
                            </td>
                        </tr>
                        <tr>
                            <td class="label-col">Số điện thoại</td>
                            <td class="value-col">${a.phonenumber}</td>
                            <td class="action-col"></td>
                        </tr>
                        <tr>
                            <td class="label-col">Email</td>
                            <td class="value-col">${a.gmail}</td>
                            <td class="action-col"></td>
                        </tr>
                    </table>
                </div>
                            
            </div>
        </div>

        <script>
            function editInfo() {
                 alert("Chưa làm cái này");
            }
            function showHistory() {
                alert("Chưa làm cái này");
            }
            function showVoucher() {
                alert("Chưa làm cái này");
            }
            function changePassword() {
                fetch('ChangePassword.jsp')
                        .then(response => response.text())
                        .then(html => {
                            document.getElementById('contentArea').innerHTML = html;
                        })
                        .catch(err => console.log(err));
            }
        </script>


        <footer class="footer-contact">
            <div class="footer-container">
                <div class="footer-left">
                    <img src="images/logonotbg.png" alt="Logo">
                    <div class="footer-info">
                        <h4>Liên hệ</h4>
                        <p><strong>The SWP PIZZA 391</strong></p>
                        <p>Địa chỉ: Đại học FPT, khu Công nghệ cao Hòa Lạc, Hà Nội</p>
                        <p>Email: cskh@qsrvietnam.com</p>
                        <p>Giờ làm việc: 9:30 – 21:30 tất cả các ngày</p>
                    </div>
                </div>

                <div class="footer-right">
                    <h4>Kết nối với chúng tôi</h4>
                    <div class="social-links">
                        <a href="#"><img src="images/fb_logo.png" alt="Facebook" width="30"></a>
                        <a href="#"><img src="images/ig_logo.png" alt="Instagram" width="30"></a>
                        <a href="#"><img src="images/x_lolo.png" alt="Twitter" width="45"></a>
                    </div>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; 2025 The SWP PIZZA 391. Bảo lưu mọi quyền.</p>
            </div>
        </footer>
    </body>
</html>
