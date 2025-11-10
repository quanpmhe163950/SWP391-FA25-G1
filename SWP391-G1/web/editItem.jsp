<%-- 
    Document   : editItem
    Created on : Oct 31, 2025, 2:51:17 PM
    Author     : admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Item"%>
<%@page import="model.ItemSizePrice"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Pizza Shop - Edit Item</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 30px 0;
                display: flex;
                justify-content: center;
                background-color: #f5f5f5;
            }
            .form-container {
                background-color: #f9f9f9;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 25px 35px;
                width: 520px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            h2 {
                color: #333;
                margin-top: 0;
                margin-bottom: 20px;
            }
            label {
                font-weight: bold;
                display: block;
                margin-top: 10px;
            }
            input[type=text],
            input[type=number],
            select,
            input[type=file],
            textarea {
                width: 100%;
                padding: 8px;
                margin-top: 5px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 14px;
            }
            .error {
                color: red;
                font-size: 0.9em;
                margin-left: 3px;
            }
            .size-price-row {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-top: 6px;
            }
            .size-price-row input {
                flex: 1;
            }
            .remove-size {
                border: 1px solid #dc3545;
                color: #dc3545;
                background: transparent;
                border-radius: 4px;
                cursor: pointer;
                padding: 3px 8px;
                font-weight: bold;
                transition: 0.2s;
            }
            .remove-size:hover:not(:disabled) {
                background-color: #dc3545;
                color: white;
            }
            .remove-size:disabled {
                opacity: 0.4;
                cursor: not-allowed;
            }
            .add-size-btn {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 6px 10px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 13px;
                margin-top: 10px;
            }
            .add-size-btn:hover {
                background-color: #0056b3;
            }
            .submit-btn {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 10px 18px;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
                margin-top: 15px;
            }
            .submit-btn:hover {
                background-color: #1e7e34;
            }
            .cancel-btn {
                display: inline-block;
                background-color: #ccc;
                color: black;
                padding: 10px 18px;
                text-decoration: none;
                border-radius: 4px;
                margin-left: 10px;
                font-weight: bold;
            }
            .cancel-btn:hover {
                background-color: #b3b3b3;
            }
            img.preview {
                display: block;
                margin-top: 8px;
                max-width: 100%;
                height: auto;
                border-radius: 4px;
                border: 1px solid #ccc;
            }
        </style>
    </head>
    <body>
        <div class="form-container">
            <h2>✏️ Edit Item</h2>

            <%
                Item item = (Item) request.getAttribute("item");
                if (item == null) {
            %>
            <p class="error">Item not found!</p>
            <% } else {
                java.util.Map<String,String> errors = (java.util.Map<String,String>) request.getAttribute("errors");
            %>

            <form action="editItem" method="post" enctype="multipart/form-data">
                <input type="hidden" name="itemID" value="<%= item.getItemID() %>">

                <!-- Item Name -->
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
                    <div class="size-price-row">
                        <input type="text" name="sizeName" value="<%= isp.getSize() %>" placeholder="Size">
                        <input type="number" name="sizePrice" value="<%= isp.getPrice() %>" placeholder="Price" step="0.01">
                        <button type="button" class="remove-size" <%= i == 0 ? "disabled" : "" %>>✕</button>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
                <!-- 🟥 Hiển thị lỗi trùng size hoặc giá không hợp lệ -->
                <span class="error">
                    <%= errors != null && errors.get("sizeError") != null ? errors.get("sizeError") : "" %>
                    <%= errors != null && errors.get("priceError") != null ? errors.get("priceError") : "" %>
                </span>

                <button type="button" id="addSizeBtn" class="add-size-btn">+ Add Size</button>

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

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const container = document.getElementById("sizePriceContainer");
                const form = document.querySelector("form");

                // Xóa size
                container.addEventListener("click", function (e) {
                    if (e.target.classList.contains("remove-size")) {
                        const rows = container.querySelectorAll(".size-price-row");
                        if (rows.length > 1) {
                            e.target.closest(".size-price-row").remove();
                        } else {
                            alert("Không thể xóa size cuối cùng!");
                        }
                    }
                });

                // Thêm size mới
                document.getElementById("addSizeBtn").addEventListener("click", function () {
                    const newRow = document.createElement("div");
                    newRow.classList.add("size-price-row");
                    newRow.innerHTML = `
            <input type="text" name="sizeName" placeholder="Size (e.g. S, M, L)" required>
            <input type="number" name="sizePrice" placeholder="Price" step="0.01" min="1" required>
            <button type="button" class="remove-size">✕</button>
        `;
                    container.appendChild(newRow);
                });

                // ✅ Kiểm tra hợp lệ khi submit
                form.addEventListener("submit", function (e) {
                    let valid = true;
                    const rows = container.querySelectorAll(".size-price-row");

                    // Reset tất cả lỗi trước khi kiểm tra
                    rows.forEach((row) => {
                        row.querySelector("input[name='sizeName']").setCustomValidity("");
                        row.querySelector("input[name='sizePrice']").setCustomValidity("");
                    });

                    // Kiểm tra giá trị hợp lệ
                    rows.forEach((row) => {
                        const sizeInput = row.querySelector("input[name='sizeName']");
                        const priceInput = row.querySelector("input[name='sizePrice']");
                        const sizeVal = sizeInput.value.trim();
                        const priceVal = priceInput.value.trim();

                        if (sizeVal && !priceVal) {
                            priceInput.setCustomValidity("Vui lòng nhập giá cho size này.");
                            valid = false;
                        } else if (!sizeVal && priceVal) {
                            sizeInput.setCustomValidity("Vui lòng nhập tên size cho giá này.");
                            valid = false;
                        } else if (priceVal && parseFloat(priceVal) <= 0) {
                            priceInput.setCustomValidity("Giá phải lớn hơn 0.");
                            valid = false;
                        }
                    });

                    // 🔹 Kiểm tra trùng tên size (case-insensitive)
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

                    if (!valid) {
                        e.preventDefault();
                        form.reportValidity();
                    }
                });

                // ✅ Xóa thông báo lỗi khi người dùng nhập lại
                container.addEventListener("input", function (e) {
                    if (e.target.name === "sizeName" || e.target.name === "sizePrice") {
                        e.target.setCustomValidity("");
                    }

                    // Nếu người dùng thay đổi tên size, reset luôn lỗi trùng
                    const allInputs = container.querySelectorAll("input[name='sizeName']");
                    allInputs.forEach(i => i.setCustomValidity(""));
                });
            });
        </script>
    </body>
</html>

