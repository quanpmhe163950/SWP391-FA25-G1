<%@ page import="java.util.*, model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý công thức món ăn</title>
    <style>
        body { font-family: Arial; background: #fafafa; margin: 20px; }
        h1 { text-align: center; }
        table { width: 95%; border-collapse: collapse; margin: 20px auto; background: #fff; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f2f2f2; }
        .btn { background: #1976d2; color: #fff; border: none; padding: 6px 10px; cursor: pointer; border-radius: 3px; }
        .btn:hover { background: #1259a3; }
        .modal { display: none; position: fixed; z-index: 99; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); }
        .modal-content { background: #fff; width: 600px; margin: 6% auto; padding: 20px; border-radius: 8px; position: relative; }
        .close { position: absolute; right: 10px; top: 5px; cursor: pointer; font-size: 18px; }
        .inline { display: flex; gap: 10px; align-items: center; }
    </style>
</head>
<body>

<h1>Quản lý công thức món ăn</h1>

<div style="text-align:center;">
    <form action="recipe" method="get" class="inline">
        <input type="hidden" name="action" value="search">
        <input type="text" name="keyword" placeholder="Tìm theo tên món..." value="${keyword}" />
        <button type="submit" class="btn">Tìm kiếm</button>
    </form>
</div>

<table>
    <tr>
        <th>ID</th>
        <th>Tên món</th>
        <th>Mô tả</th>
        <th>Tình trạng công thức</th>
        <th>Thao tác</th>
    </tr>
    <%
        List<MenuItem> menuItems = (List<MenuItem>) request.getAttribute("menuItems");
        List<Integer> itemsWithRecipe = (List<Integer>) request.getAttribute("itemsWithRecipe");
        List<Ingredient> allIngredients = (List<Ingredient>) request.getAttribute("ingredients");
        if (menuItems != null) {
            for (MenuItem m : menuItems) {
                boolean hasRecipe = itemsWithRecipe != null && itemsWithRecipe.contains(m.getItemId());
    %>
    <tr>
        <td><%= m.getItemId() %></td>
        <td><%= m.getItemName() %></td>
        <td><%= m.getDescription() == null ? "" : m.getDescription() %></td>
        <td style="color:<%= hasRecipe ? "green" : "red" %>;">
            <%= hasRecipe ? "Đã có" : "Chưa có" %>
        </td>
        <td>
            <% if (hasRecipe) { %>
                <button class="btn" onclick="openRecipe(<%= m.getItemId() %>)">Xem công thức</button>
            <% } else { %>
                <button class="btn" onclick="openAddRecipe(<%= m.getItemId() %>)">Thêm công thức</button>
            <% } %>
        </td>
    </tr>
    <% }} %>
</table>

<!-- Modal chi tiết công thức -->
<div id="recipeModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal('recipeModal')">&times;</span>
        <h3>Chi tiết công thức</h3>
        <div id="recipeDetail"></div>
    </div>
</div>

<!-- Modal thêm công thức -->
<div id="addRecipeModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal('addRecipeModal')">&times;</span>
        <h3>Thêm công thức mới</h3>
        <form id="addRecipeForm">
            <input type="hidden" name="action" value="addRecipe">
            <input type="hidden" name="itemId" id="itemIdField">
            <label>Mô tả công thức:</label>
            <textarea name="description" required></textarea>
            <button type="submit" class="btn" style="margin-top:10px;">Lưu</button>
        </form>
    </div>
</div>

<script>
function openAddRecipe(itemId) {
    document.getElementById("addRecipeModal").style.display = "block";
    document.getElementById("itemIdField").value = itemId;
}
function openRecipe(itemId) {
    fetch(`recipe?action=getRecipeAjax&itemId=${itemId}`)
        .then(res => res.json())
        .then(data => {
            let html = `<p><b>Mô tả:</b> ${data.description}</p>`;
            html += `<table border='1' width='100%'><tr><th>Nguyên liệu</th><th>Số lượng</th></tr>`;
            data.details.forEach(d => {
                html += `<tr><td>${d.ingredient.ingredientName}</td><td>${d.quantity}</td></tr>`;
            });
            html += `</table>`;
            document.getElementById("recipeDetail").innerHTML = html;
            document.getElementById("recipeModal").style.display = "block";
        });
}
function closeModal(id) { document.getElementById(id).style.display = "none"; }
window.onclick = e => ['recipeModal','addRecipeModal'].forEach(id=>{
    if(e.target==document.getElementById(id)) closeModal(id);
});
document.getElementById("addRecipeForm").onsubmit = function(e){
    e.preventDefault();
    fetch("recipe", { method:"POST", body:new FormData(this) })
        .then(r=>{ if(r.ok){ alert("Đã thêm công thức!"); location.reload(); } });
};
</script>

</body>
</html>
