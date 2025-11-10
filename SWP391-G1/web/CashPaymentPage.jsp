<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thanh Toán Tiền Mặt</title>
        <!-- 🎨 STYLE (Cam – Trắng chủ đạo) -->
        <style>
            :root {
                --brand-color: #ff7b00;
                --brand-hover: #e56a00;
                --bg-light: #ffffff;
                --text-dark: #333333;
                --border-color: #ffddb0;
                --box-bg: #fff7ef;
            }
            body {
                font-family: "Segoe UI", Arial, sans-serif;
                background-color: var(--bg-light);
                margin: 0;
                padding: 0;
                color: var(--text-dark);
            }
            /* HEADER */
            header {
                background-color: #fff;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 40px;
                box-shadow: 0 2px 8px rgba(255, 123, 0, 0.1);
                position: sticky;
                top: 0;
                z-index: 10;
                border-bottom: 2px solid var(--brand-color);
            }
            .logo img {
                height: 45px;
                width: auto;
                cursor: pointer;
                transition: 0.3s;
            }
            .logo img:hover {
                transform: scale(1.05);
            }
            .icons {
                display: flex;
                align-items: center;
                gap: 15px;
            }
            .icons span {
                font-size: 22px;
                cursor: pointer;
                transition: 0.3s;
            }
            .icons span:hover {
                color: var(--brand-color);
            }
            /* PAYMENT SECTION */
            main {
                position: relative;
                display: flex;
                justify-content: center;
                align-items: flex-start;
                height: calc(100vh - 80px);
                padding: 40px;
                background: linear-gradient(180deg, #fffaf5 0%, #ffffff 100%);
            }
            .back-container {
                position: absolute;
                left: 60px;
                top: 30px;
            }
            .payment-box {
                background-color: var(--box-bg);
                padding: 30px 40px;
                border-radius: 14px;
                border: 1px solid var(--border-color);
                box-shadow: 0 4px 10px rgba(255, 123, 0, 0.15);
                width: 450px;
                text-align: center;
                transition: 0.3s;
            }
            .payment-box:hover {
                box-shadow: 0 6px 16px rgba(255, 123, 0, 0.25);
            }
            .payment-box h2 {
                color: var(--brand-color);
                margin-bottom: 10px;
            }
            .order-info {
                font-size: 15px;
                color: #444;
                margin-bottom: 20px;
                background: #fff;
                padding: 12px;
                border-radius: 8px;
                border: 1px dashed var(--border-color);
            }
            .payment-detail {
                margin-top: 15px;
                text-align: left;
            }
            .payment-detail label {
                font-weight: bold;
                display: block;
                margin: 10px 0 5px;
                color: var(--brand-color);
            }
            .payment-detail input {
                width: 100%;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid var(--border-color);
                font-size: 16px;
                outline: none;
                transition: 0.3s;
                background-color: #fff;
            }
            .payment-detail input:focus {
                border-color: var(--brand-color);
                box-shadow: 0 0 5px rgba(255, 123, 0, 0.4);
            }
            .result-box {
                margin-top: 20px;
                background-color: #fffaf3;
                border-radius: 8px;
                padding: 15px;
                font-size: 16px;
                font-weight: 500;
                border: 1px solid var(--border-color);
            }
            .checkout-btn {
                width: 100%;
                margin-top: 25px;
                background-color: var(--brand-color);
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px;
                font-size: 16px;
                cursor: pointer;
                transition: 0.3s;
                box-shadow: 0 3px 6px rgba(255, 123, 0, 0.3);
            }
            .checkout-btn:hover {
                background-color: var(--brand-hover);
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(229, 106, 0, 0.35);
            }
            button[onclick="goBack()"] {
                background-color: var(--brand-color) !important;
                border: none;
                box-shadow: 0 3px 6px rgba(255, 123, 0, 0.3);
                transition: 0.3s;
                color: #fff;
                padding: 8px 14px;
                border-radius: 5px;
                cursor: pointer;
                margin-right: 20px;
            }
            button[onclick="goBack()"]:hover {
                background-color: var(--brand-hover) !important;
                transform: translateY(-2px);
            }
            .payment-header {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 15px;
                margin-bottom: 15px;
                position: relative;
                color: var(--brand-color);
            }
        </style>
    </head>
    <body>
        <header>
            <div class="logo">
                <img src="images/z7061950791630_395c8424b197b70abd984287f01356b9.jpg"
                     onclick="window.location.href = 'HomePage'">
            </div>
            <div class="icons">
                <span>🔔</span>
                <%
                    Object token = session.getAttribute("userToken");
                    if (token != null) {
                %>
                <span title="Tài khoản của tôi">👤</span>
                <% } else { %>
                <button style="background:#ff6600;color:#fff;border:none;padding:6px 12px;border-radius:4px;cursor:pointer;"
                        onclick="window.location.href = 'login.jsp'">Login</button>
                <button style="background:#666;color:#fff;border:none;padding:6px 12px;border-radius:4px;cursor:pointer;"
                        onclick="window.location.href = 'register.jsp'">Register</button>
                <% } %>
            </div>
        </header>
        <main>
            <button onclick="goBack()">← Quay lại trang chủ</button>
            <div class="payment-box">
                <h2>Thanh Toán Tiền Mặt</h2>
                <div class="order-info">
                    <p><b>Mã đơn hàng:</b>
                        <span style="color: var(--brand-color);">
                            <%= session.getAttribute("orderCode") != null
                                    ? session.getAttribute("orderCode")
                                    : "Chưa có mã" %>
                        </span>
                    </p>
                    <p><b>Tổng tiền cần thanh toán:</b>
                        <span id="totalAmount" style="color: var(--brand-color); font-weight:600;">
                            <%
                                Object totalObj = session.getAttribute("totalAmount");
                                if (totalObj != null) {
                                    double total = Double.parseDouble(totalObj.toString());
                                    out.print(String.format("%,.0f VNĐ", total));
                                } else {
                                    out.print("0 VNĐ");
                                }
                            %>
                        </span>
                    </p>
                    <p><b>Mã giảm giá đã dùng:</b>
                        <span style="color: var(--brand-color); font-weight:600;">
                            <%
                                String usedCode = (String) session.getAttribute("appliedCode");
                                if (usedCode != null && !usedCode.trim().isEmpty()) {
                                    out.print(usedCode);
                                } else {
                                    out.print("Không dùng");
                                }
                            %>
                        </span>
                    </p>
                    <p><b>Tổng PPoint:</b>
                        <span id="totalPPoint" style="color: var(--brand-color); font-weight:600;">0 P</span>
                    </p>
                </div>
                <div class="payment-detail">
                    <label for="customerPhone">Số điện thoại khách hàng (tùy chọn):</label>
                    <input type="text" id="customerPhone" placeholder="Nhập số điện thoại...">
                    <label for="customerMoney">Số tiền khách đưa:</label>
                    <input type="number" id="customerMoney" placeholder="Nhập số tiền khách đưa..." oninput="calculateChange()">
                    <div class="result-box">
                        <p>Số tiền trả lại khách:
                            <span id="changeAmount" style="color:green;">0 VNĐ</span>
                        </p>
                    </div>
                </div>
                <button class="checkout-btn" onclick="confirmCashPayment()">Xác Nhận Thanh Toán</button>
            </div>
        </main>
        <!-- ✅ SCRIPT giữ nguyên logic gốc -->
        <script>
            const totalAmount = parseFloat("<%= session.getAttribute("totalAmount") != null
                                        ? session.getAttribute("totalAmount")
                                        : 0 %>");
            async function loadAndShowPPoint() {
                try {
                    const res = await fetch("Cart", {method: "GET", cache: "no-store"});
                    const text = await res.text();
                    if (text && text.startsWith("[")) {
                        const cart = JSON.parse(text);
                        let totalPPoint = 0;
                        cart.forEach(item => {
                            totalPPoint += item.price * item.quantity * 0.005;
                        });
                        document.getElementById("totalPPoint").innerText = totalPPoint.toFixed(2) + " P";
                    } else {
                        document.getElementById("totalPPoint").innerText = "0 P";
                    }
                } catch (e) {
                    console.error("Không thể tải giỏ hàng để tính PPoint:", e);
                    document.getElementById("totalPPoint").innerText = "0 P";
                }
            }
            document.addEventListener("DOMContentLoaded", loadAndShowPPoint);
            function calculateChange() {
                const input = document.getElementById("customerMoney").value;
                const changeBox = document.getElementById("changeAmount");
                const given = parseFloat(input) || 0;
                const change = given - totalAmount;
                if (change < 0) {
                    changeBox.style.color = "red";
                    changeBox.innerText = "Thiếu " + Math.abs(change).toLocaleString() + " VNĐ";
                } else {
                    changeBox.style.color = "green";
                    changeBox.innerText = change.toLocaleString() + " VNĐ";
                }
            }
            async function confirmCashPayment() {
                const input = document.getElementById("customerMoney").value;
                const given = parseFloat(input) || 0;
                const phone = document.getElementById("customerPhone").value.trim();
                if (given < totalAmount) {
                    alert("Số tiền khách đưa chưa đủ!");
                    return;
                }
                alert("Thanh toán tiền mặt thành công!\\nĐơn hàng: <%= session.getAttribute("orderCode") %>");
                try {
                    await fetch("CashPayment", {
                        method: "POST",
                        headers: {"Content-Type": "application/x-www-form-urlencoded", "X-Requested-With": "XMLHttpRequest"},
                        body: new URLSearchParams({action: "confirm", total: totalAmount, given, phone})
                    });
                    await fetch("Cart", {
                        method: "POST",
                        headers: {"Content-Type": "application/x-www-form-urlencoded"},
                        body: "cartJson=" + encodeURIComponent("[]")
                    });
                } catch (err) {
                    console.error("Lỗi khi xác nhận thanh toán/ghi nhận voucher:", err);
                }
                window.location.href = "HomePage?resetSession=true";
            }
            function goBack() {
                fetch("Cart", {method: "GET", credentials: "include", cache: "no-store"})
                        .finally(() => {
                            const encodedUrl = "<%= response.encodeURL("HomePage?fromPayment=true") %>" + "&ts=" + new Date().getTime();
                            window.location.href = encodedUrl;
                        });
            }
        </script>
    </body>
</html>