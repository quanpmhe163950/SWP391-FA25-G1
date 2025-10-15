<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Add New Staff</title>
    <style>
        body { font-family: Arial; margin: 30px; }
        form { max-width: 400px; }
        label { display: block; margin-top: 10px; font-weight: bold; }
        input, select { width: 100%; padding: 6px; margin-top: 5px; }
        button { margin-top: 15px; padding: 8px 15px; background: #28a745; color: #fff; border: none; border-radius: 5px; cursor: pointer; }
        button:hover { background: #218838; }
        a { margin-left: 10px; text-decoration: none; color: #555; }
    </style>
</head>
<body>
<h2>Add New Staff</h2>

<form action="${pageContext.request.contextPath}/admin/staff" method="post">
    <input type="hidden" name="action" value="add"/>

    <label>Full name:</label>
    <input type="text" name="fullname" required />

    <label>Role:</label>
    <select name="role">
        <option value="4" selected>Staff</option>
        <option value="3">Manager</option>
    </select>

    <label>Start Date:</label>
    <input type="date" id="startDate" name="startDate" required />

    <label>Phone (optional):</label>
    <input type="text" name="phone" />

    <button type="submit">Create</button>
    <a href="${pageContext.request.contextPath}/admin/staff">Cancel</a>
</form>

<c:if test="${not empty error}">
    <p style="color:red;">${error}</p>
</c:if>

<script>
    // Set min date = hôm nay để disable ngày quá khứ
    const today = new Date().toISOString().split("T")[0];
    document.getElementById("startDate").setAttribute("min", today);
</script>

</body>
</html>
