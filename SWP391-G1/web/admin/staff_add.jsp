<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Add New Staff</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 30px;
            overflow-y: auto;
        }

        .form-container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 420px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }

        form label {
            display: block;
            margin-top: 12px;
            font-weight: 600;
            color: #333;
        }

        form input, form select {
            width: 100%;
            padding: 10px 12px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        form input:focus, form select:focus {
            outline: none;
            border-color: #4a90e2;
            box-shadow: 0 0 3px rgba(74,144,226,0.3);
        }

        .btn-submit {
            margin-top: 20px;
            width: 100%;
            padding: 10px;
            background: #28a745;
            color: white;
            font-weight: 600;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .btn-submit:hover {
            background: #218838;
        }

        .actions {
            text-align: center;
            margin-top: 15px;
        }

        .actions a {
            color: #555;
            text-decoration: none;
            font-size: 14px;
        }

        .actions a:hover {
            text-decoration: underline;
        }

        .error-msg {
            color: #d9534f;
            text-align: center;
            margin-top: 10px;
            font-weight: 500;
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

    <jsp:include page="admin-panel.jsp" />
    <jsp:include page="user-info.jsp" />
    <div class="main-content">
        <div class="form-container">
            <h2>Add New Staff</h2>

            <form id="addStaffForm" action="${pageContext.request.contextPath}/admin/staff" method="post">
                <input type="hidden" name="action" value="add"/>

                <label>Full Name:</label>
                <input type="text" id="fullname" name="fullname" required />

                <label>Role:</label>
                <select name="role">
                    <option value="4" selected>Staff</option>
                    <option value="3">Manager</option>
                </select>

                <label>Start Date:</label>
                <input type="date" id="startDate" name="startDate" required />

                <label>Phone (optional):</label>
                <input type="text" name="phone" />

                <button type="submit" class="btn-submit">Create</button>

                <div class="actions">
                    <a href="${pageContext.request.contextPath}/admin/staff">← Back to Staff List</a>
                </div>
            </form>

            <c:if test="${not empty error}">
                <p class="error-msg">${error}</p>
            </c:if>
        </div>
    </div>

    <script>
        // Set min date = hôm nay
        const today = new Date().toISOString().split("T")[0];
        document.getElementById("startDate").setAttribute("min", today);

        // Validate Full Name
        document.getElementById("addStaffForm").addEventListener("submit", function(e) {
            const fullnameInput = document.getElementById("fullname");
            const fullname = fullnameInput.value.trim();

            if (fullname === "") {
                e.preventDefault();
                alert("Full Name cannot be empty or just spaces!");
                fullnameInput.focus();
            }
        });
    </script>

</body>
</html>
