<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Item"%>
<%@page import="model.ItemSizePrice"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Item</title>

        <style>
            body {
                margin: 0;
                font-family: "Segoe UI", Arial, sans-serif;
                background-color: #f4f6f8;
                display: flex;
                height: 100vh;
                overflow: hidden;
            }

            /* ✅ Main container */
            .main-container {
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            /* ✅ Navbar */
            .navbar {
                background-color: white;
                height: 60px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.1);
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 25px;
            }

            .navbar h1 {
                font-size: 20px;
                color: #2c3e50;
            }

            /* ✅ Content */
            .main-content {
                flex: 1;
                padding: 30px 40px;
                overflow-y: auto;
            }

            .form-box {
                width: 620px;
                background: white;
                border-radius: 12px;
                padding: 25px 30px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            label {
                font-weight: 600;
                display: block;
                margin-top: 15px;
            }

            input[type=text],
            input[type=number],
            select,
            textarea,
            input[type=file] {
                width: 100%;
                padding: 10px;
                margin-top: 6px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-size: 14px;
                box-sizing: border-box;
            }

            textarea {
                resize: none;
                height: 100px;
            }

            .error {
                color: red;
                font-size: 0.9em;
            }

            /* ✅ Size & Price layout */
            .size-row {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 8px;
            }

            .size-row input[type=text] {
                flex: 7;
            }
            .size-row input[type=number] {
                flex: 3;
            }

            .btn-remove {
                background-color: #dc3545;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 6px 8px;
                cursor: pointer;
            }

            .btn-remove:hover {
                background-color: #c82333;
            }

            .btn-add {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 8px 12px;
                border-radius: 6px;
                cursor: pointer;
                margin-top: 10px;
            }

            .btn-add:hover {
                background-color: #218838;
            }

            button.submit-btn {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 10px 18px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: bold;
                margin-top: 15px;
            }

            button.submit-btn:hover {
                background-color: #0056b3;
            }

            a.cancel-btn {
                background-color: #ccc;
                color: black;
                padding: 10px 18px;
                text-decoration: none;
                border-radius: 6px;
                margin-left: 10px;
                font-weight: bold;
            }

            a.cancel-btn:hover {
                background-color: #b3b3b3;
            }

            img.preview {
                display: block;
                margin-top: 8px;
                max-width: 100%;
                border-radius: 4px;
                border: 1px solid #ccc;
            }
            .size-row {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 8px;
            }

            .size-row select {
                flex: 7;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-size: 14px;
            }

            .size-row input[type=number] {
                flex: 3;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-size: 14px;
            }

            .size-row .btn-remove {
                background-color: #dc3545;
                padding: 6px 8px;
                font-size: 14px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
            }

            .size-row .btn-remove:hover {
                background-color: #c82333;
            }

        </style>
    </head>

    <body>

        <!-- ✅ Sidebar -->
        <jsp:include page="admin/admin-panel.jsp" />

        <!-- ✅ Main container -->
        <div class="main-container">

            <!-- ✅ Navbar -->
            <div class="navbar">
                <h1>Edit Item</h1>
                <jsp:include page="admin/user-info.jsp" />
            </div>

            <!-- ✅ Main content -->
            <div class="main-content">
                <div class="form-box">

                    <%
                        Item item = (Item) request.getAttribute("item");
                        if (item == null) {
                    %>
                    <p class="error">Item not found!</p>
                    <% } else {
                        Map<String,String> errors = (Map<String,String>) request.getAttribute("errors");
                    %>

                    <form action="editItem" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="itemID" value="<%= item.getItemID() %>">

                        <!-- Name -->
                        <label>Item Name:</label>
                        <input type="text" name="name"
                               value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : item.getName() %>"
                               required>
                        <span class="error"><%= errors != null && errors.get("nameError") != null ? errors.get("nameError") : "" %></span>

                        <!-- Description -->
                        <label>Description:</label>
                        <textarea name="description"><%= request.getAttribute("description") != null 
                                ? request.getAttribute("description") 
                                : (item.getDescription() != null ? item.getDescription() : "") %></textarea>

                        <!-- Status -->
                        <label>Status:</label>
                        <select name="status">
                            <option value="Available" <%= "Available".equals(item.getStatus()) ? "selected" : "" %>>Available</option>
                            <option value="Unavailable" <%= "Unavailable".equals(item.getStatus()) ? "selected" : "" %>>Unavailable</option>
                        </select>

                        <!-- Sizes & Prices -->
                        <label>Sizes & Prices:</label>
                        <div id="sizePriceContainer">
                            <%
                                List<ItemSizePrice> sizeList = item.getSizePriceList();
                                if (sizeList != null && !sizeList.isEmpty()) {
                                    for (int i = 0; i < sizeList.size(); i++) {
                                        ItemSizePrice isp = sizeList.get(i);
                            %>
                            <div class="size-row">

                                <!-- Size input -->
                                <input type="text" name="sizeName"
                                       value="<%= isp.getSize() %>"
                                       placeholder="Size"
                                       required>

                                <!-- Price input -->
                                <input type="number" name="sizePrice"
                                       value="<%= isp.getPrice() %>"
                                       placeholder="Price"
                                       step="0.01" min="1" required>

                                <!-- Remove button styled like mẫu -->
                                <button type="button" class="btn-remove" <%= i == 0 ? "disabled" : "" %>>❌</button>
                            </div>
                            <%
                                    }
                                } else {
                            %>

                            <!-- Nếu chưa có size nào -->
                            <div class="size-row">
                                <input type="text" name="sizeName" placeholder="Size" required>
                                <input type="number" name="sizePrice" placeholder="Price" step="0.01" min="1" required>
                                <button type="button" class="btn-remove" disabled>❌</button>
                            </div>

                            <% } %>
                        </div>

                        <!-- Lỗi validation -->
                        <span class="error">
                            <%= errors != null && errors.get("sizeError") != null ? errors.get("sizeError") : "" %>
                            <%= errors != null && errors.get("priceError") != null ? errors.get("priceError") : "" %>
                        </span>

                        <!-- Nút add giống mẫu -->
                        <button type="button" id="addSizeBtn" class="btn-add">+ Add another size</button>

                        <!-- Image -->
                        <label>Image:</label>
                        <% String ctx = request.getContextPath(); %>
                        <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                        <img src="<%= ctx + "/" + item.getImagePath() %>" alt="Current Image" class="preview">
                        <% } else { %>
                        <p style="font-size: 0.9em; color: gray;">No image uploaded</p>
                        <% } %>
                        <input type="file" name="image">

                        <br>
                        <button type="submit" class="submit-btn">💾 Save Changes</button>
                        <a href="listItem" class="cancel-btn">Cancel</a>
                    </form>
                    <% } %>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const container = document.getElementById("sizePriceContainer");
                const form = document.querySelector("form");

                container.addEventListener("click", function (e) {
                    if (e.target.classList.contains("btn-remove")) {
                        const rows = container.querySelectorAll(".size-row");
                        if (rows.length > 1) {
                            e.target.closest(".size-row").remove();
                        } else {
                            alert("Không thể xóa size cuối cùng!");
                        }
                    }
                });

                document.getElementById("addSizeBtn").addEventListener("click", function () {
                    const newRow = document.createElement("div");
                    newRow.classList.add("size-row");

                    newRow.innerHTML = `
            <input type="text" name="sizeName" placeholder="Size" required>
            <input type="number" name="sizePrice" placeholder="Price" step="0.01" min="1" required>
            <button type="button" class="btn-remove">❌</button>
        `;

                    container.appendChild(newRow);
                });

                form.addEventListener("submit", function (e) {
                    let valid = true;
                    const rows = container.querySelectorAll(".size-row");

                    // Reset lỗi
                    rows.forEach((row) => {
                        row.querySelector("input[name='sizeName']").setCustomValidity("");
                        row.querySelector("input[name='sizePrice']").setCustomValidity("");
                    });

                    // Kiểm tra từng cặp size/price
                    rows.forEach((row) => {
                        const sizeInput = row.querySelector("input[name='sizeName']");
                        const priceInput = row.querySelector("input[name='sizePrice']");
                        const sizeVal = sizeInput.value.trim();
                        const priceVal = priceInput.value.trim();

                        if (sizeVal && !priceVal) {
                            priceInput.setCustomValidity("Vui lòng nhập giá cho size này.");
                            valid = false;
                        } else if (!sizeVal && priceVal) {
                            sizeInput.setCustomValidity("Vui lòng nhập tên size.");
                            valid = false;
                        } else if (priceVal && parseFloat(priceVal) <= 0) {
                            priceInput.setCustomValidity("Giá phải lớn hơn 0.");
                            valid = false;
                        }
                    });

                    const sizeInputs = Array.from(document.querySelectorAll("input[name='sizeName']"));
                    const sizeNames = sizeInputs.map(i => i.value.trim().toLowerCase()).filter(s => s !== "");
                    const duplicates = sizeNames.filter((v, i, a) => a.indexOf(v) !== i);

                    if (duplicates.length > 0) {
                        e.preventDefault();
                        const dupValue = duplicates[0];
                        const dupInput = sizeInputs.find(i => i.value.trim().toLowerCase() === dupValue);
                        dupInput.setCustomValidity(`Tên size "${dupInput.value}" đã tồn tại.`);
                        dupInput.reportValidity();
                        valid = false;
                    }

                    // Nếu có lỗi
                    if (!valid) {
                        e.preventDefault();
                        form.reportValidity();
                    }
                });

                container.addEventListener("input", function (e) {
                    if (e.target.name === "sizeName" || e.target.name === "sizePrice") {
                        e.target.setCustomValidity("");
                    }

                    // Reset luôn lỗi trùng size
                    container.querySelectorAll("input[name='sizeName']")
                            .forEach(i => i.setCustomValidity(""));
                });
            });
        </script>

    </body>
</html>

