<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.MenuItem, model.Promotion" %>
<%@ page import="java.util.*, model.MenuItem, model.ItemSizePrice" %>
<%@ page import="java.util.*, model.Category" %>


<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <style>
            :root {
                --brand-color: #ff6600;
                --brand-hover: #e65c00;
                --brand-light: #fff3e6;
                --bg-light: #f9f9f9;
                --text-dark: #333;
                --text-light: #666;
                --border-color: #e0e0e0;
                --shadow-soft: 0 4px 20px rgba(0, 0, 0, 0.05);
                --shadow-hover: 0 8px 30px rgba(0, 0, 0, 0.1);
                --transition: all 0.3s ease;
            }
            body {
                font-family: "Segoe UI", Arial, sans-serif;
                background-color: var(--bg-light);
                margin: 0;
                padding: 0;
                color: var(--text-dark);
                line-height: 1.6;
            }
            /* HEADER */
            header {
                background-color: #fff;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 50px;
                box-shadow: var(--shadow-soft);
                position: sticky;
                top: 0;
                z-index: 1000;
            }
            .logo img {
                height: 50px;
                width: auto;
                cursor: pointer;
                transition: var(--transition);
            }
            .logo img:hover {
                transform: scale(1.1);
            }
            .search-bar input {
                width: 400px;
                padding: 12px 20px;
                border: 1px solid var(--border-color);
                border-radius: 30px;
                outline: none;
                transition: var(--transition);
                background-color: #fff;
                font-size: 16px;
            }
            .search-bar input:focus {
                border-color: var(--brand-color);
                box-shadow: 0 0 8px rgba(255, 102, 0, 0.2);
            }
            .icons {
                display: flex;
                align-items: center;
                gap: 20px;
            }
            .icons span {
                font-size: 24px;
                cursor: pointer;
                transition: var(--transition);
            }
            .icons span:hover {
                color: var(--brand-color);
                transform: scale(1.1);
            }
            /* MAIN LAYOUT */
            main {
                display: flex;
                justify-content: space-between;
                gap: 40px;
                padding: 30px 50px;
                max-width: 1400px;
                margin: 0 auto;
                height: calc(100vh - 80px);
                overflow: hidden;
            }
            /* MENU CONTAINER */
            .menu-container {
                flex: 3;
                background-color: #fff;
                padding: 30px;
                border-radius: 20px;
                box-shadow: var(--shadow-soft);
                overflow-y: auto;
                height: 100%;
                scrollbar-width: thin;
                scrollbar-color: var(--brand-color) var(--bg-light);
            }
            .menu-container::-webkit-scrollbar {
                width: 8px;
            }
            .menu-container::-webkit-scrollbar-thumb {
                background-color: var(--brand-color);
                border-radius: 10px;
            }
            .menu-header {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 15px;
                margin-bottom: 25px;
            }
            .menu-header h2 {
                font-size: 28px;
                color: var(--brand-color);
                margin: 0;
                font-weight: 700;
            }
            #categoryFilter {
                padding: 10px 15px;
                border: 1px solid var(--border-color);
                border-radius: 10px;
                font-size: 16px;
                cursor: pointer;
                transition: var(--transition);
                background-color: #fff;
            }
            #categoryFilter:hover {
                border-color: var(--brand-color);
                box-shadow: 0 0 5px rgba(255, 102, 0, 0.1);
            }
            #appliedCode {
                color: var(--brand-color);
                font-weight: 600;
            }
            .menu-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
                gap: 25px;
            }
            .menu-item {
                border: 1px solid var(--border-color);
                border-radius: 15px;
                text-align: center;
                padding: 20px;
                background-color: #fff;
                transition: var(--transition);
                cursor: pointer;
            }
            .menu-item:hover {
                transform: translateY(-8px);
                box-shadow: var(--shadow-hover);
                border-color: var(--brand-light);
            }
            .menu-item img {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 50%;
                margin-bottom: 15px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }
            .menu-item p {
                margin: 8px 0;
                font-size: 16px;
            }
            .menu-item p b {
                font-size: 18px;
                color: var(--text-dark);
            }
            /* QUANTITY BUTTONS */
            .quantity-control {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                margin-top: 12px;
            }
            .quantity-control button {
                background-color: var(--brand-color);
                color: white;
                border: none;
                border-radius: 50%;
                width: 35px;
                height: 35px;
                font-size: 20px;
                cursor: pointer;
                transition: var(--transition);
            }
            .quantity-control button:hover {
                background-color: var(--brand-hover);
                transform: scale(1.1);
            }
            .quantity-control input {
                width: 50px;
                text-align: center;
                border: 1px solid var(--border-color);
                border-radius: 10px;
                height: 35px;
                font-size: 16px;
                background-color: var(--bg-light);
            }
            /* SIDEBAR */
            .sidebar {
                flex: 1.2;
                display: flex;
                flex-direction: column;
                gap: 30px;
                overflow-y: auto;
                height: 100%;
                scrollbar-width: thin;
                scrollbar-color: var(--brand-color) var(--bg-light);
            }
            .sidebar::-webkit-scrollbar {
                width: 8px;
            }
            .sidebar::-webkit-scrollbar-thumb {
                background-color: var(--brand-color);
                border-radius: 10px;
            }
            .cart, .payment {
                background-color: #fff;
                border-radius: 20px;
                padding: 25px;
                box-shadow: var(--shadow-soft);
            }
            .cart h3, .payment h3 {
                margin-top: 0;
                color: var(--brand-color);
                font-size: 22px;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .cart table {
                width: 100%;
                border-collapse: collapse;
                font-size: 15px;
                margin-bottom: 20px;
            }
            .cart th, .cart td {
                padding: 12px 8px;
                border-bottom: 1px solid var(--border-color);
                text-align: left;
            }
            .cart th {
                color: var(--text-light);
                font-weight: 600;
            }
            .summary p {
                display: flex;
                justify-content: space-between;
                margin: 8px 0;
                font-size: 16px;
            }
            .summary p b {
                font-weight: 700;
            }
            /* PAYMENT ICONS */
            .payment-icons {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 25px;
                justify-items: center;
                align-items: center;
                margin: 25px 0;
            }
            .payment-icons img {
                width: 110px;
                height: 75px;
                object-fit: contain;
                background-color: var(--bg-light);
                border: 2px solid transparent;
                border-radius: 15px;
                padding: 10px;
                box-shadow: var(--shadow-soft);
                transition: var(--transition);
                cursor: pointer;
            }
            .payment-icons img:hover {
                transform: scale(1.08);
                box-shadow: var(--shadow-hover);
            }
            .payment-icons img.selected {
                border-color: var(--brand-color);
                background-color: var(--brand-light);
                box-shadow: 0 0 12px rgba(255, 102, 0, 0.3);
            }
            .voucher-section {
                text-align: left;
                margin-bottom: 20px;
            }
            .voucher-input {
                display: flex;
                gap: 10px;
                margin-top: 8px;
            }
            .voucher-input input {
                flex: 1;
                padding: 10px 15px;
                border: 1px solid var(--border-color);
                border-radius: 10px;
                font-size: 15px;
                outline: none;
                transition: var(--transition);
                background-color: #fff;
            }
            .voucher-input input:focus {
                border-color: var(--brand-color);
                box-shadow: 0 0 6px rgba(255, 102, 0, 0.2);
            }
            .voucher-input button {
                background-color: var(--brand-color);
                color: white;
                border: none;
                border-radius: 10px;
                padding: 10px 18px;
                cursor: pointer;
                font-size: 15px;
                transition: var(--transition);
            }
            .voucher-input button:hover {
                background-color: var(--brand-hover);
                transform: scale(1.05);
            }
            .voucher-section a.selected {
                background-color: var(--brand-light);
                border-radius: 8px;
                padding: 4px 8px;
            }
            /* CHECKOUT BUTTON */
            .checkout-btn {
                display: block;
                width: 100%;
                background-color: var(--brand-color);
                color: white;
                border: none;
                border-radius: 12px;
                padding: 15px;
                font-size: 18px;
                cursor: pointer;
                transition: var(--transition);
                font-weight: 600;
            }
            .checkout-btn:hover {
                background-color: var(--brand-hover);
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(255, 102, 0, 0.3);
            }
        </style>
    </head>
    <body>
        <header>
            <div class="logo">
                <img src="images/z7061950791630_395c8424b197b70abd984287f01356b9.jpg" onclick="window.location.href = 'HomePage'">
            </div>
            <div class="search-bar">
                <input type="text" placeholder="Tìm kiếm món ăn...">
            </div>
            <div class="icons">
                <span>🔔</span>
                <%
                    Object token = session.getAttribute("authToken");
                    if (token != null) {
                %>
                <!-- Nếu đã đăng nhập -->
                <span title="Tài khoản của tôi">👤</span>
                <a href="logout" class="dropdown-item logout">Đăng xuất</a>
                <%
                    } else {
                %>
                <!-- Nếu chưa đăng nhập -->
                <button style="background:#ff6600;color:#fff;border:none;padding:6px 12px;border-radius:4px;cursor:pointer;"
                        onclick="window.location.href = 'login.jsp'">Login</button>
                <button style="background:#666;color:#fff;border:none;padding:6px 12px;border-radius:4px;cursor:pointer;"
                        onclick="window.location.href = 'register.jsp'">Register</button>
                <%
                    }
                %>
                
            </div>
        </header>
        <main style="display: flex; gap: 30px;">
            <!-- 🔹 Cột trái: danh sách đơn --><div>
                 <h4>Danh sách đơn hàng cần phục vụ </h4>
    <div id="completed-orders" class="orders-container" 
         style="flex: 1; background: #fff; padding: 20px; border-radius: 15px; 
                box-shadow: 0 2px 10px rgba(0,0,0,0.05); 
                max-height: 400px;   /* chiều cao cố định */
                overflow-y: auto;">
        <%-- Bảng completedOrders sẽ được nhúng ở đây --%>
    </div>
</div>

           

            <!-- 🔹 Cột phải: menu -->
            <div class="menu-container" style="flex: 2;">
                <div class="menu-header">
                    <select id="categoryFilter" onchange="filterMenuByCategory()">
                        <option value="All">Tất cả</option>
                        <%
                            List<Category> categoryList = (List<Category>) request.getAttribute("categoryList");
                            if (categoryList != null) {
                                for (Category c : categoryList) {
                        %>
                        <option value="<%= c.getCategoryID() %>"><%= c.getCategoryName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <h2>Menu</h2>
                </div>
                <hr>
                <%
Map<MenuItem, List<ItemSizePrice>> menuWithSizes = 
    (Map<MenuItem, List<ItemSizePrice>>) request.getAttribute("menuWithSizes");
                %>

                <div class="menu-grid">
                    <% if (menuWithSizes != null && !menuWithSizes.isEmpty()) {
                           for (MenuItem item : menuWithSizes.keySet()) {
                               List<ItemSizePrice> sizes = menuWithSizes.get(item);
                               for (ItemSizePrice isp : sizes) {
                    %>
                    <div class="menu-item" data-category="<%= item.getCategoryId() %>">
                        <img src="<%= item.getImagePath() != null && !item.getImagePath().isEmpty() 
                                    ? item.getImagePath() 
                                    : "https://cdn-icons-png.flaticon.com/512/3132/3132693.png" %>" 
                             alt="<%= item.getName() %>">
                        <p><b><%= item.getName() %></b> - <%= isp.getSize() %></p>
                        <p><%= String.format("%.0f", isp.getPrice()) %> VNĐ</p>
                        <div class="quantity-control" data-name="<%= item.getName() %>" data-size="<%= isp.getSize() %>" data-price="<%= isp.getPrice() %>">
                            <button class="minus-btn">−</button>
                            <input type="number" min="0" value="0" class="qty-input">
                            <button class="plus-btn">+</button>
                        </div>
                    </div>
                    <%     }
                           }
                       } %>
                </div>

            </div>
            <div class="sidebar">
                <div class="cart">
                    <h3 style="display: flex; align-items: center; gap: 6px;">
                        <span>Đơn hàng - </span>
                        <span style="font-size: 13px; color: #ff6600;">
                            <%= session.getAttribute("orderCode") != null
                                    ? session.getAttribute("orderCode")
                                    : "Chưa có mã" %>
                        </span>
                    </h3>
                    <table id="cartTable">
                        <thead>
                            <tr><th>Món</th><th>SL</th><th>Thành tiền</th></tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <div class="summary">
                        <p><span>Tổng:</span><span id="subtotal">0 VNĐ</span></p>
                        <p><span>VAT (10%):</span><span id="vat">0 VNĐ</span></p>
                        <p>
                            <span>Giảm giá:</span>
                            <span id="discount">
                                <%
                                    Object discountType = request.getAttribute("discountType");
                                    Object discountValue = request.getAttribute("discountValue");
                                    if (discountType != null && discountValue != null) {
                                        if ("PERCENT".equalsIgnoreCase(discountType.toString())) {
                                            out.print(discountValue + "%");
                                        } else {
                                            out.print(String.format("%.0f VNĐ", Double.parseDouble(discountValue.toString())));
                                        }
                                    } else {
                                        out.print("0 VNĐ");
                                    }
                                %>
                            </span>
                        </p>
                        <p>
                            <span>Mã giảm giá:</span>
                            <span id="appliedCode" style="font-weight: 600; color: #ff6600;">
                                <%
                                    String appliedCode = (String) session.getAttribute("appliedCode");
                                    if (appliedCode != null && !appliedCode.trim().isEmpty()) {
                                        out.print(appliedCode);
                                    } else {
                                        out.print("Chưa áp dụng");
                                    }
                                %>
                            </span>
                            <%-- ✅ Nếu đã có mã áp dụng thì hiển thị nút Hủy mã kèm confirm() --%>
                            <% if (session.getAttribute("appliedCode") != null && !((String) session.getAttribute("appliedCode")).trim().isEmpty()) { %>
                            <button type="button"
                                    onclick="if (confirm('Bạn có chắc muốn hủy mã giảm giá hiện tại?')) {
                                                window.location.href = 'MenuPage?resetVoucher=true';
                                            }"
                                    style="margin-left:10px; border:none; background:#ff6666; color:#fff; padding:4px 8px; border-radius:5px; cursor:pointer; font-size:13px;">
                                Hủy mã
                            </button>
                            <% } %>
                        </p>
                        <hr>
                        <p><b>Thành tiền:</b><b id="total">0 VNĐ</b></p>
                        <p><b>Tổng PPoint:</b><b id="totalPPoint">0 P</b></p>
                    </div>
                </div>
                <div class="payment">
                    <h3>Phương Thức Thanh Toán</h3>
                    <!-- 🔹 Nhập mã Voucher -->
                    <div class="voucher-section">
                        <label for="voucherCode"><b>Mã Voucher:</b></label>
                        <div class="voucher-input">
                            <input type="text" id="voucherCode" name="voucherCode" placeholder="Nhập mã giảm giá..." required>
                            <button type="button" onclick="applyVoucher()">Áp dụng</button>
                        </div>
                        <!-- Hiển thị thông báo từ servlet (nếu có) -->
                        <p id="voucherMessage"
                           style="font-size:13px; color:<%= request.getAttribute("voucherColor") != null ? request.getAttribute("voucherColor") : "#555" %>;">
                            <%= request.getAttribute("voucherMessage") != null ? request.getAttribute("voucherMessage") : "" %>
                        </p>
                    </div>
                    <%
                        List<Promotion> promotions = (List<Promotion>) request.getAttribute("activePromotions");
                        Integer currentPage = (Integer) request.getAttribute("currentPage");
                        Integer totalPages = (Integer) request.getAttribute("totalPages");
                        if (promotions != null && !promotions.isEmpty()) {
                    %>
                    <div style="margin-top:20px; font-size:13px; color:#333; background:#fffaf2; padding:10px; border-radius:8px;">
                        <b>Các mã giảm giá đang hoạt động:</b>
                        <ul style="padding-left:18px;">
                            <% for (Promotion p : promotions) { %>
                            <li>
                                <!-- 🔹 Voucher có thể click -->
                                <a href="#" onclick="applyPromotion('<%= p.getCode() %>')" style="text-decoration:none; color:#ff6600; font-weight:bold;">
                                    <%= p.getCode() %>
                                </a>
                                —
                                <%= p.getDiscountType().equalsIgnoreCase("PERCENT")
                                    ? p.getValue() + "%"
                                    : p.getValue() + " VNĐ" %>
                                <% if (p.getDescription() != null) { %>
                                <br><i><%= p.getDescription() %></i>
                                <% } %>
                            </li>
                            <% } %>
                        </ul>
                        <!-- 🔹 Nút phân trang -->
                        <div style="text-align:center; margin-top:10px;">
                            <% if (currentPage > 1) { %>
                            <a href="MenuPage?page=<%= currentPage - 1 %>" style="margin-right:10px; text-decoration:none; color:#ff6600;">« Trang trước</a>
                            <% } %>
                            <span> Trang <%= currentPage %> / <%= totalPages %></span>
                            <% if (currentPage < totalPages) { %>
                            <a href="MenuPage?page=<%= currentPage + 1 %>" style="margin-left:10px; text-decoration:none; color:#ff6600;">Trang sau »</a>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                    <!-- 🔹 Các hình thức thanh toán -->
                    <div class="payment-icons">
                        <img src="images/QRCodeimg.png" onclick="selectPayment(this, 'QR Code')">
                        <img src="images/VNPay QR là gì_ Những tiện ích khi thanh toán qua VNPay QR.jpg" onclick="selectPayment(this, 'VNPay')">
                        <img src="images/creditcardimg.png" onclick="selectPayment(this, 'Visa/MasterCard')">
                        <img src="images/cashimg.png" onclick="selectPayment(this, 'Tiền mặt')">
                    </div>
                    <button class="checkout-btn" onclick="checkout()">Thanh Toán</button>
                </div>
            </div>
        </main>
        <script>
            fetch('<%=request.getContextPath()%>/orders/update-status')
                    .then(res => res.text())
                    .then(html => {
                        document.getElementById('completed-orders').innerHTML = html;
                    });
        </script>

        <script>
            let cart = [];
            let selectedMethod = null;
            let discountValue = <%= request.getAttribute("discountValue") != null ? request.getAttribute("discountValue") : 0 %>;
            let discountType = "<%= request.getAttribute("discountType") != null ? request.getAttribute("discountType") : "" %>";

// 🟩 SỬA: Map theo name + size
            function syncInputsWithCart() {
                const qMap = new Map(cart.map(i => [`${i.name}_${i.size}`, i.quantity]));
                        document.querySelectorAll(".quantity-control").forEach(ctrl => {
                            const input = ctrl.querySelector(".qty-input");
                            const name = ctrl.dataset.name;
                            const size = ctrl.dataset.size;
                            const key = `${name}_${size}`;
                                        const qty = qMap.get(key) || 0;
                                        input.value = qty;
                                    });
                                }

                                document.addEventListener("DOMContentLoaded", async () => {
                                    try {
                                        const res = await fetch("Cart");
                                        const text = await res.text();
                                        if (text && text.startsWith("[")) {
                                            cart = JSON.parse(text);
                                            renderCart();
                                            syncInputsWithCart();
                                        }
                                    } catch (e) {
                                        console.error("Không thể tải giỏ hàng:", e);
                                    }

                                    document.querySelectorAll(".quantity-control").forEach(ctrl => {
                                        const name = ctrl.dataset.name;
                                        const size = ctrl.dataset.size;
                                        const price = parseFloat(ctrl.dataset.price);
                                        const minusBtn = ctrl.querySelector(".minus-btn");
                                        const plusBtn = ctrl.querySelector(".plus-btn");
                                        const input = ctrl.querySelector(".qty-input");

                                        plusBtn.addEventListener("click", () => {
                                            let currentVal = parseInt(input.value);
                                            if (currentVal >= 100) {
                                                alert("Số lượng món ăn không được vượt quá 100 món!");
                                                input.value = 100;
                                                return;
                                            }
                                            input.value = currentVal + 1;
                                            updateCartQuantity(name, size, price, parseInt(input.value));
                                        });

                                        minusBtn.addEventListener("click", () => {
                                            let val = parseInt(input.value);
                                            if (val > 0) {
                                                val -= 1;
                                                input.value = val;
                                                updateCartQuantity(name, size, price, val);
                                            }
                                        });

                                        input.addEventListener("input", () => {
                                            let val = parseInt(input.value);
                                            if (isNaN(val) || val < 0)
                                                val = 0;
                                            if (val > 100) {
                                                alert("Số lượng món ăn không được vượt quá 100 món!");
                                                val = 100;
                                            }
                                            input.value = val;
                                            updateCartQuantity(name, size, price, val);
                                        });
                                    });
                                });

                                async function saveCartToServer() {
                                    try {
                                        await fetch("Cart", {
                                            method: "POST",
                                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                                            body: "cartJson=" + encodeURIComponent(JSON.stringify(cart))
                                        });
                                    } catch (e) {
                                        console.error("Lỗi lưu giỏ hàng:", e);
                                    }
                                }

// 🟩 SỬA: phân biệt name + size
                                function addToCart(name, size, price) {
                                    let existing = cart.find(item => item.name === name && item.size === size);
                                    if (existing)
                                        existing.quantity++;
                                    else
                                        cart.push({name, size, price, quantity: 1});
                                    renderCart();
                                    saveCartToServer();
                                }

                                function renderCart() {
                                    const tbody = document.querySelector("#cartTable tbody");
                                    tbody.innerHTML = "";
                                    let subtotal = 0;
                                    cart.forEach(item => {
                                        subtotal += item.price * item.quantity;
                                        const tr = document.createElement("tr");
                                        tr.innerHTML =
                                                `<td>\${item.name} (\${item.size})</td>
             <td>\${item.quantity}</td>
             <td>\${(item.price * item.quantity).toLocaleString()} VNĐ</td>`;
                                        tbody.appendChild(tr);
                                    });

                                    let vat = subtotal * 0.1;
                                    let discount = 0;
                                    if (discountType === "PERCENT") {
                                        discount = subtotal * (discountValue / 100);
                                    } else if (discountType === "FIXED") {
                                        discount = discountValue;
                                    }
                                    let total = subtotal + vat - discount;
                                    document.getElementById("subtotal").innerText = subtotal.toLocaleString() + " VNĐ";
                                    document.getElementById("vat").innerText = vat.toLocaleString() + " VNĐ";
                                    document.getElementById("discount").innerText = discount.toLocaleString() + " VNĐ";
                                    document.getElementById("total").innerText = total.toLocaleString() + " VNĐ";

                                    let totalPPoint = 0;
                                    cart.forEach(item => {
                                        totalPPoint += item.price * item.quantity * 0.005;
                                    });
                                    document.getElementById("totalPPoint").innerText = totalPPoint.toFixed(2) + " P";

                                    const checkoutBtn = document.querySelector(".checkout-btn");
                                    if (total <= 0 || isNaN(total)) {
                                        checkoutBtn.disabled = true;
                                        checkoutBtn.style.opacity = "0.6";
                                        checkoutBtn.style.cursor = "not-allowed";
                                    } else {
                                        checkoutBtn.disabled = false;
                                        checkoutBtn.style.opacity = "1";
                                        checkoutBtn.style.cursor = "pointer";
                                    }
                                }

// 🟩 SỬA: kiểm tra theo name + size
                                function updateCartQuantity(name, size, price, quantity) {
                                    let item = cart.find(i => i.name === name && i.size === size);
                                    if (quantity === 0) {
                                        cart = cart.filter(i => !(i.name === name && i.size === size));
                                    } else if (item) {
                                        item.quantity = quantity;
                                    } else {
                                        cart.push({name, size, price, quantity});
                                    }
                                    renderCart();
                                    saveCartToServer();
                                }
                                function selectPayment(el, method) {
                                    document.querySelectorAll('.payment-icons img').forEach(img => img.classList.remove('selected'));
                                    el.classList.add('selected');
                                    selectedMethod = method;
                                }
                                function checkout() {
                                    if (cart.length === 0) {
                                        alert("Giỏ hàng trống!");
                                        return;
                                    }
                                    if (!selectedMethod) {
                                        alert("Vui lòng chọn phương thức thanh toán!");
                                        return;
                                    }
                                    const totalText = document.getElementById("total").innerText.replace(/[^\d]/g, "");
                                    const total = parseFloat(totalText) || 0;
                                    switch (selectedMethod) {
                                        case "Tiền mặt":
                                            const form = document.createElement("form");
                                            form.method = "POST";
                                            form.action = "CashPayment";
                                            const totalInput = document.createElement("input");
                                            totalInput.type = "hidden";
                                            totalInput.name = "total";
                                            totalInput.value = total;
                                            const actionInput = document.createElement("input");
                                            actionInput.type = "hidden";
                                            actionInput.name = "action";
                                            actionInput.value = "review";
                                            form.appendChild(totalInput);
                                            form.appendChild(actionInput);
                                            document.body.appendChild(form);
                                            form.submit();
                                            break;
                                        case "VNPay":
                                            const vnpayForm = document.createElement("form");
                                            vnpayForm.method = "POST";
                                            vnpayForm.action = "VNPayPayment"; // ✅ gửi tới servlet, không phải JSP
                                            const vnpayTotalInput = document.createElement("input");
                                            vnpayTotalInput.type = "hidden";
                                            vnpayTotalInput.name = "total";
                                            vnpayTotalInput.value = total;
                                            // ✅ Thêm input action="review" để tránh error invalidAction
                                            const vnpayActionInput = document.createElement("input");
                                            vnpayActionInput.type = "hidden";
                                            vnpayActionInput.name = "action";
                                            vnpayActionInput.value = "review";
                                            vnpayForm.appendChild(vnpayTotalInput);
                                            vnpayForm.appendChild(vnpayActionInput);
                                            document.body.appendChild(vnpayForm);
                                            vnpayForm.submit();
                                            break;
                                        case "QR Code":
                                            window.location.href = "QRCodePayment.jsp?total=" + total;
                                            break;
                                        case "Visa/MasterCard":
                                            window.location.href = "CardPayment.jsp?total=" + total;
                                            break;
                                        default:
                                            alert("Phương thức thanh toán không hợp lệ!");
                                            return;
                                    }
                                    // ❌ Xóa khối này hoàn toàn - không xóa cart ở đây nữa
                                    // cart = [];
                                    // renderCart();
                                    // saveCartToServer();
                                    // document.querySelectorAll('.payment-icons img').forEach(img => img.classList.remove('selected'));
                                }
                                function filterMenuByCategory() {
                                    const selected = document.getElementById("categoryFilter").value;
                                    const items = document.querySelectorAll(".menu-item");
                                    items.forEach(item => {
                                        const category = item.getAttribute("data-category");
                                        item.style.display = (selected === "All" || category === selected) ? "block" : "none";
                                    });
                                }
                                // === TÌM KIẾM MÓN ĂN THEO TÊN ===
                                document.querySelector(".search-bar input").addEventListener("input", function () {
                                    const keyword = this.value.trim().toLowerCase();
                                    const items = document.querySelectorAll(".menu-item");
                                    const categoryFilter = document.getElementById("categoryFilter") ? document.getElementById("categoryFilter").value : "All";
                                    items.forEach(item => {
                                        const name = item.querySelector("p b").innerText.toLowerCase();
                                        const category = item.getAttribute("data-category");
                                        const matchesSearch = name.includes(keyword);
                                        const matchesCategory = categoryFilter === "All" || category === categoryFilter;
                                        item.style.display = (matchesSearch && matchesCategory) ? "block" : "none";
                                    });
                                });
                                async function applyVoucher() {
                                    const code = document.getElementById("voucherCode").value.trim();
                                    if (code === "") {
                                        alert("Vui lòng nhập mã voucher!");
                                        return;
                                    }
                                    // ✅ Bước 1: Lưu giỏ hàng, CHỜ hoàn tất thật sự
                                    const response = await fetch("Cart", {
                                        method: "POST",
                                        headers: {"Content-Type": "application/x-www-form-urlencoded"},
                                        body: "cartJson=" + encodeURIComponent(JSON.stringify(cart))
                                    });
                                    if (!response.ok) {
                                        alert("Không thể lưu giỏ hàng. Thử lại!");
                                        return;
                                    }
                                    // ✅ Bước 2: Gửi form sau khi chắc chắn session đã cập nhật
                                    const form = document.createElement("form");
                                    form.method = "POST";
                                    form.action = "ApplyVouncher";
                                    const input = document.createElement("input");
                                    input.type = "hidden";
                                    input.name = "voucherCode";
                                    input.value = code;
                                    form.appendChild(input);
                                    const cartInput = document.createElement("input");
                                    cartInput.type = "hidden";
                                    cartInput.name = "cartJson";
                                    cartInput.value = JSON.stringify(cart);
                                    form.appendChild(cartInput);
                                    document.body.appendChild(form);
                                    form.submit();
                                }
                                function applyPromotion(code) {
                                    document.getElementById("voucherCode").value = code;
                                    applyVoucher();
                                }
        </script>
        <script>
            const contextPath = '<%= request.getContextPath() %>';

            function confirmServed() {
                const form = document.getElementById("completedForm");

                const selected = form.querySelectorAll("input[name='selectedOrders']:checked");

                if (selected.length === 0) {
                    alert("Hãy chọn ít nhất 1 order để xác nhận!");
                    return;
                }

                const formData = new FormData(form);
                for (let [key, value] of formData.entries()) {
                    console.log("FormData =>", key, value);
                }
                fetch(contextPath + "/orders/update-status", {
                    method: "POST",
                    body: formData
                })
                        .then(res => res.json())
                        .then(data => {
                            if (data.success) {
                                alert("✅ Cập nhật thành công!");
                                refreshCompletedOrders();
                            } else {
                                alert("❌ Cập nhật thất bại!");
                            }
                        })
                        .catch(err => console.error("Error:", err));
            }

            function refreshCompletedOrders() {
                fetch(contextPath + "/orders/update-status")
                        .then(res => res.text())
                        .then(html => {
                            const parser = new DOMParser();
                            const doc = parser.parseFromString(html, "text/html");
                            const newSection = doc.querySelector("#completedOrdersSection");
                            if (newSection) {
                                document.getElementById("completedOrdersSection").innerHTML = newSection.innerHTML;
                            }
                        })
                        .catch(err => console.error("Refresh error:", err));
            }
        </script>

    </body>
</html>