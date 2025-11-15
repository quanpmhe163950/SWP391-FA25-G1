<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div class="content" style="width: 100%; padding: 20px; box-sizing: border-box;">

    <h2 style="
        text-align: center; 
        color: #FF8800; 
        margin-bottom: 25px;
        font-family: Arial, sans-serif;
        font-size: 26px;
        font-weight: bold;">
        Đổi mật khẩu
    </h2>

    <!-- THÔNG BÁO LỖI -->
    <c:if test="${error != null && error.trim() != ''}">
        <div style="
            padding: 12px; 
            background: #fde2e2; 
            color: #a30000; 
            border-radius: 6px; 
            text-align: center;
            margin-bottom: 20px;
            font-family: Arial;">
            ${error}
        </div>
    </c:if>

    <!-- THÔNG BÁO THÀNH CÔNG -->
    <c:if test="${success != null && success.trim() != ''}">
        <div style="
            padding: 12px; 
            background: #e1f8e7; 
            color: #0d7a3a; 
            border-radius: 6px; 
            text-align: center;
            margin-bottom: 20px;
            font-family: Arial;">
            ${success}
        </div>
    </c:if>

    <form action="changepass" method="post" 
          style="max-width: 500px; margin: 0 auto; font-family: Arial, sans-serif;">

        <!-- CURRENT PASSWORD -->
        <div style="margin-bottom: 18px;">
            <label style="display: block; margin-bottom: 6px; font-weight: bold;">
                Mật khẩu hiện tại:
            </label>
            <input type="password" name="currentPassword" required
                   style="width: 100%; padding: 10px; font-size: 16px; 
                          border-radius: 6px; border: 1px solid #ccc;">
        </div>

        <!-- NEW PASSWORD -->
        <div style="margin-bottom: 18px;">
            <label style="display: block; margin-bottom: 6px; font-weight: bold;">
                Mật khẩu mới:
            </label>
            <input type="password" name="newPassword" required minlength="6"
                   style="width: 100%; padding: 10px; font-size: 16px; 
                          border-radius: 6px; border: 1px solid #ccc;">
        </div>

        <!-- CONFIRM PASSWORD -->
        <div style="margin-bottom: 18px;">
            <label style="display: block; margin-bottom: 6px; font-weight: bold;">
                Xác nhận mật khẩu mới:
            </label>
            <input type="password" name="confirmPassword" required minlength="6"
                   style="width: 100%; padding: 10px; font-size: 16px; 
                          border-radius: 6px; border: 1px solid #ccc;">
        </div>

        <!-- BUTTON -->
        <button type="submit"
                style="display: block; margin: 0 auto; margin-top: 10px;
                       width: 180px; padding: 10px; font-size: 18px;
                       background: #FF8800; color: white; border: none;
                       border-radius: 6px; cursor: pointer;">
            Cập nhật
        </button>
    </form>

</div>
