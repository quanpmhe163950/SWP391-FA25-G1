<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Supplier" %>

<%
    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Tạo đơn đặt hàng</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            height: 100vh;
        }
        .main-container {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .navbar {
            background-color: white;
            height: 60px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            padding: 0 25px;
        }
        .main-content {
            flex: 1;
            padding: 25px 35px;
            overflow-y: auto;
        }
        .form-box {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }
        label { font-weight: bold; display: inline-block; margin-top: 10px; }
        select, input[type="text"], input[type="number"] {
            padding: 7px;
            border: 1px solid #ccc;
            border-radius: 6px;
            width: 250px;
        }
        .btn {
            padding: 8px 12px;
            border: none;
            border-radius: 6px;
            color: white;
            cursor: pointer;
        }
        .btn-green { background: #27ae60; }
        .btn-blue { background: #3498db; }
    </style>

    <script>
        const baseUrl = "<%= request.getContextPath() %>";

        // Load danh sách nguyên liệu theo supplier
        function loadIngredients() {
            const supplierID = document.getElementById("supplierID").value;

            if (!supplierID) {
                document.getElementById("ingredientArea").innerHTML =
                    "<p>Hãy chọn nhà cung cấp để hiển thị nguyên liệu.</p>";
                return;
            }

            fetch(baseUrl + "/admin/purchase-order?action=loadIngredients&supplierID=" + supplierID)
                .then(res => res.text())
                .then(html => {
                    document.getElementById("ingredientArea").innerHTML = html;
                })
                .catch(err => console.error("Lỗi load nguyên liệu:", err));
        }

        // Gom dữ liệu nguyên liệu để gửi trong form
        function collectSelectedIngredients() {
            const checkboxes = document.querySelectorAll(".ing-check:checked");
            const selected = [];

            checkboxes.forEach(cb => {
                const id = cb.value;
                const unitType = document.getElementById("unit_" + id)?.value || "";
                const subQty = document.getElementById("sub_" + id)?.value || "0";
                const unitQty = document.getElementById("qty_" + id)?.value || "0";
                const price = document.getElementById("price_" + id)?.textContent || "0";

                selected.push({
                    ingredientID: id,
                    unitType: unitType,
                    subQuantityPerUnit: subQty,
                    unitQuantity: unitQty,
                    pricePerUnit: price
                });
            });

            return selected;
        }

        // Chuyển object sang JSON string trước khi submit form
        function beforeSubmit() {
            const supplierID = document.getElementById("supplierID").value;
            if (!supplierID) {
                alert("⚠️ Vui lòng chọn nhà cung cấp!");
                return false;
            }

            const items = collectSelectedIngredients();
            if (items.length === 0) {
                alert("⚠️ Vui lòng chọn ít nhất một nguyên liệu!");
                return false;
            }

            // Gắn dữ liệu vào hidden input
            document.getElementById("itemsData").value = JSON.stringify(items);
            return true;
        }
    </script>
</head>

<body>
    <jsp:include page="admin-panel.jsp" />

    <div class="main-container">
        <div class="navbar">
            <h1>Tạo đơn đặt hàng</h1>
        </div>

        <div class="main-content">
            <div class="form-box">
                <h3>Thông tin đơn hàng</h3>

                <form action="<%= request.getContextPath() %>/admin/purchase-order" 
                      method="post" 
                      onsubmit="return beforeSubmit()">

                    <input type="hidden" name="action" value="saveOrder">
                    <input type="hidden" id="itemsData" name="itemsData"> <!-- chứa JSON nguyên liệu -->

                    <label>Nhà cung cấp:</label><br>
                    <select name="supplierID" id="supplierID" onchange="loadIngredients()">
                        <option value="">-- Chọn nhà cung cấp --</option>
                        <% for (Supplier s : suppliers) { %>
                            <option value="<%= s.getSupplierID() %>"><%= s.getSupplierName() %></option>
                        <% } %>
                    </select>

                    <br><br>
                    <label>Ghi chú:</label><br>
                    <input type="text" name="note" id="note" style="width: 400px;">

                    <br><br>
                    <button class="btn btn-green" type="submit">Tạo đơn</button>
                </form>
            </div>

            <div class="form-box">
                <h3>Danh sách nguyên liệu</h3>
                <div id="ingredientArea">
                    <p>Hãy chọn nhà cung cấp để hiển thị nguyên liệu.</p>
                </div>
            </div>
        </div>
    </div>
</body>
<script>
function submitOrder(event) {
    event.preventDefault();

    const supplierID = document.getElementById("supplierID").value;
    const note = document.getElementById("note").value;
    const items = collectSelectedIngredients();

    if (!supplierID) {
        alert("Vui lòng chọn nhà cung cấp!");
        return;
    }
    if (items.length === 0) {
        alert("Vui lòng chọn ít nhất 1 nguyên liệu!");
        return;
    }

    // Gửi dữ liệu qua form POST bình thường
    const form = document.createElement("form");
    form.method = "POST";
    form.action = baseUrl + "/admin/purchase-order";

    form.innerHTML = `
        <input type="hidden" name="action" value="saveOrder">
        <input type="hidden" name="supplierID" value="${supplierID}">
        <input type="hidden" name="note" value="${note}">
        <input type="hidden" name="itemsData" value='${JSON.stringify(items)}'>
    `;

    document.body.appendChild(form);
    form.submit();
}
</script>

</html>
