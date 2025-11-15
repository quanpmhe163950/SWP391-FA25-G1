<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            body {
                background-color: #f3f4f6;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                font-family: Arial, sans-serif;
            }
            .container {
                background-color: #ffffff;
                padding: 2rem;
                border-radius: 0.5rem;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 400px;
            }
            h2 {
                font-size: 1.5rem;
                font-weight: bold;
                margin-bottom: 1.5rem;
                text-align: center;
                color: #1f2937;
            }
            /* THÊM DÒNG NÀY: ĐỔI MÀU TIÊU ĐỀ */
            h2 {
                color: #ff6600 !important;  /* Cam #ff6600 */
            }
            .form-group {
                margin-bottom: 1rem;
            }
            label {
                display: block;
                font-size: 0.875rem;
                font-weight: 500;
                color: #374151;
                margin-bottom: 0.25rem;
            }
            input {
                width: 100%;
                padding: 0.5rem;
                border: 1px solid #d1d5db;
                border-radius: 0.25rem;
                font-size: 1rem;
                box-sizing: border-box;
            }
            input:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.5);
            }
            .button-group {
                display: flex;
                justify-content: flex-end;
                gap: 1rem;
                margin-top: 1rem;
            }
            button {
                padding: 0.5rem 1rem;
                border: none;
                border-radius: 0.25rem;
                font-size: 1rem;
                cursor: pointer;
                color: #ffffff;
            }
            .cancel-btn {
                background-color: #6b7280;
            }
            .cancel-btn:hover {
                background-color: #4b5563;
            }
            /* SỬA DÒNG NÀY: ĐỔI MÀU NÚT XÁC NHẬN */
            .submit-btn {
                background-color: #ff6600;  /* Cam #ff6600 */
            }
            .submit-btn:hover {
                background-color: #e55a00;  /* Cam đậm hơn khi hover */
            }
            /* THÊM CSS CHO THÔNG BÁO LỖI/THÀNH CÔNG (NẾU CÓ) */
            .error {
                color: red;
                margin-bottom: 1rem;
                text-align: center;
            }
            .success {
                color: green;
                margin-bottom: 1rem;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Chỉnh sửa thông tin khách hàng</h2>  <!-- BÂY GIỜ MÀU CAM -->
            <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getParameter("success") != null) { %>
            <div class="success">Cập nhật thông tin thành công!</div>
            <% } %>
            <form action="editinfo" method="post">
                <input type="hidden" name="id" value="${customer != null ? customer.userID : param.id}">
                <div class="form-group">
                    <label for="name">Họ và tên</label>
                    <input type="text" id="name" name="name" value="${customer != null ? customer.fullName : ''}" required>
                </div>
                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input type="tel" id="phone" name="phone" pattern="[0-9]{10}" value="${customer != null ? customer.phone : ''}" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="${customer != null ? customer.email : ''}" required>
                </div>
                <div class="button-group">
                    <button type="button" class="cancel-btn" 
                            onclick="window.location.href = 'cusinfo?id=${customer.userID}'">
                        Hủy
                    </button>
                    <button type="submit" class="submit-btn">Xác nhận</button>
                </div>
            </form>
        </div>
    </body>
</html>