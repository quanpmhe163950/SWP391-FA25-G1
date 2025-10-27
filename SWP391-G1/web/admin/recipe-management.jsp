<%@ page import="java.util.List" %>
<%@ page import="model.MenuItem" %>
<%@ page import="model.Ingredient" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý công thức</title>
    <link rel="stylesheet" href="../css/admin.css">
    <style>
        body {
    margin: 0;
    font-family: "Segoe UI", Arial, sans-serif;
    background-color: #f4f6f8;
    display: flex; /* để sidebar + content nằm cạnh nhau */
    height: 100vh;
    overflow: hidden;
}

/* sidebar cố định chiều rộng */
.sidebar {
    width: 220px;
    background-color: #1f3349;
    color: #fff;
    display: flex;
    flex-direction: column;
    padding: 20px;
}

/* ✅ phần nội dung chính bên phải */
.main-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow-y: auto;
    background-color: #f9fbfd;
    padding: 25px 40px;
}

        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        .btn { padding: 6px 10px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-view { background-color: #4CAF50; color: white; }
        .btn-add { background-color: #2196F3; color: white; }
        .btn-edit { background-color: #FFA500; color: white; }
        .btn-delete { background-color: #E74C3C; color: white; }
        .btn-cancel { background-color: #888; color: white; }
        .modal { display: none; position: fixed; z-index: 10; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); }
        .modal-content {
            background: white;
            margin: 5% auto;
            padding: 20px;
            width: 75%;
            border-radius: 10px;
            max-height: 85vh;
            overflow-y: auto;
        }
        .close { float: right; font-size: 24px; cursor: pointer; }
        .search-box { margin-bottom: 10px; }
        .pagination { text-align: right; margin-top: 10px; }
        .pagination button { margin-left: 5px; padding: 4px 8px; }
        tr:hover { background-color: #eef; cursor: pointer; }
        input[type="number"] { width: 90px; }
        select { min-width: 160px; }
        /* ================= Search bar đẹp hơn ================= */
.search-bar {
    position: relative;
    max-width: 300px;
    margin: 0 auto 20px auto;
}

.search-bar input {
    width: 100%;
    padding: 10px 14px 10px 40px;
    font-size: 15px;
    border: 1px solid #d0d7de;
    border-radius: 25px;
    background-color: #fff;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
    transition: all 0.2s ease;
}

.search-bar input:focus {
    outline: none;
    border-color: #4a90e2;
    box-shadow: 0 0 5px rgba(74, 144, 226, 0.4);
}

/* icon tìm kiếm */
.search-bar::before {
    content: "🔍";
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: #888;
    font-size: 16px;
}
    </style>
</head>
<body>
    <div class="sidebar"> 
        <jsp:include page="admin-panel.jsp"/>
    </div>

    <div class="main-content">
        <h2>Quản lý công thức món ăn</h2>
<div class="search-bar">
    <input type="text" id="menuSearch" placeholder="Tìm món ăn..." onkeyup="filterMenu()">
</div>
<table id="menuTable">
    <thead>
        <tr>
            <th>ID</th>
            <th>Tên món</th>
            <th>Giá</th>
            <th>Có công thức</th>
            <th>Hành động</th>
        </tr>
    </thead>
    <tbody id="menuBody">
    <%
        List<MenuItem> menuItems = (List<MenuItem>) request.getAttribute("menuItems");
        List<Integer> itemsWithRecipe = (List<Integer>) request.getAttribute("itemsWithRecipe");
        List<Ingredient> allIngredients = (List<Ingredient>) request.getAttribute("ingredients");

        if (menuItems != null) {
            for (MenuItem m : menuItems) {
                boolean hasRecipe = itemsWithRecipe != null && itemsWithRecipe.contains(m.getItemID());
    %>
        <tr>
            <td><%= m.getItemID() %></td>
            <td><%= m.getName() %></td>
            <td><%= m.getPrice() %></td>
            <td style="text-align:center;"><%= hasRecipe ? "✔️" : "❌" %></td>
            <td>
                <button class="btn <%= hasRecipe ? "btn-view" : "btn-add" %>"
                        onclick="openRecipe(<%= m.getItemID() %>)">
                    <%= hasRecipe ? "Xem" : "Thêm" %>
                </button>
            </td>
        </tr>
    <%
            }
        }
    %>
    </tbody>
</table>
<!-- 📄 Phân trang -->
<div class="pagination" id="menuPagination"></div>
<!-- Modal xem công thức -->
<div id="viewRecipeModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeRecipe()">&times;</span>
        <h2>Chi tiết công thức</h2>
        <div id="recipeDetailContent">Đang tải...</div>
    </div>
</div>

<!-- Modal thêm công thức -->
<div id="addRecipeModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeAddRecipe()">&times;</span>
        <h2>Thêm công thức cho món ăn</h2>

        <form id="addRecipeForm" method="post" action="<%= request.getContextPath() %>/admin/recipe?action=addRecipe">
            <input type="hidden" id="menuItemId" name="menuItemId">

            <div class="form-group">
                <label for="description">Mô tả công thức:</label><br>
                <textarea id="description" name="description" rows="3" required></textarea>
            </div>

            <div class="form-group">
                <label>Chọn nguyên liệu:</label>
                <div class="search-box">
                    <input type="text" id="ingredientSearch" placeholder="Tìm nguyên liệu..." onkeyup="filterAddIngredients()">
                </div>
                <table id="ingredientTable">
                    <thead>
                        <tr>
                            <th>Chọn</th>
                            <th>Tên nguyên liệu</th>
                            <th>Đơn vị</th>
                            <th>Số lượng</th>
                        </tr>
                    </thead>
                    <tbody id="ingredientBody">
                        <% if (allIngredients != null) {
                            for (Ingredient ing : allIngredients) { %>
                                <tr>
                                    <td><input type="checkbox" name="ingredientId" value="<%= ing.getId() %>"></td>
                                    <td><%= ing.getName() %></td>
                                    <td><%= ing.getUnit() %></td>
                                    <td><input type="number" name="quantity" min="0.1" step="0.1" placeholder="Nhập SL"></td>
                                </tr>
                        <%  } } %>
                    </tbody>
                </table>
                <div class="pagination" id="ingredientPagination"></div>
            </div>

            <div style="margin-top:15px;">
                <button type="submit" class="btn btn-add">Lưu công thức</button>
                <button type="button" class="btn btn-cancel" onclick="closeAddRecipe()">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal sửa công thức -->
<div id="editRecipeModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeEditRecipe()">&times;</span>
        <h2>Chỉnh sửa công thức</h2>

        <form id="editRecipeForm" method="post" action="<%= request.getContextPath() %>/admin/recipe?action=updateRecipe">
    <input type="hidden" id="editRecipeId" name="recipeId">
    <div class="form-group">
        <label for="editDescription">Mô tả công thức:</label><br>
        <textarea id="editDescription" name="description" rows="3" required></textarea>
    </div>

    <h3>Nguyên liệu trong công thức</h3>
    <table style="width:100%;border-collapse:collapse;margin-top:10px;">
        <thead>
            <tr style="background:#f4f4f4;">
                <th>Tên nguyên liệu</th>
                <th>Đơn vị</th>
                <th>Số lượng</th>
                <th>Xóa</th>
            </tr>
        </thead>
        <!-- tbody chứa các hàng (cũ + mới), tên input được đặt đúng như controller mong -->
        <tbody id="editIngredientBody"></tbody>
    </table>

    <h3 style="margin-top:20px;">Nguyên liệu chưa có trong công thức</h3>
    <div class="search-box">
        <input type="text" id="searchMissing" placeholder="Tìm nguyên liệu..." onkeyup="filterMissingIngredients()">
    </div>
    <table id="missingIngredientTable" style="width:100%;margin-top:10px;">
        <thead>
            <tr style="background:#f4f4f4;">
                <th>Thêm</th>
                <th>Tên nguyên liệu</th>
                <th>Đơn vị</th>
                <th>Số lượng</th>
            </tr>
        </thead>
        <tbody id="missingIngredientBody"></tbody>
    </table>
    <div class="pagination" id="missingPagination"></div>

    <div style="margin-top:15px;text-align:right;">
        <button type="submit" class="btn btn-view">Lưu thay đổi</button>
        <button type="button" class="btn btn-cancel" onclick="closeEditRecipe()">Hủy</button>
    </div>
</form>

    </div>
</div>

    </div>

<script>
    const rowsPerPageMenu = 10;
let currentPageMenu = 1;

window.addEventListener("DOMContentLoaded", () => {
    paginateMenu();
});

function filterMenu() {
    currentPageMenu = 1;
    paginateMenu();
}

function paginateMenu() {
    const rows = Array.from(document.querySelectorAll("#menuBody tr"));
    const keyword = document.getElementById("menuSearch").value.trim().toLowerCase();

    // Lọc theo từ khóa
    const filtered = rows.filter(r => {
        const name = r.children[1].textContent.toLowerCase();
        return name.includes(keyword);
    });

    // Ẩn/hiện theo trang
    const totalPages = Math.max(1, Math.ceil(filtered.length / rowsPerPageMenu));
    filtered.forEach((r, idx) => {
        r.style.display = (idx >= (currentPageMenu - 1) * rowsPerPageMenu && idx < currentPageMenu * rowsPerPageMenu)
            ? "" : "none";
    });

    // Ẩn các hàng không thuộc filtered
    rows.forEach(r => { if (!filtered.includes(r)) r.style.display = "none"; });

    // Render pagination
    const pag = document.getElementById("menuPagination");
    pag.innerHTML = "";
    for (let i = 1; i <= totalPages; i++) {
        const btn = document.createElement("button");
        btn.textContent = i;
        if (i === currentPageMenu) btn.disabled = true;
        btn.onclick = () => { currentPageMenu = i; paginateMenu(); };
        pag.appendChild(btn);
    }
}
/* ========== Config & state ========== */
const contextPath = '<%= request.getContextPath() %>';
const rowsPerPage = 10;

let currentAddPage = 1;      // phân trang cho bảng Add modal
let currentMissingPage = 1;  // phân trang cho missing table trong Edit modal
let allIngredientsJS = [];   // sẽ đổ dữ liệu từ server dưới
window._currentRecipeData = null;

/* ========== Nhúng dữ liệu nguyên liệu từ server sang JS ========== */
allIngredientsJS = [];
<% if (allIngredients != null) {
    for (Ingredient ing : allIngredients) { %>
        allIngredientsJS.push({
            id: <%= ing.getId() %>,
            name: "<%= ing.getName().replace("\"","\\\"") %>",
            unit: "<%= ing.getUnit().replace("\"","\\\"") %>"
        });
<% } } %>

/* ========== DOM ready ========== */
window.addEventListener('DOMContentLoaded', function() {
    // Khởi tạo phân trang cho add modal (bảng chọn nguyên liệu khi thêm recipe)
    paginateAddIngredients();
});

/* ======================================================
   VIEW: openRecipe (gọi ajax để lấy dữ liệu công thức)
   ====================================================== */
function openRecipe(itemId) {
    const modalView = document.getElementById("viewRecipeModal");
    const content = document.getElementById("recipeDetailContent");
    // ensure add modal closed
    const addModal = document.getElementById("addRecipeModal");
    if (addModal) addModal.style.display = "none";

    content.innerHTML = "🔄 Đang tải dữ liệu...";

    fetch(contextPath + '/admin/recipe?action=getRecipeAjax&itemId=' + encodeURIComponent(itemId))
        .then(res => res.json())
        .then(data => {
            if (!data || !data.exists) {
                // nếu chưa có công thức -> mở form thêm
                modalView.style.display = "none";
                openAddRecipe(itemId);
                return;
            }

            window._currentRecipeData = data;

            let html = '<p><strong>Mô tả:</strong> ' + escapeHtml(data.description || '(Không có mô tả)') + '</p>';
            html += '<table border="1" style="width:100%;text-align:center;border-collapse:collapse;">';
            html += '<thead><tr><th>Tên nguyên liệu</th><th>Đơn vị</th><th>Số lượng</th></tr></thead><tbody>';

            if (Array.isArray(data.details) && data.details.length > 0) {
                data.details.forEach(function(d){
                    const q = (d.quantity !== undefined && d.quantity !== null) ? d.quantity : '';
                    html += '<tr><td>' + escapeHtml(d.ingredientName) + '</td><td>' + escapeHtml(d.unit) + '</td><td>' + escapeHtml(q) + '</td></tr>';
                });
            } else {
                html += '<tr><td colspan="3">Không có nguyên liệu nào</td></tr>';
            }
            html += '</tbody></table>';
            html += '<div style="margin-top:15px;text-align:right;">' +
                    '<button class="btn btn-edit" onclick="openEditRecipe()">✏️ Sửa công thức</button>' +
                    '</div>';
            content.innerHTML = html;
            modalView.style.display = "block";
        })
        .catch(err => {
            console.error('openRecipe error:', err);
            content.innerHTML = "<p style='color:red;'>Không thể tải dữ liệu công thức.</p>";
            modalView.style.display = "block";
        });
}
function closeRecipe() {
    const modalView = document.getElementById("viewRecipeModal");
    if (modalView) modalView.style.display = "none";
}

/* ======================================================
   ADD modal (thêm recipe) - phân trang & tìm kiếm riêng
   ====================================================== */
function openAddRecipe(id) {
    const addModal = document.getElementById("addRecipeModal");
    if (!addModal) return;
    document.getElementById("menuItemId").value = id;
    addModal.style.display = "block";
    currentAddPage = 1;
    paginateAddIngredients();
}
function closeAddRecipe() {
    const addModal = document.getElementById("addRecipeModal");
    if (addModal) addModal.style.display = "none";
}

function paginateAddIngredients() {
    const rows = Array.from(document.querySelectorAll("#ingredientBody tr"));
    const total = Math.max(1, Math.ceil(rows.length / rowsPerPage));
    rows.forEach((r, idx) => {
        // apply search filter then pagination
        const name = (r.children[1] && r.children[1].textContent) ? r.children[1].textContent.toLowerCase() : '';
        const kw = document.getElementById("ingredientSearch").value.trim().toLowerCase();
        const matchesSearch = kw === '' ? true : name.includes(kw);
        const showByPage = (idx >= (currentAddPage-1)*rowsPerPage && idx < currentAddPage*rowsPerPage);
        r.style.display = (matchesSearch && showByPage) ? "" : "none";
    });
    const pag = document.getElementById("ingredientPagination");
    pag.innerHTML = "";
    for (let i = 1; i <= total; i++) {
        const btn = document.createElement("button");
        btn.textContent = i;
        if (i === currentAddPage) btn.disabled = true;
        btn.onclick = (function(p){ return function(){ currentAddPage = p; paginateAddIngredients(); }; })(i);
        pag.appendChild(btn);
    }
}
function filterAddIngredients() {
    currentAddPage = 1;
    paginateAddIngredients();
}

/* ======================================================
   EDIT modal: render existing and missing (mutually exclusive)
   ====================================================== */
function openEditRecipe() {
    const data = window._currentRecipeData;
    if (!data || !data.exists) {
        alert("Không có dữ liệu công thức để sửa.");
        return;
    }

    // set recipeId + description
    const editId = document.getElementById("editRecipeId");
    const editDesc = document.getElementById("editDescription");
    if (editId) editId.value = data.recipeId;
    if (editDesc) editDesc.value = data.description || "";

    // clear any existing deletedDetailId hidden inputs from previous opens
    const form = document.getElementById("editRecipeForm");
    Array.from(form.querySelectorAll("input[name='deletedDetailId']")).forEach(n => n.remove());

    // render existing recipe details
    const tbody = document.getElementById("editIngredientBody");
    tbody.innerHTML = "";

    const existingIds = new Set();

    if (Array.isArray(data.details)) {
        data.details.forEach(d => {
            // d should have detailId, ingredientId, ingredientName, unit, quantity
            const detailId = d.detailId || d.detailID || d.recipeDetailID || d.detailId; // defensive
            const ingredientId = d.ingredientId || d.ingredientID || d.ingredientId;
            existingIds.add(Number(ingredientId));

            const qty = (d.quantity !== undefined && d.quantity !== null) ? d.quantity : "";

            const tr = document.createElement("tr");
            tr.dataset.detailId = detailId; // mark row as existing row

            // IMPORTANT: names MUST match controller expected names
            tr.innerHTML =
  '<td>' + escapeHtml(d.ingredientName) +
    '<input type="hidden" name="detailId" value="' + escapeHtml(detailId) + '">' +
  '</td>' +
  '<td>' + escapeHtml(d.unit) + '</td>' +
  '<td><input type="number" name="updatedQuantity" min="0.1" step="0.1" value="' + escapeHtml(qty) + '"></td>' +
  '<td><button type="button" class="btn btn-delete" onclick="deleteExistingDetail(this, ' + detailId + ')">Xóa</button></td>';
            tbody.appendChild(tr);
        });
    }

    // render missing list excluding existingIds
    currentMissingPage = 1;
    renderMissingIngredients(allIngredientsJS.filter(x => !existingIds.has(Number(x.id))));

    // show modal
    const editModal = document.getElementById("editRecipeModal");
    if (editModal) editModal.style.display = "block";
}

// khi xóa 1 detail đã có: thêm hidden deletedDetailId[] vào form và remove row
function deleteExistingDetail(buttonElem, detailId) {
    // add hidden input deletedDetailId to form
    const form = document.getElementById("editRecipeForm");
    const h = document.createElement("input");
    h.type = "hidden";
    h.name = "deletedDetailId";
    h.value = String(detailId);
    form.appendChild(h);

    // remove row
    const row = buttonElem.closest("tr");
    if (row) row.remove();

    // refresh missing list so that ingredient becomes available to add again
    filterMissingIngredients();
}

/* renderMissingIngredients(list) - giống trước nhưng tạo nút "Thêm" cho mỗi hàng */
function renderMissingIngredients(list) {
    const body = document.getElementById("missingIngredientBody");
    body.innerHTML = "";

    const kw = (document.getElementById("searchMissing") ? document.getElementById("searchMissing").value.trim().toLowerCase() : '');
    const filtered = kw ? list.filter(x => x.name.toLowerCase().includes(kw)) : list;

    const totalPages = Math.max(1, Math.ceil(filtered.length / rowsPerPage));
    if (currentMissingPage > totalPages) currentMissingPage = totalPages;

    const start = (currentMissingPage - 1) * rowsPerPage;
    const slice = filtered.slice(start, start + rowsPerPage);

    slice.forEach(ing => {
        const tr = document.createElement("tr");
        tr.innerHTML =
            '<td><button type="button" class="btn btn-add" onclick="addNewDetailFromMissing(' + ing.id + ', \'' + escapeJs(ing.name) + '\', \'' + escapeJs(ing.unit) + '\')">Thêm</button></td>' +
            '<td>' + escapeHtml(ing.name) + '</td>' +
            '<td>' + escapeHtml(ing.unit) + '</td>' +
            '<td><input type="number" id="missing_qty_' + ing.id + '" min="0.1" step="0.1" value="1"></td>';
        body.appendChild(tr);
    });

    // pagination
    const pag = document.getElementById("missingPagination");
    pag.innerHTML = "";
    for (let i = 1; i <= totalPages; i++) {
        const b = document.createElement("button");
        b.textContent = i;
        if (i === currentMissingPage) b.disabled = true;
        b.onclick = (function(p){ return function(){ currentMissingPage = p; renderMissingIngredients(list); }; })(i);
        pag.appendChild(b);
    }
}

// filterMissing using both existing (updatedDetailId) and newly added (newIngredientId)
function filterMissingIngredients() {
    // gather ingredient ids already present in editIngredientBody (both existing and newly added)
    const existingInputs = document.querySelectorAll("#editIngredientBody input[name='ingredientIdExisting'], #editIngredientBody input[name='newIngredientId']");
    const existingIds = new Set(Array.from(existingInputs).map(i => Number(i.value)));

    const available = allIngredientsJS.filter(x => !existingIds.has(Number(x.id)));
    currentMissingPage = 1;
    renderMissingIngredients(available);
}

// Add new ingredient into edit table as new (names newIngredientId/newQuantity)
function addNewDetailFromMissing(id, name, unit) {
    // check duplicates: existing updatedDetailId/ingredientIdExisting and newIngredientId
    const existingInputs = document.querySelectorAll("#editIngredientBody input[name='ingredientIdExisting'], #editIngredientBody input[name='newIngredientId']");
    for (let i=0;i<existingInputs.length;i++){
        if (Number(existingInputs[i].value) === Number(id)) {
            alert("Nguyên liệu này đã có trong công thức.");
            filterMissingIngredients();
            return;
        }
    }

    const qtyElem = document.getElementById("missing_qty_" + id);
    const qty = qtyElem ? qtyElem.value : "1";

    const tbody = document.getElementById("editIngredientBody");
    const tr = document.createElement("tr");
    // mark as new: create hidden newIngredientId and input newQuantity
    tr.innerHTML =
        '<td>' + escapeHtml(name) + '<input type="hidden" name="newIngredientId" value="' + escapeHtml(id) + '"></td>' +
        '<td>' + escapeHtml(unit) + '</td>' +
        '<td><input type="number" name="newQuantity" min="0.1" step="0.1" value="' + escapeHtml(qty) + '"></td>' +
        '<td><button type="button" class="btn btn-delete" onclick="removeNewRow(this)">Xóa</button></td>';
    tbody.appendChild(tr);

    // refresh missing list
    filterMissingIngredients();
}

// remove a new row (not existing) - simply remove row
function removeNewRow(buttonElem) {
    const row = buttonElem.closest("tr");
    if (row) row.remove();
    filterMissingIngredients();
}

// remove generic row (legacy uses) - kept for safety but prefer removeNewRow/deleteExistingDetail
function removeIngredientFromRecipeRow(buttonElem, ingredientId) {
    const row = buttonElem.closest("tr");
    if (!row) return;
    // if this row has updatedDetailId (existing), mark deleted
    const existingDetailInput = row.querySelector("input[name='updatedDetailId']");
    if (existingDetailInput) {
        const detailId = existingDetailInput.value;
        // append deletedDetailId hidden input
        const form = document.getElementById("editRecipeForm");
        const h = document.createElement("input");
        h.type = "hidden";
        h.name = "deletedDetailId";
        h.value = detailId;
        form.appendChild(h);
    }
    row.remove();
    filterMissingIngredients();
}

/* Helpers */
function escapeHtml(s) {
    if (s === null || s === undefined) return '';
    return String(s)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}
function escapeJs(s) {
    if (s === null || s === undefined) return '';
    return String(s).replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/"/g, '\\"');
}
</script>

</body>
</html>
