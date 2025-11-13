<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="model.Category"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Item</title>

    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* Main container */
        .main-container {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        /* Navbar */
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

        /* Main content */
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
        textarea {
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

        button {
            margin-top: 18px;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }

        button:hover {
            background-color: #0056b3;
        }

        .error-global { color: red; font-weight: bold; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-size: 0.9em; }

        .size-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 8px;
        }

        .size-row input {
            flex: 1;
        }

        .btn-add {
            background-color: #28a745;
            padding: 6px 10px;
            font-size: 14px;
        }

        .btn-add:hover {
            background-color: #218838;
        }

        .btn-remove {
            background-color: #dc3545;
            padding: 6px 8px;
            font-size: 14px;
        }

        .btn-remove:hover {
            background-color: #c82333;
        }

        a {
            color: #007bff;
            text-decoration: none;
            margin-right: 10px;
            font-size: 14px;
        }
        a:hover { text-decoration: underline; }

        h2 { margin-top: 0; color: #333; }
        
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
        <h1>Add New Item</h1>
        <jsp:include page="admin/user-info.jsp" />
    </div>

    <!-- ✅ Main content -->
    <div class="main-content">

        <div class="form-box">

            <%-- MESSAGES --%>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <p class="error-global"><%= request.getAttribute("errorMessage") %></p>
            <% } %>

            <% if (request.getAttribute("successMessage") != null) { %>
                <p class="success"><%= request.getAttribute("successMessage") %></p>
            <% } %>

            <%
                Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
                String itemName = (String) request.getAttribute("itemName");
                String description = (String) request.getAttribute("description");
                String status = (String) request.getAttribute("status");

                String categoryID = null;
                if (request.getAttribute("categoryID") != null) {
                    categoryID = (String) request.getAttribute("categoryID");
                } else if (request.getParameter("categoryID") != null) {
                    categoryID = request.getParameter("categoryID");
                }

                List<Category> categoryList = (List<Category>) request.getAttribute("categoryList");
            %>

            <form action="addItem" method="POST" enctype="multipart/form-data">

                <!-- Item Name -->
                <label for="itemName">Item name:</label>
                <input type="text" id="itemName" name="itemName"
                       value="<%= itemName != null ? itemName : "" %>" required>
                <span class="error"><%= (errors != null && errors.get("itemNameError") != null) ? errors.get("itemNameError") : "" %></span>

                <!-- Description -->
                <label for="description">Description:</label>
                <textarea id="description" name="description"><%= description != null ? description : "" %></textarea>

                <!-- Category -->
                <label for="categoryID">Category:</label>
                <select id="categoryID" name="categoryID" required>
                    <option value="">-- Select Category --</option>

                    <% 
                        if (categoryList != null) {
                            for (Category category : categoryList) {
                                boolean selected = (categoryID != null &&
                                        categoryID.equals(String.valueOf(category.getCategoryID())));
                    %>
                    <option value="<%=category.getCategoryID()%>" <%=selected ? "selected" : "" %>>
                        <%=category.getCategoryName()%>
                    </option>
                    <% 
                            }
                        }
                    %>
                </select>
                <span class="error"><%= (errors != null && errors.get("categoryError") != null) ? errors.get("categoryError") : "" %></span>

                <!-- Size & Price -->
                <h3>Size & Price</h3>
                <div id="sizes-container">

    <%
        String[] sizes = request.getParameterValues("size");
        String[] prices = request.getParameterValues("price");

        if (sizes != null && prices != null) {
            for (int i = 0; i < sizes.length; i++) {
    %>
        <div class="size-row">
            <select name="size" required>
                <option value="">-- Select Size --</option>
                <option value="Đại" <%= "Đại".equals(sizes[i]) ? "selected" : "" %>>Đại</option>
                <option value="Lớn" <%= "Lớn".equals(sizes[i]) ? "selected" : "" %>>Lớn</option>
                <option value="Vừa" <%= "Vừa".equals(sizes[i]) ? "selected" : "" %>>Vừa</option>
                <option value="Nhỏ" <%= "Nhỏ".equals(sizes[i]) ? "selected" : "" %>>Nhỏ</option>
            </select>

            <input type="number" name="price"
       value="<%= prices[i] != null ? prices[i] : "" %>"
       step="0.01" placeholder="Price" required>


            <button type="button" class="btn-remove" onclick="removeRow(this)">❌</button>
        </div>
    <% 
            }
        } else { 
    %>
        <div class="size-row">
            <select name="size" required>
                <option value="">-- Select Size --</option>
                <option value="Đại">Đại</option>
                <option value="Lớn">Lớn</option>
                <option value="Vừa">Vừa</option>
                <option value="Nhỏ">Nhỏ</option>
            </select>

            <input type="number" name="price"
                   placeholder="Price" step="0.01" required>
        </div>
    <% } %>

</div>

                <button type="button" class="btn-add" onclick="addSizeRow()">+ Add another size</button>
                <span class="error"><%= (errors != null && errors.get("sizeError") != null) ? errors.get("sizeError") : "" %></span>

                <!-- Status -->
                <label for="status">Status:</label>
                <select id="status" name="status" required>
                    <option value="Available" <%= "Available".equals(status) ? "selected" : "" %>>Available</option>
                    <option value="Unavailable" <%= "Unavailable".equals(status) ? "selected" : "" %>>Unavailable</option>
                </select>

                <!-- Image -->
                <label for="image">Image:</label>
                <input type="file" id="image" name="image" accept=".jpg,.jpeg,.png">
                <span class="error"><%= (errors != null && errors.get("imageError") != null) ? errors.get("imageError") : "" %></span>

                <br>

                <button type="submit">Add Item</button>

                <p style="margin-top: 12px;">
                    <a href="listCategory">← Back to Category List</a>
                </p>
            </form>

        </div>
    </div>

</div>

<script>
   function addSizeRow() {
    const container = document.getElementById('sizes-container');
    const div = document.createElement('div');
    div.className = 'size-row';
    div.innerHTML = `
        <select name="size" required>
            <option value="">-- Select Size --</option>
            <option value="Đại">Đại</option>
            <option value="Lớn">Lớn</option>
            <option value="Vừa">Vừa</option>
            <option value="Nhỏ">Nhỏ</option>
        </select>

        <input type="number" name="price" placeholder="Price" step="0.01" required>
        <button type="button" class="btn-remove" onclick="removeRow(this)">❌</button>
    `;
    container.appendChild(div);
}

    function removeRow(button) {
        button.parentElement.remove();
    }
</script>

</body>
</html>
