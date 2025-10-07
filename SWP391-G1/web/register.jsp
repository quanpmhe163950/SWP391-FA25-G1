<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
</head>
<body>
    <h2>Register</h2>

    <!-- Hiển thị thông báo lỗi -->
    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>

    <form action="register" method="post">
        <label>Username:</label><br/>
        <input type="text" name="username" required/><br/><br/>

        <label>Password:</label><br/>
        <input type="password" name="password" required/><br/><br/>

        <label>Confirm Password:</label><br/> 
        <input type="password" name="confirmPassword" required /><br/>

        <label>Full Name:</label><br/>
        <input type="text" name="fullname" required/><br/><br/>

        <label>Email:</label><br/>
        <input type="email" name="email" /><br/><br/>

        <label>Phone:</label><br/>
        <input type="text" name="phone" /><br/><br/>

        <button type="submit">Register</button>
    </form>

    <p>Already have an account? <a href="login">Login here</a></p>
</body>
</html>
