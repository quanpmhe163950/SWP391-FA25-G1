<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
    String orderCode = (String) request.getAttribute("orderCode");
    Double totalAmount = (Double) request.getAttribute("totalAmount");
    if (totalAmount == null) totalAmount = 0.0;
    String appliedCode = (String) session.getAttribute("appliedCode");
    Object ppointObj = session.getAttribute("totalPPoint");
    String totalPPoint = ppointObj != null ? ppointObj.toString() : "0";
    String qrUrl = (String) request.getAttribute("qrUrl");
    // Thêm check null cho cartData để tránh lỗi
    String cartDataJson = (String) request.getAttribute("cartData");
    if (cartDataJson == null) cartDataJson = "[]"; // Mặc định là mảng rỗng nếu null
%>
<html>
    <head>
        <title>Thanh toán VNPay</title>
        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background: #f4f6f8;
            }
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
            .container {
                width: 900px;
                margin: 40px auto;
                background: white;
                padding: 30px;
                border-radius: 16px;
                box-shadow: 0 3px 12px rgba(0,0,0,0.15);
            }
            h2 {
                color: #0066ff;
                text-align: center;
                margin-bottom: 20px;
            }
            .section-title {
                font-size: 20px;
                font-weight: bold;
                margin-top: 25px;
                color: #0066ff;
            }
            .order-info p {
                margin: 6px 0;
                font-size: 16px;
            }
            .cart-box {
                margin-top: 20px;
                padding: 15px;
                border-radius: 12px;
                background: #fafafa;
                border: 1px solid #ddd;
            }
            .qr-box {
                text-align: center;
                margin-top: 20px;
                padding: 20px;
                background: #fafcff;
                border-radius: 12px;
                border: 1px solid #dce6ff;
            }
            .qr-box img {
                width: 240px;
                height: 240px;
                border-radius: 10px;
                border: 1px solid #ccc;
            }
            .confirm-btn {
                display: block;
                margin: 30px auto 0;
                background: #0066ff;
                color: white;
                padding: 12px 26px;
                border-radius: 10px;
                font-size: 17px;
                border: none;
                cursor: pointer;
            }
            .confirm-btn:hover {
                background: #0050d6;
            }
            /* Style cho bảng chi tiết đơn hàng */
            #cartReviewTable {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            #cartReviewTable th, #cartReviewTable td {
                padding: 8px;
                border-bottom: 1px solid #ddd;
                text-align: left;
            }
            #cartReviewTable th {
                background-color: #f0f0f0;
                font-weight: bold;
            }
            #cartReviewTable td:last-child, #cartReviewTable th:last-child {
                text-align: right;
            }
            #cartReviewTable tfoot td {
                font-weight: bold;
                background-color: #f0f0f0;
            }
            button[onclick="goBack()"] {
                background-color: var(--brand-color) !important;
                border: none;
                box-shadow: 0 3px 6px rgba(255, 123, 0, 0.3);
                transition: 0.3s;
                color: #000;
                padding: 8px 14px;
                border-radius: 5px;
                cursor: pointer;
                margin-right: 20px;
            }
            button[onclick="goBack()"]:hover {
                background-color: var(--brand-hover) !important;
                transform: translateY(-2px);
            }
            /* Style cho input số điện thoại */
            .phone-input {
                margin: 10px 0;
                padding: 10px;
                width: 100%;
                box-sizing: border-box;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 16px;
            }
            .phone-input:focus {
                border-color: #0066ff;
                outline: none;
            }
        </style>
    </head>
    <body>
        <header>
            <div class="logo">
                <img src="images/z7061950791630_395c8424b197b70abd984287f01356b9.jpg"
                     onclick="window.location.href = 'HomePage'">
            </div>
        </header>
        <div class="container">
            <button onclick="goBack()">← Quay lại trang chủ</button>
            <h2>Thanh toán qua VNPay (VietQR)</h2>
            <!-- === Order info === -->
            <div class="order-info">
                <p><b>Mã đơn hàng:</b>
                    <span style="color:#0066ff;"><%= orderCode %></span>
                </p>
                <p><b>Tổng tiền thanh toán:</b>
                    <span style="color:#0066ff;">
                        <%= new DecimalFormat("#,###").format(totalAmount) %> VNĐ
                    </span>
                </p>
                <p><b>Mã giảm giá:</b>
                    <span style="color:#0066ff;">
                        <%= appliedCode != null ? appliedCode : "Không dùng" %>
                    </span>
                </p>
                <p><b>Tổng PPoint:</b>
                    <span style="color:#0066ff;"><%= totalPPoint %> P</span>
                </p>
            </div>
            <!-- === Cart Review === -->
            <div class="section-title">Chi tiết đơn hàng</div>
            <div class="cart-box">
                <div id="cartReviewBox" style="display: none;">
                    <%= cartDataJson %>
                </div>
                <table id="cartReviewTable">
                    <thead>
                        <tr>
                            <th>Tên món</th>
                            <th>Kích cỡ</th>
                            <th>Số lượng</th>
                            <th>Giá (VNĐ)</th>
                            <th>Thành tiền (VNĐ)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Bảng sẽ được populate bởi JS -->
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="4">Tổng cộng:</td>
                            <td id="grandTotal">0 VNĐ</td>
                        </tr>
                    </tfoot>
                </table>
            </div>
            <!-- === QR VietQR Section === -->
            <div class="section-title">Quét mã QR để thanh toán</div>
            <div class="qr-box">
                <img src="<%= qrUrl %>" alt="Mã QR VietQR">
                <p>Vui lòng dùng ứng dụng ngân hàng để quét mã.</p>
            </div>
            <!-- === Confirm Payment Button === -->
            <div class="section-title">Thông tin khách hàng</div>
            <input type="text" id="customerPhone" class="phone-input" placeholder="Nhập số điện thoại (ví dụ: 0123456789)" pattern="[0-9]{10}" title="Số điện thoại phải là 10 chữ số">
            <button onclick="confirmVNPayPayment()" class="confirm-btn">Tôi đã thanh toán</button>
        </div>
        <script>
            // Parse JSON và render bảng chi tiết đơn hàng
            document.addEventListener("DOMContentLoaded", function () {
                const cartJson = document.getElementById("cartReviewBox").innerText.trim();
                console.log("Raw cartJson:", cartJson); // Debug: Kiểm tra JSON trong console browser (F12)
                let cartData = [];
                try {
                    if (cartJson && cartJson !== "[]") {
                        cartData = JSON.parse(cartJson);
                    }
                } catch (e) {
                    console.error("Lỗi parse JSON cartData:", e);
                    // Nếu lỗi, hiển thị thông báo
                    const tbody = document.querySelector("#cartReviewTable tbody");
                    const tr = document.createElement("tr");
                    tr.innerHTML = '<td colspan="5" style="text-align:center; color:red;">Lỗi hiển thị chi tiết đơn hàng: ' + e.message + '</td>';
                    tbody.appendChild(tr);
                    return;
                }
                const tbody = document.querySelector("#cartReviewTable tbody");
                if (cartData.length === 0) {
                    const tr = document.createElement("tr");
                    tr.innerHTML = '<td colspan="5" style="text-align:center;">Không có dữ liệu giỏ hàng</td>';
                    tbody.appendChild(tr);
                } else {
                    let grandTotal = 0;
                    cartData.forEach(item => {
                        const itemTotal = item.price * item.quantity;
                        grandTotal += itemTotal;
                        const tr = document.createElement("tr");
                        tr.innerHTML =
                                '<td>' + (item.name || 'N/A') + '</td>' +
                                '<td>' + (item.size || 'N/A') + '</td>' +
                                '<td>' + (item.quantity || 0) + '</td>' +
                                '<td>' + (item.price || 0).toLocaleString('vi-VN') + '</td>' +
                                '<td>' + itemTotal.toLocaleString('vi-VN') + '</td>';
                        tbody.appendChild(tr);
                    });
                    // Cập nhật tổng cộng ở footer
                    document.getElementById("grandTotal").innerText = grandTotal.toLocaleString('vi-VN') + ' VNĐ';
                }
            });
            function goBack() {
                fetch("Cart", {method: "GET", credentials: "include", cache: "no-store"})
                        .finally(() => {
                            const encodedUrl = "<%= response.encodeURL("MenuPage?fromPayment=true") %>" + "&ts=" + new Date().getTime();
                            window.location.href = encodedUrl;
                        });
            }
            async function confirmVNPayPayment() {
                const phone = document.getElementById("customerPhone").value.trim();
                const phonePattern = /^[0-9]{10}$/;
                if (phone && !phonePattern.test(phone)) {
                    alert("Số điện thoại phải là 10 chữ số!");
                    return;
                }
                alert("Thanh toán VNPay thành công!\\nĐơn hàng: <%= orderCode %>");
                try {
                    await fetch("VNPayPayment", {
                        method: "POST",
                        headers: {"Content-Type": "application/x-www-form-urlencoded", "X-Requested-With": "XMLHttpRequest"},
                        body: new URLSearchParams({action: "confirm", phone})
                    });
                    await fetch("Cart", {
                        method: "POST",
                        headers: {"Content-Type": "application/x-www-form-urlencoded"},
                        body: "cartJson=" + encodeURIComponent("[]")
                    });
                } catch (err) {
                    console.error("Lỗi khi xác nhận thanh toán/ghi nhận voucher:", err);
                }
                window.location.href = "MenuPage?resetSession=true";
            }
        </script>
    </body>
</html>