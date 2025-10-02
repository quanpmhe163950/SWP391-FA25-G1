<%-- 
    Document   : ChangePassword
    Created on : 29 thg 9, 2025, 23:18:32
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>

            .change-password-container {
                max-width: 500px;
                margin: 40px auto;
                text-align: center;
                font-size: 20px;
                font-family: Arial, sans-serif;
                margin-top: 0px;

            }

            .change-password-container h2 {
                font-size: 24px;
                margin-bottom: 20px;
                color: #028F46;
            }

            .change-password-container .mb-3 {
                margin-bottom: 15px;
                text-align: left;
            }

            .change-password-container label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }

            .change-password-container input[type="password"] {
                width: 100%;
                padding: 8px;
                font-size: 16px;
                border-radius: 5px;
                border: 1px solid #ccc;
            }

            .change-password-container .btn-primary {
                display: block;
                margin: 15px auto;
                width: 150px;
                padding: 6px 10px;
                font-size: 18px;
                background-color: #028F46;
                border: none;
                border-radius: 5px;
                color: #fff;
                cursor: pointer;
                margin-top: 30px;

            }


            .change-password-container .btn-primary:hover {
                background-color: #026c35; /* màu khi hover */
            }
            .edit-btn {
                float: left;
                cursor: pointer;
                font-size: 18px;
                color: #1E90FF;
            }
        </style>
    </head>
    <body>

        <form action="changepass" method="post">
            <div class="change-password-container">
                <h2>Thông tin - Đổi mật khẩu</h2>

                <div class="mb-3">
                    <label>Mật khẩu hiện tại:</label>
                    <input type="password" name="currentPassword" required>
                </div>

                <div class="mb-3">
                    <label>Mật khẩu mới:</label>
                    <input type="password" name="newPassword" required minlength="6">
                </div>

                <div class="mb-3">
                    <label>Xác nhận mật khẩu mới:</label>
                    <input type="password" name="confirmPassword" required minlength="6">
                </div>
                <div>
                    <span class="edit-btn" onclick="FogotPassword()">Quên mật khẩu</span>
                </div>
                <button type="submit" class="btn-primary">Cập nhật</button>
            </div>
        </form>
        <% if(request.getAttribute("error") != null){ %>
        <div class="alert alert-danger mt-3"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if(request.getAttribute("success") != null){ %>
        <div class="alert alert-success mt-3"><%= request.getAttribute("success") %></div>
        <% } %>

    </body>
</html>