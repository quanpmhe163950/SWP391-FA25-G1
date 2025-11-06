<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Edit Ingredient</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            min-height: 100vh;
        }

        /* KHÔNG ghi đè CSS sidebar */
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
            width: 400px;
            background: white;
            padding: 25px 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-top: 10px;
            font-weight: 500;
            color: #333;
        }

        input[type=text], input[type=number], select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        input[type=submit] {
            margin-top: 20px;
            padding: 10px 15px;
            border: none;
            background-color: #2196F3;
            color: white;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }

        input[type=submit]:hover {
            background-color: #1976D2;
        }

        a {
            display: block;
            text-align: center;
            margin-top: 15px;
            text-decoration: none;
            color: #2196F3;
        }
                /* ===== Header giống home ===== */
    </style>
</head>
<body>
    <!-- Import sidebar -->
    <jsp:include page="admin-panel.jsp" />
    <jsp:include page="user-info.jsp" />
    <div class="main-content">
        <div class="form-container">
            <h2>Edit Ingredient</h2>
            <form action="${pageContext.request.contextPath}/admin/ingredient" method="post">
                <input type="hidden" name="action" value="edit" />
                <input type="hidden" name="id" value="${ingredient.id}" />

                <label>Name:</label>
                <input type="text" name="name" value="${ingredient.name}" required />

                <label>Unit:</label>
                <select name="unit" required>
                    <option value="kg" ${ingredient.unit == 'kg' ? 'selected' : ''}>Kg</option>
                    <option value="g" ${ingredient.unit == 'g' ? 'selected' : ''}>g</option>
                    <option value="ml" ${ingredient.unit == 'ml' ? 'selected' : ''}>ml</option>
                    <option value="l" ${ingredient.unit == 'l' ? 'selected' : ''}>L</option>
                </select>

                <input type="submit" value="Update" />
            </form>

            <a href="${pageContext.request.contextPath}/admin/ingredient">← Back to list</a>
        </div>
    </div>
</body>
</html>
