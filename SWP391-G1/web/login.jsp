<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>

    <!-- Hiển thị thông báo lỗi -->
    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>

    <!-- Hiển thị thông báo khi đăng ký thành công -->
    <c:if test="${param.msg == 'register_success'}">
        <p style="color:green;">Register successful! Please login.</p>
    </c:if>

    <form action="login" method="post">
        <label>Username:</label><br/>
        <input type="text" name="username" required/><br/><br/>

        <label>Password:</label><br/>
        <input type="password" name="password" required/><br/><br/>

        <button type="submit">Login</button>
    </form>

    <p>Don't have an account? <a href="register">Register here</a></p>
</body>
</html>
