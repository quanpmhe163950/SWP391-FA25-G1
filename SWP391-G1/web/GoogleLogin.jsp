<%-- 
    Document   : LoginPage
    Created on : 30 thg 9, 2025, 06:16:59
    Author     : dotha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Đăng nhập — Pizza</title>
        <style>
            *,*::before,*::after{
                box-sizing:border-box
            }
            html,body{
                height:100%
            }
            body{
                margin:0;
                font-family: Roboto, 'Helvetica Neue', Arial, sans-serif;
                background: linear-gradient(180deg,#f5f7fb 0%, #ffffff 100%);
                color:#202124;
                display:flex;
                align-items:center;
                justify-content:center;
                padding:32px;
            }

            .card{
                width:100%;
                max-width:420px;
                background:#fff;
                border-radius:12px;
                box-shadow:0 10px 30px rgba(60,64,67,0.12);
                padding:28px 28px 20px;
                border:1px solid rgba(60,64,67,0.08);
            }

            .brand{
                display:flex;
                align-items:center;
                gap:12px;
                margin-bottom:18px
            }
            .brand .logo{
                width:40px;
                height:40px;
                border-radius:50%;
                display:grid;
                place-items:center;
                background: url('https://via.placeholder.com/40x40.png?text=P') no-repeat center/cover;
            }

            h1{
                font-size:20px;
                margin:0 0 6px
            }
            p.subtitle{
                margin:0 0 20px;
                color:#5f6368;
                font-size:14px
            }

            form{
                display:flex;
                flex-direction:column;
                gap:12px
            }
            label{
                font-size:13px;
                color:#3c4043
            }
            input[type=text],input[type=password]{
                width:100%;
                padding:12px 14px;
                border-radius:8px;
                border:1px solid #dfe1e5;
                font-size:15px;
                outline:none;
                transition:box-shadow .12s, border-color .12s
            }
            input[type=text]:focus,input[type=password]:focus{
                border-color:#1a73e8;
                box-shadow:0 1px 0 rgba(26,115,232,0.15)
            }

            .helper{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-top:6px
            }
            .checkbox{
                display:flex;
                align-items:center;
                gap:8px
            }
            .link{
                color:#1a73e8;
                text-decoration:none;
                font-size:14px
            }
            .btn{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                padding:10px 16px;
                border-radius:8px;
                border:none;
                font-weight:500;
                font-size:15px;
                cursor:pointer;
                background:#1a73e8;
                color:white;
                box-shadow:0 1px 1px rgba(0,0,0,0.05)
            }
            .btn[aria-disabled="true"]{
                opacity:0.6;
                cursor:not-allowed
            }

            .alt{
                display:flex;
                align-items:center;
                gap:8px;
                margin:14px 0
            }
            .alt::before,.alt::after{
                content:'';
                flex:1;
                height:1px;
                background:#e0e0e0;
                border-radius:1px
            }
            .alt span{
                font-size:13px;
                color:#5f6368
            }

            .error{
                color:#d93025;
                font-size:13px;
                margin-top:6px
            }
            .muted{
                font-size:13px;
                color:#5f6368
            }

            footer{
                margin-top:14px;
                text-align:center
            }
            @media (max-width:480px){
                body{
                    padding:20px
                }
                .card{
                    padding:20px
                }
            }

            :focus{
                outline:2px solid transparent
            }
            input:focus,button:focus,a:focus{
                box-shadow:0 0 0 3px rgba(26,115,232,0.12)
            }
        </style>
    </head>
    <body>
        <main class="card" role="main" aria-labelledby="signin-heading">
            <div class="brand">
                <div class="logo" aria-hidden="true">
                    <img src="image\z7061951110269_97de656e010792553d34b34b6d1df40c.jpg" alt="Pizza Food Logo" style="height:50px;">
                </div>
                <div>
                    <h1 id="signin-heading">Đăng nhập</h1>
                    <p class="subtitle">Tiếp tục đến dịch vụ của bạn</p>
                </div>
            </div>

            <form id="loginForm" novalidate>
                <div>
                    <label for="email">Email hoặc số điện thoại</label>
                    <input id="email" name="email" type="text" inputmode="email" autocomplete="email" required aria-describedby="emailHelp">
                    <div id="emailError" class="error" role="alert" aria-live="polite" hidden></div>
                </div>

                <div>
                    <label for="password">Mật khẩu</label>
                    <input id="password" name="password" type="password" autocomplete="current-password" required minlength="8" aria-describedby="passwordHelp">
                    <div id="passwordError" class="error" role="alert" aria-live="polite" hidden></div>
                </div>

                <div class="helper">
                    <label class="checkbox">
                        <input id="remember" name="remember" type="checkbox" aria-checked="false">
                        <span class="muted">Ghi nhớ tôi</span>
                    </label>
                    <a href="#" class="link">Quên mật khẩu?</a>
                </div>

                <div>
                    <button id="submitBtn" class="btn" type="submit">Đăng nhập</button>
                </div>

                <div class="alt"><span>Hoặc</span></div>

                <div>
                    <button id="googleBtn" type="button" class="btn" aria-label="Sign in with Google" style="background:transparent;border:1px solid #dfe1e5;color:#202124;">
                        <span style="display:inline-flex;align-items:center;gap:10px">
                            <svg width="18" height="18" viewBox="0 0 48 48" aria-hidden="true" focusable="false"><path fill="#4285F4" d="M24 9.5c3.54 0 6.36 1.53 8.26 2.84l6.04-6.04C35.9 3.02 30.33 1 24 1 14.6 1 6.9 6.7 3.2 14.9l7.2 5.6C12.7 14 17.8 9.5 24 9.5z"></path></svg>
                            <span>Đăng nhập bằng Google</span>
                        </span>
                    </button>
                </div>

            </form>

            <footer>
                <p class="muted">Không có tài khoản? <a class="link" href="#">Tạo tài khoản</a></p>
            </footer>
        </main>

        <script>
            (function () {
                const form = document.getElementById('loginForm');
                const email = document.getElementById('email');
                const password = document.getElementById('password');
                const submitBtn = document.getElementById('submitBtn');
                const emailError = document.getElementById('emailError');
                const passwordError = document.getElementById('passwordError');
                const remember = document.getElementById('remember');

                function validateEmail(value) {
                    return /^(?:[^@\s]+@[^@\s]+\.[^@\s]+)$/.test(value) || /^\+?[0-9]{7,15}$/.test(value);
                }

                function showError(el, msg) {
                    el.textContent = msg;
                    el.hidden = false;
                }
                function clearError(el) {
                    el.textContent = '';
                    el.hidden = true;
                }

                form.addEventListener('submit', function (e) {
                    e.preventDefault();
                    let valid = true;
                    clearError(emailError);
                    clearError(passwordError);

                    const emailVal = email.value.trim();
                    const passVal = password.value;

                    if (!emailVal) {
                        showError(emailError, 'Vui lòng nhập email hoặc số điện thoại.');
                        valid = false;
                    } else if (!validateEmail(emailVal)) {
                        showError(emailError, 'Địa chỉ email/số không hợp lệ.');
                        valid = false;
                    }

                    if (!passVal) {
                        showError(passwordError, 'Vui lòng nhập mật khẩu.');
                        valid = false;
                    } else if (passVal.length < 8) {
                        showError(passwordError, 'Mật khẩu phải ít nhất 8 ký tự.');
                        valid = false;
                    }

                    if (!valid) {
                        submitBtn.setAttribute('aria-disabled', 'true');
                        return;
                    }
                    submitBtn.setAttribute('aria-disabled', 'false');

                    submitBtn.textContent = 'Đang xử lý…';
                    submitBtn.disabled = true;

                    setTimeout(() => {
                        alert('Giả lập: Đã đăng nhập thành công (demo)\nEmail: ' + emailVal + "\nGhi nhớ: " + (remember.checked ? 'Có' : 'Không'));
                        submitBtn.textContent = 'Đăng nhập';
                        submitBtn.disabled = false;
                        form.reset();
                    }, 900);
                });

                remember.addEventListener('change', () => {
                    remember.setAttribute('aria-checked', remember.checked);
                });
                email.addEventListener('input', () => {
                    clearError(emailError);
                });
                password.addEventListener('input', () => {
                    clearError(passwordError);
                });

            })();
        </script>
    </body>
</html>

