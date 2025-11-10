<%@ page import="java.util.List" %>
<%@ page import="model.MenuItem" %>
<%@ page import="model.ItemSizePrice" %>
<%@ page import="model.Ingredient" %>
<%@ page import="model.RecipeDetail" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản lý công thức món ăn</title>
<link rel="stylesheet" href="../css/admin.css">
<style>
body { margin:0; font-family:"Segoe UI", Arial, sans-serif; background:#f4f6f8; display:flex; height:100vh; overflow:hidden;}
.sidebar { width:220px; background:#1f3349; color:#fff; display:flex; flex-direction:column; padding:20px;}
.main-content { flex:1; display:flex; flex-direction:column; overflow-y:auto; background:#f9fbfd; padding:25px 40px;}
table { width:100%; border-collapse: collapse; margin-top:10px;}
th, td { border:1px solid #ccc; padding:10px; text-align:left;}
th { background:#f4f4f4;}
button { padding:6px 10px; border:none; border-radius:4px; cursor:pointer; margin:2px;}
.btn-view { background:#4CAF50; color:#fff;}
.btn-add { background:#2196F3; color:#fff;}
.btn-edit { background:#FFA500; color:#fff;}
.btn-delete { background:#E74C3C; color:#fff;}
.btn-cancel { background:#888; color:#fff;}
.modal { display:none; position:fixed; z-index:10; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,0.4);}
.modal-content { background:#fff; margin:5% auto; padding:20px; width:75%; border-radius:10px; max-height:85vh; overflow-y:auto;}
.close { float:right; font-size:24px; cursor:pointer;}
.search-bar { position:relative; max-width:300px; margin:0 auto 20px auto;}
.search-bar input { width:100%; padding:10px 14px 10px 40px; font-size:15px; border:1px solid #d0d7de; border-radius:25px; background:#fff;}
.search-bar input:focus { outline:none; border-color:#4a90e2; box-shadow:0 0 5px rgba(74,144,226,0.4);}
.search-bar::before { content:"🔍"; position:absolute; left:14px; top:50%; transform:translateY(-50%); color:#888; font-size:16px;}
tr:hover { background:#eef; cursor:pointer;}
input[type="number"] { width:90px; }
select { min-width:160px; }
.pagination { text-align:right; margin-top:10px;}
.pagination button { margin-left:5px; padding:4px 8px;}
.header-bar { display:flex; justify-content:space-between; align-items:center; margin-bottom:25px;}
</style>
</head>
<body>
<div class="sidebar">
    <jsp:include page="admin-panel.jsp"/>
</div>
<jsp:include page="user-info.jsp" />
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
                <th>Size</th>
                <th>Giá</th>
                <th>Có công thức</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody id="menuBody">
        <%
            List<ItemSizePrice> menuItems = (List<ItemSizePrice>) request.getAttribute("menuItems");
            List<Integer> itemsWithRecipe = (List<Integer>) request.getAttribute("itemsWithRecipe");
            List<Ingredient> allIngredients = (List<Ingredient>) request.getAttribute("ingredients");

            if (menuItems != null) {
                for (ItemSizePrice isp : menuItems) {
                    boolean hasRecipe = itemsWithRecipe != null && itemsWithRecipe.contains(isp.getId());
        %>
            <tr>
                <td><%= isp.getId() %></td>
                <td><%= isp.getMenuItem() != null ? isp.getMenuItem().getName() : "Unknown" %></td>
                <td><%= isp.getSize() %></td>
                <td><%= isp.getPrice() %></td>
                <td style="text-align:center;"><%= hasRecipe ? "✔️" : "❌" %></td>
                <td>
                    <button class="btn <%= hasRecipe ? "btn-view" : "btn-add" %>" onclick="openRecipe(<%= isp.getId() %>)">
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
    <div class="pagination" id="menuPagination"></div>

    <!-- Modal Xem công thức -->
    <div id="viewRecipeModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeRecipe()">&times;</span>
            <h2>Chi tiết công thức</h2>
            <div id="recipeDetailContent">Đang tải...</div>
        </div>
    </div>

    <!-- Modal Thêm công thức -->
    <div id="addRecipeModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeAddRecipe()">&times;</span>
            <h2>Thêm công thức</h2>
            <form id="addRecipeForm" method="post" action="<%= request.getContextPath() %>/admin/recipe?action=addRecipe">
                <input type="hidden" id="menuItemId" name="itemSizePriceId">
                <div>
                    <label>Mô tả:</label><br>
                    <textarea name="description" rows="3" required></textarea>
                </div>
                <div>
                    <label>Chọn nguyên liệu:</label>
                    <div class="search-bar">
                        <input type="text" id="ingredientSearch" placeholder="Tìm nguyên liệu..." onkeyup="filterAddIngredients()">
                    </div>
                    <table>
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
                                        <td><input type="number" name="quantity" min="0.1" step="0.1" value="1"></td>
                                    </tr>
                            <% }} %>
                        </tbody>
                    </table>
                    <div class="pagination" id="ingredientPagination"></div>
                </div>
                <div style="margin-top:15px;">
                    <button type="submit" class="btn btn-add">Lưu</button>
                    <button type="button" class="btn btn-cancel" onclick="closeAddRecipe()">Hủy</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Sửa công thức -->
    <div id="editRecipeModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditRecipe()">&times;</span>
            <h2>Sửa công thức</h2>
            <form id="editRecipeForm" method="post" action="<%= request.getContextPath() %>/admin/recipe?action=updateRecipe">
                <input type="hidden" id="editRecipeId" name="recipeId">
                <div>
                    <label>Mô tả:</label><br>
                    <textarea id="editDescription" name="description" rows="3" required></textarea>
                </div>
                <h3>Nguyên liệu hiện có</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Tên</th>
                            <th>Đơn vị</th>
                            <th>Số lượng</th>
                            <th>Xóa</th>
                        </tr>
                    </thead>
                    <tbody id="editIngredientBody"></tbody>
                </table>

                <h3>Nguyên liệu chưa có</h3>
                <div class="search-bar">
                    <input type="text" id="searchMissing" placeholder="Tìm nguyên liệu..." onkeyup="filterMissingIngredients()">
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Thêm</th>
                            <th>Tên</th>
                            <th>Đơn vị</th>
                            <th>Số lượng</th>
                        </tr>
                    </thead>
                    <tbody id="missingIngredientBody"></tbody>
                </table>
                <div class="pagination" id="missingPagination"></div>
                <div style="margin-top:15px; text-align:right;">
                    <button type="submit" class="btn btn-view">Lưu thay đổi</button>
                    <button type="button" class="btn btn-cancel" onclick="closeEditRecipe()">Hủy</button>
                </div>
            </form>
        </div>
    </div>

</div>

<script>
// =================== JS xử lý menu + modal + phân trang ===================
const contextPath = '<%= request.getContextPath() %>';
let currentPageMenu = 1, rowsPerPageMenu = 10;
let currentAddPage = 1, currentMissingPage = 1;
let allIngredientsJS = [];

<% if (allIngredients != null) {
    for (Ingredient ing : allIngredients) { %>
        allIngredientsJS.push({id:<%= ing.getId() %>, name:"<%= ing.getName().replace("\"","\\\"") %>", unit:"<%= ing.getUnit().replace("\"","\\\"") %>"});
<% } } %>

function paginateMenu() {
    const rows = Array.from(document.querySelectorAll("#menuBody tr"));
    const kw = document.getElementById("menuSearch").value.toLowerCase().trim();
    const filtered = rows.filter(r => r.children[1].textContent.toLowerCase().includes(kw));
    const totalPages = Math.max(1, Math.ceil(filtered.length/rowsPerPageMenu));
    filtered.forEach((r,i)=>r.style.display=(i>=(currentPageMenu-1)*rowsPerPageMenu && i<currentPageMenu*rowsPerPageMenu?"":"none"));
    rows.forEach(r=>{ if(!filtered.includes(r)) r.style.display="none";});
    const pag = document.getElementById("menuPagination");
    pag.innerHTML="";
    for(let i=1;i<=totalPages;i++){const btn=document.createElement("button"); btn.textContent=i; if(i===currentPageMenu) btn.disabled=true; btn.onclick=()=>{currentPageMenu=i; paginateMenu();}; pag.appendChild(btn);}
}
function filterMenu(){currentPageMenu=1; paginateMenu();}
window.addEventListener("DOMContentLoaded",()=>{paginateMenu(); setupModalCloseEvents(); paginateAddIngredients();});

function setupModalCloseEvents(){document.querySelectorAll(".modal").forEach(modal=>{modal.addEventListener("click",e=>{if(e.target===modal) modal.style.display="none";});});}
function openRecipe(itemId){ const modalView=document.getElementById("viewRecipeModal"); const content=document.getElementById("recipeDetailContent"); const addModal=document.getElementById("addRecipeModal"); if(addModal) addModal.style.display="none"; content.innerHTML="Đang tải..."; fetch(contextPath+"/admin/recipe?action=getRecipeAjax&itemSizePriceId="+itemId).then(r=>r.json()).then(data=>{ if(!data.exists){ modalView.style.display="none"; openAddRecipe(itemId); return;} window._currentRecipeData=data; let html='<p><b>Mô tả:</b> '+(data.description||"(Không có mô tả)")+'</p>'; html+='<table border="1" style="width:100%;border-collapse:collapse;text-align:center;"><thead><tr><th>Tên</th><th>Đơn vị</th><th>Số lượng</th></tr></thead><tbody>'; if(Array.isArray(data.details)){data.details.forEach(d=>{html+='<tr><td>'+d.ingredientName+'</td><td>'+d.unit+'</td><td>'+d.quantity+'</td></tr>';});} else { html+='<tr><td colspan="3">Không có nguyên liệu</td></tr>'; } html+='</tbody></table><div style="margin-top:10px;text-align:right;"><button class="btn btn-edit" onclick="openEditRecipe()">✏️ Sửa công thức</button></div>'; content.innerHTML=html; modalView.style.display="block";}).catch(err=>{console.error(err); content.innerHTML="<p style='color:red;'>Không thể tải dữ liệu</p>"; modalView.style.display="block";});}
function closeRecipe(){ const modalView=document.getElementById("viewRecipeModal"); if(modalView) modalView.style.display="none";}
function openAddRecipe(id){ const addModal=document.getElementById("addRecipeModal"); if(!addModal) return; document.getElementById("menuItemId").value=id; addModal.style.display="block"; currentAddPage=1; paginateAddIngredients();}
function closeAddRecipe(){ const addModal=document.getElementById("addRecipeModal"); if(addModal) addModal.style.display="none";}

function paginateAddIngredients(){ const rows=Array.from(document.querySelectorAll("#ingredientBody tr")); const kw=document.getElementById("ingredientSearch").value.trim().toLowerCase(); const total=Math.max(1,Math.ceil(rows.length/10)); rows.forEach((r,i)=>{ const name=r.children[1].textContent.toLowerCase(); const show=kw===""?true:name.includes(kw); const byPage=(i>=(currentAddPage-1)*10 && i<currentAddPage*10); r.style.display=(show && byPage?"":"none"); }); const pag=document.getElementById("ingredientPagination"); pag.innerHTML=""; for(let i=1;i<=total;i++){const btn=document.createElement("button"); btn.textContent=i; if(i===currentAddPage) btn.disabled=true; btn.onclick=(function(p){return function(){currentAddPage=p; paginateAddIngredients();};})(i); pag.appendChild(btn); } }
function filterAddIngredients(){ currentAddPage=1; paginateAddIngredients();}

function openEditRecipe(){ const data=window._currentRecipeData; if(!data || !data.exists){ alert("Không có dữ liệu"); return;} document.getElementById("editRecipeId").value=data.recipeId; document.getElementById("editDescription").value=data.description||""; const tbody=document.getElementById("editIngredientBody"); tbody.innerHTML=""; const existingIds=new Set(); if(Array.isArray(data.details)){data.details.forEach(d=>{ existingIds.add(d.ingredientId); const tr=document.createElement("tr"); tr.innerHTML='<td>'+d.ingredientName+'<input type="hidden" name="detailId" value="'+d.detailId+'"></td><td>'+d.unit+'</td><td><input type="number" name="updatedQuantity" min="0.1" step="0.1" value="'+d.quantity+'"></td><td><button type="button" class="btn btn-delete" onclick="deleteExistingDetail(this,'+d.detailId+')">Xóa</button></td>'; tbody.appendChild(tr); }); } currentMissingPage=1; renderMissingIngredients(allIngredientsJS.filter(x=>!existingIds.has(Number(x.id)))); document.getElementById("editRecipeModal").style.display="block"; }

function deleteExistingDetail(btn, detailId){ const form=document.getElementById("editRecipeForm"); const h=document.createElement("input"); h.type="hidden"; h.name="deletedDetailId"; h.value=detailId; form.appendChild(h); const row=btn.closest("tr"); if(row) row.remove(); filterMissingIngredients(); }

function renderMissingIngredients(list){ const body=document.getElementById("missingIngredientBody"); body.innerHTML=""; const kw=document.getElementById("searchMissing").value.trim().toLowerCase(); const filtered=kw?list.filter(x=>x.name.toLowerCase().includes(kw)):list; const totalPages=Math.max(1, Math.ceil(filtered.length/10)); if(currentMissingPage>totalPages) currentMissingPage=totalPages; const start=(currentMissingPage-1)*10; const slice=filtered.slice(start,start+10); slice.forEach(ing=>{ const tr=document.createElement("tr"); tr.innerHTML='<td><button type="button" class="btn btn-add" onclick="addNewDetailFromMissing('+ing.id+',\''+ing.name+'\',\''+ing.unit+'\')">Thêm</button></td><td>'+ing.name+'</td><td>'+ing.unit+'</td><td><input type="number" id="missing_qty_'+ing.id+'" min="0.1" step="0.1" value="1"></td>'; body.appendChild(tr); }); const pag=document.getElementById("missingPagination"); pag.innerHTML=""; for(let i=1;i<=totalPages;i++){ const btn=document.createElement("button"); btn.textContent=i; if(i===currentMissingPage) btn.disabled=true; btn.onclick=(function(p){ return function(){currentMissingPage=p; renderMissingIngredients(list); }; })(i); pag.appendChild(btn); } }

function filterMissingIngredients(){ currentMissingPage=1; renderMissingIngredients(allIngredientsJS.filter(x=>!Array.from(document.querySelectorAll("#editIngredientBody input[name='detailId']")).map(i=>Number(i.value)).includes(Number(x.id)))); }

function addNewDetailFromMissing(id,name,unit){ const tbody=document.getElementById("editIngredientBody"); const qty=document.getElementById("missing_qty_"+id).value; const tr=document.createElement("tr"); tr.innerHTML='<td>'+name+'<input type="hidden" name="newIngredientId" value="'+id+'"></td><td>'+unit+'</td><td><input type="number" name="newQuantity" min="0.1" step="0.1" value="'+qty+'"></td><td><button type="button" class="btn btn-delete" onclick="deleteExistingDetail(this,0)">Xóa</button></td>'; tbody.appendChild(tr); renderMissingIngredients(allIngredientsJS.filter(x=>!Array.from(document.querySelectorAll("#editIngredientBody input[name=\'detailId\'], #editIngredientBody input[name=\'newIngredientId\']")).map(i=>Number(i.value)).includes(Number(x.id)))); }

function closeEditRecipe(){ document.getElementById("editRecipeModal").style.display="none"; }
</script>
</body>
</html>
