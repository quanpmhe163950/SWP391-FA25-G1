<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Add Ingredient</title>
    <style>
        body { font-family: Arial; margin: 30px; }
        form { width: 400px; margin: auto; }
        label { display: block; margin-top: 10px; }
        input[type=text], input[type=number], select {
            width: 100%; padding: 8px; margin-top: 5px;
            border: 1px solid #ccc; border-radius: 4px;
        }
        input[type=submit] {
            margin-top: 15px; padding: 8px 15px; border: none;
            background-color: #4CAF50; color: white; border-radius: 4px; cursor: pointer;
        }
        a { text-decoration: none; color: #2196F3; }
    </style>
</head>
<body>

<h2>Add New Ingredient</h2>
<form action="${pageContext.request.contextPath}/admin/ingredient" method="post">
    <input type="hidden" name="action" value="add" />

    <label>Name:</label>
    <input type="text" name="name" required />

    <label>Unit:</label>
    <select name="unit" required>
        <option value="">-- Select unit --</option>
        <option value="bịch">Bịch</option>
        <option value="thùng">Thùng</option>
        <option value="túi">Túi</option>
        <option value="hộp">Hộp</option>
        <option value="bao">Bao</option>
        <option value="kg">Kg</option>
        <option value="ml">ml</option>
        <option value="l">L</option>
    </select>

    <label>Price:</label>
    <input type="number" step="0.01" name="price" value="0" />

    <input type="submit" value="Save" />
</form>

<br>
<a href="${pageContext.request.contextPath}/admin/ingredient">← Back to list</a>

</body>
</html>
