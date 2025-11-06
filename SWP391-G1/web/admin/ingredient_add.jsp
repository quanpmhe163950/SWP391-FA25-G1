<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Add Ingredient</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 40px;
            box-sizing: border-box;
            background-color: #f9fbfd;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .form-container {
            background: white;
            padding: 30px 40px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            width: 400px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-top: 10px;
            font-weight: 600;
        }

        input[type=text],
        input[type=number],
        select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        input[type=submit] {
            margin-top: 20px;
            padding: 10px 15px;
            border: none;
            background-color: #4CAF50;
            color: white;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-weight: bold;
        }

        input[type=submit]:hover {
            background-color: #43a047;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            text-decoration: none;
            color: #2196F3;
        }

        .back-link:hover {
            text-decoration: underline;
        }
                /* ===== Header giống home ===== */
        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

    </style>
</head>
<body>

    <!-- Import sidebar -->
    <jsp:include page="admin-panel.jsp" />
<jsp:include page="user-info.jsp" />
    <div class="main-content">
        <div class="form-container">
            <h2>Add New Ingredient</h2>

            <form id="addIngredientForm" action="${pageContext.request.contextPath}/admin/ingredient" method="post">
                <input type="hidden" name="action" value="add" />

                <label>Name:</label>
                <input type="text" id="ingredientName" name="name" required />

                <label>Unit:</label>
                <select name="unit" required>
                    <option value="kg">Kg</option>
                    <option value="g">g</option>
                    <option value="ml">ml</option>
                    <option value="l">L</option>
                </select>

                <input type="submit" value="Save" />
            </form>

            <a href="${pageContext.request.contextPath}/admin/ingredient" class="back-link">← Back to list</a>
        </div>
    </div>

    <script>
        // Validate: Name không được rỗng hoặc toàn khoảng trắng
        document.getElementById("addIngredientForm").addEventListener("submit", function(e) {
            const nameInput = document.getElementById("ingredientName");
            const nameValue = nameInput.value.trim();

            if (nameValue === "") {
                e.preventDefault();
                alert("Ingredient name cannot be empty or just spaces!");
                nameInput.focus();
            }
        });
    </script>

</body>
</html>
