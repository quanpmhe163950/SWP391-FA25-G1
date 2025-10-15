<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Edit Ingredient</title>
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
            background-color: #2196F3; color: white; border-radius: 4px; cursor: pointer;
        }
        a { text-decoration: none; color: #2196F3; }
    </style>
</head>
<body>

<h2>Edit Ingredient</h2>
<form action="${pageContext.request.contextPath}/admin/ingredient" method="post">
    <input type="hidden" name="action" value="edit" />
    <input type="hidden" name="id" value="${ingredient.id}" />

    <label>Name:</label>
    <input type="text" name="name" value="${ingredient.name}" required />

    <label>Unit:</label>
    <select name="unit" required>
        <option value="bịch" ${ingredient.unit == 'bịch' ? 'selected' : ''}>Bịch</option>
        <option value="thùng" ${ingredient.unit == 'thùng' ? 'selected' : ''}>Thùng</option>
        <option value="túi" ${ingredient.unit == 'túi' ? 'selected' : ''}>Túi</option>
        <option value="hộp" ${ingredient.unit == 'hộp' ? 'selected' : ''}>Hộp</option>
        <option value="bao" ${ingredient.unit == 'bao' ? 'selected' : ''}>Bao</option>
        <option value="kg" ${ingredient.unit == 'kg' ? 'selected' : ''}>Kg</option>
        <option value="ml" ${ingredient.unit == 'ml' ? 'selected' : ''}>ml</option>
        <option value="l" ${ingredient.unit == 'l' ? 'selected' : ''}>L</option>
    </select>

    <label>Price:</label>
    <input type="number" step="0.01" name="price" value="${ingredient.price}" />

    <input type="submit" value="Update" />
</form>

<br>
<a href="${pageContext.request.contextPath}/admin/ingredient">← Back to list</a>

</body>
</html>
