<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0px 4px 15px rgba(0,0,0,0.1);
            width: 350px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        .error {
            color: #ff4d4f;
            background: #fff1f0;
            border: 1px solid #ffa39e;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
            text-align: center;
        }

        label {
            font-weight: bold;
            margin-top: 10px;
            display: block;
            color: #333;
        }

        input[type="text"],
        input[type="password"],
        input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            transition: 0.3s;
            font-size: 14px;
        }

        input:focus {
            border-color: #ff4d4f;
            box-shadow: 0 0 5px rgba(255, 77, 79, 0.5);
            outline: none;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #ff4d4f;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background: #d9363e;
        }

        p {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
        }

        a {
            color: #ff4d4f;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Register</h2>

        <!-- Hiển thị thông báo lỗi nếu có -->
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form action="register" method="post">
            <label>Username:</label>
            <input type="text" name="username" value="${param.username}" required />

            <label>Password:</label>
            <input type="password" name="password" required />

            <label>Confirm Password:</label>
            <input type="password" name="confirmPassword" required />

            <label>Full Name:</label>
            <input type="text" name="fullname" value="${param.fullname}" required />

            <label>Email:</label>
            <input type="email" name="email" value="${param.email}" required />

            <label>Phone:</label>
            <input type="text" name="phone" value="${param.phone}" required />

            <button type="submit">Register</button>
        </form>

        <p>Already have an account? <a href="login">Login here</a></p>
    </div>
</body>
</html>
