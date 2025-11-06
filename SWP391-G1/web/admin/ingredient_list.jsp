<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Ingredient Management</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            min-height: 100vh;
        }

        /* Không đụng CSS sidebar */
        .main-content {
            flex: 1;
            padding: 40px;
            box-sizing: border-box;
            background-color: #f9fbfd;
        }

        h2 {
            margin-bottom: 15px;
            color: #333;
        }

        .search-box {
            margin-bottom: 20px;
        }

        input[type=text] {
            padding: 8px;
            width: 250px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button, a.btn {
            text-decoration: none;
            background-color: #2196F3;
            color: white;
            padding: 8px 14px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
        }

        button:hover, a.btn:hover {
            background-color: #1976D2;
        }

        a.btn-edit {
            background-color: #4CAF50;
        }

        a.btn-edit:hover {
            background-color: #43A047;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 15px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        th, td {
            border: 1px solid #eee;
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #f1f1f1;
            color: #333;
        }

        tr:hover {
            background-color: #f9f9f9;
        }

        .pagination {
            margin-top: 20px;
            text-align: center;
        }

        .pagination button {
            background-color: white;
            color: #2196F3;
            border: 1px solid #2196F3;
            padding: 6px 12px;
            border-radius: 4px;
            margin: 0 3px;
            cursor: pointer;
        }

        .pagination button.active {
            background-color: #2196F3;
            color: white;
        }

        .pagination button:hover {
            background-color: #1976D2;
            color: white;
        }

        .empty-row {
            text-align: center;
            color: #777;
            font-style: italic;
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

    <div class="main-content">
                <div class="header-bar">
            <h2>Ingredient List</h2>
            <jsp:include page="user-info.jsp" />
        </div>

        <div class="search-box">
            <input type="text" id="searchInput" placeholder="Search ingredient name..." />
            <a href="${pageContext.request.contextPath}/admin/ingredient?action=add" class="btn">+ Add New Ingredient</a>
        </div>

        <table id="ingredientTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Unit</th>
                    <th>Stock Quantity</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="i" items="${list}">
                    <tr>
                        <td>${i.id}</td>
                        <td>${i.name}</td>
                        <td>${i.unit}</td>
                        <td>${i.quantity}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/ingredient?action=edit&id=${i.id}" class="btn btn-edit">Edit</a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty list}">
                    <tr><td colspan="5" class="empty-row">No ingredients found.</td></tr>
                </c:if>
            </tbody>
        </table>

        <div class="pagination" id="pagination"></div>
    </div>

    <script>
    const rowsPerPage = 10;
    const table = document.getElementById("ingredientTable").getElementsByTagName("tbody")[0];
    const rows = Array.from(table.getElementsByTagName("tr"));
    const pagination = document.getElementById("pagination");
    const searchInput = document.getElementById("searchInput");

    let currentPage = 1;
    let filteredRows = rows;

    function renderTable() {
        table.innerHTML = "";

        const start = (currentPage - 1) * rowsPerPage;
        const end = start + rowsPerPage;
        const pageRows = filteredRows.slice(start, end);

        if (pageRows.length === 0) {
            table.innerHTML = '<tr><td colspan="5" class="empty-row">No ingredients found.</td></tr>';
        } else {
            pageRows.forEach(r => table.appendChild(r));
        }

        renderPagination();
    }

    function renderPagination() {
        pagination.innerHTML = "";
        const totalPages = Math.ceil(filteredRows.length / rowsPerPage);

        // Nếu không có dữ liệu -> không hiển thị nút phân trang
        if (filteredRows.length === 0) return;

        // Luôn hiển thị ít nhất 1 nút (trang 1)
        const pagesToRender = totalPages > 0 ? totalPages : 1;

        for (let i = 1; i <= pagesToRender; i++) {
            const btn = document.createElement("button");
            btn.textContent = i;
            if (i === currentPage) btn.classList.add("active");
            btn.addEventListener("click", () => {
                currentPage = i;
                renderTable();
            });
            pagination.appendChild(btn);
        }
    }

    function filterTable() {
        const keyword = searchInput.value.toLowerCase();
        filteredRows = rows.filter(r => {
            const name = r.cells[1]?.textContent.toLowerCase() || "";
            return name.includes(keyword);
        });
        currentPage = 1;
        renderTable();
    }

    searchInput.addEventListener("input", filterTable);

    renderTable();
</script>

</body>
</html>
