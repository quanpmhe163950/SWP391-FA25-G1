<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }
                /* ===== Header giống home ===== */
        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

    </style>
    <title>Quản lý nguyên liệu theo nhà cung cấp</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body class="bg-light">
    <!-- ✅ Thêm sidebar -->
    <jsp:include page="admin-panel.jsp" />
    <jsp:include page="user-info.jsp" />
<div class="container mt-4">
    <h3 class="mb-3 text-center text-primary fw-bold">QUẢN LÝ NGUYÊN LIỆU THEO NHÀ CUNG CẤP</h3>

    <!-- ======================= DANH SÁCH NHÀ CUNG CẤP ======================= -->
    <div class="card mb-4 shadow-sm">
        <div class="card-header d-flex justify-content-between align-items-center">
            <span class="fw-semibold">Danh sách nhà cung cấp</span>
            <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#addSupplierModal">+ Thêm nhà cung cấp</button>
        </div>
        <div class="card-body p-0">
            <table class="table table-hover table-bordered align-middle mb-0">
                <thead class="table-secondary text-center">
                <tr>
                    <th>ID</th>
                    <th>Tên</th>
                    <th>SĐT</th>
                    <th>Email</th>
                    <th>Địa chỉ</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="s" items="${suppliers}">
                    <tr>
                        <td>${s.supplierID}</td>
                        <td>${s.supplierName}</td>
                        <td>${s.phone}</td>
                        <td>${s.email}</td>
                        <td>${s.address}</td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${s.active}">
                                    <span class="badge bg-success">Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Ngừng</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <button class="btn btn-primary btn-sm"
                                    onclick="openIngredientModal(${s.supplierID}, '${s.supplierName}')">
                                Nguyên liệu
                            </button>
                            <button class="btn btn-warning btn-sm"
                                    onclick="openEditSupplierModal(${s.supplierID}, '${s.supplierName}', '${s.phone}', '${s.email}', '${s.address}', ${s.active})">
                                Sửa
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- ======================= MODAL THÊM NHÀ CUNG CẤP ======================= -->
<div class="modal fade" id="addSupplierModal" tabindex="-1">
    <div class="modal-dialog">
        <form method="post" action="${pageContext.request.contextPath}/admin/supplier-ingredient" class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">Thêm nhà cung cấp</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="action" value="addSupplier">
                <div class="mb-3">
                    <label class="form-label">Tên nhà cung cấp</label>
                    <input name="supplierName" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Số điện thoại</label>
                    <input name="phone" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input name="email" type="email" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Địa chỉ</label>
                    <input name="address" class="form-control">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-success" type="submit">Thêm</button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- ======================= MODAL SỬA NHÀ CUNG CẤP ======================= -->
<div class="modal fade" id="editSupplierModal" tabindex="-1">
    <div class="modal-dialog">
        <form method="post" action="${pageContext.request.contextPath}/admin/supplier-ingredient" class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title">Sửa thông tin nhà cung cấp</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="action" value="updateSupplier">
                <input type="hidden" id="editSupplierID" name="supplierID">
                <div class="mb-3">
                    <label class="form-label">Tên nhà cung cấp</label>
                    <input id="editSupplierName" name="supplierName" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Số điện thoại</label>
                    <input id="editPhone" name="phone" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input id="editEmail" name="email" type="email" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Địa chỉ</label>
                    <input id="editAddress" name="address" class="form-control">
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="editActive" name="active">
                    <label class="form-check-label" for="editActive">Hoạt động</label>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-warning" type="submit">Lưu</button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- ======================= MODAL NGUYÊN LIỆU ======================= -->
<div class="modal fade" id="ingredientModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title" id="supplierIngredientTitle">Nguyên liệu của nhà cung cấp</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div id="ingredientTables">
          <div class="text-center p-3">
            <div class="spinner-border text-primary"></div>
            <p class="mt-2">Đang tải dữ liệu...</p>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" id="confirmSaveBtn" class="btn btn-success">Xác nhận</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
      </div>
    </div>
  </div>
</div>

<!-- ======================= SCRIPT ======================= -->
<script>
const ctx = '${pageContext.request.contextPath}';
let currentSupplierID = null;

console.log("CTX =", ctx);

// ======================= MỞ MODAL NGUYÊN LIỆU =======================
function openIngredientModal(supplierID, supplierName) {
    currentSupplierID = supplierID;

    // Cập nhật tiêu đề modal
    $('#supplierIngredientTitle').text('Nguyên liệu của ' + supplierName);
    $('#ingredientModal').modal('show');

    // Hiển thị loading
    $('#ingredientTables').html(`
        <div class="text-center p-3">
            <div class="spinner-border text-primary"></div>
            <p class="mt-2">Đang tải dữ liệu...</p>
        </div>
    `);

    // 🔹 Gửi AJAX đến servlet
    $.ajax({
        url: ctx + '/admin/supplier-ingredient',  // Đảm bảo mapping đúng Servlet
        type: 'GET',
        data: {
            action: 'getIngredients',
            supplierID: supplierID
        },
        success: function (response) {
            console.log("AJAX success:", response);

            // Nếu servlet trả HTML fragment -> render trực tiếp
            if (typeof response === 'string' && response.trim().startsWith('<')) {
                $('#ingredientTables').html(response);
                return;
            }

            // Nếu servlet trả JSON -> render bằng JS
            try {
                const data = typeof response === 'string' ? JSON.parse(response) : response;

                if (Array.isArray(data) && data.length > 0) {
                    let html = `
        <table class="table table-bordered table-striped align-middle">
            <thead class="table-secondary text-center">
                <tr>
                    <th>#</th>
                    <th>Tên nguyên liệu</th>
                    <th>Đơn vị</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
    `;
    data.forEach((item, index) => {
        html += `
            <tr data-ingredient-id="${item.id}" data-name="${item.name}" data-unit="${item.unit}">
                <td>${index + 1}</td>
                <td>${item.name}</td>
                <td>${item.unit || '-'}</td>
                <td class="text-center">
                    <button class="btn btn-outline-danger btn-sm remove-ingredient-btn">Xóa</button>
                </td>
            </tr>
        `;
    });

    html += '</tbody></table>';
    $('#ingredientTables').html(html);
} 
 else {
                    $('#ingredientTables').html(`<div class="text-center p-3 text-muted">Không có nguyên liệu nào.</div>`);
                }
            } catch (e) {
                console.error("Không parse được JSON:", e);
                $('#ingredientTables').html(`<div class="text-danger p-3">Lỗi dữ liệu trả về.</div>`);
            }
        },
        error: function (xhr) {
            console.error("AJAX error:", xhr.status, xhr.statusText);
            console.log("URL lỗi:", ctx + '/admin/supplier-ingredient?action=getIngredients&supplierID=' + supplierID);
            $('#ingredientTables').html(`<div class="text-danger p-3">Lỗi khi tải dữ liệu.</div>`);
        }
    });
}

// ======================= MỞ MODAL SỬA NHÀ CUNG CẤP =======================
function openEditSupplierModal(id, name, phone, email, address, active) {
    $('#editSupplierID').val(id);
    $('#editSupplierName').val(name);
    $('#editPhone').val(phone);
    $('#editEmail').val(email);
    $('#editAddress').val(address);
    $('#editActive').prop('checked', active);
    $('#editSupplierModal').modal('show');
}

// ======================= LƯU NGUYÊN LIỆU =======================
$(document).on('click', '#confirmSaveBtn', function () {
    const data = [];
// 🔥 CHỈ LẤY DÒNG TRONG BẢNG TRÊN
    $('#currentIngredientBody tr[data-ingredient-id]').each(function () {
        const id = $(this).data('ingredient-id');
        data.push({ id });
    });

    if (data.length === 0) {
         alert('Chưa có nguyên liệu nào để lưu.');
        return;
    }

    $.ajax({
        url: ctx + '/admin/supplier-ingredient',
        type: 'POST',
        data: {
            action: 'saveIngredients',
            supplierID: currentSupplierID,
            data: JSON.stringify(data)
        },
        success: function () {
            alert('Lưu thành công!');
            $('#ingredientModal').modal('hide');
        },
        error: function () {
            alert('Lỗi khi lưu dữ liệu.');
        }
    });
});
</script>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const forms = document.querySelectorAll("form");

    forms.forEach(form => {
        form.addEventListener("submit", function (e) {
            const textInputs = form.querySelectorAll("input[type='text']");

            for (let input of textInputs) {
                const value = input.value.trim();

                // Kiểm tra để trống hoặc toàn khoảng trắng
                if (value === "") {
                    e.preventDefault();
                    const labelText = (input.previousElementSibling && input.previousElementSibling.innerText)
                        ? input.previousElementSibling.innerText
                        : input.name;
                    alert(`Trường "${labelText}" không được để trống hoặc chỉ có khoảng trắng!`);
                    input.focus();
                    return;
                }

                // Kiểm tra ký tự đặc biệt (chỉ cho chữ, số, dấu và khoảng trắng)
                const invalidChars = /[^a-zA-ZÀ-ỹ\s\d]/u;
                if (invalidChars.test(value)) {
                    e.preventDefault();
                    const labelText = (input.previousElementSibling && input.previousElementSibling.innerText)
                        ? input.previousElementSibling.innerText
                        : input.name;
                    alert(`Trường "${labelText}" không được chứa ký tự đặc biệt!`);
                    input.focus();
                    return;
                }
            }
        });
    });
});
</script>

<script>
$(document).on("click", ".add-ingredient-btn", function () {
  const row = $(this).closest("tr");

  const id = row.data("ingredient-id");
  const name = row.data("name");
  const unit = row.data("unit");

  console.log("📦 Thêm nguyên liệu:", { id, name, unit });

  // Nếu thiếu thông tin => cảnh báo
  if (!id || !name || !unit) {
    alert("Thiếu dữ liệu nguyên liệu! Hãy kiểm tra fragment JSP.");
    return;
  }

  // Xóa dòng thông báo nếu có
  $("#currentIngredientBody .text-muted").closest("tr").remove();

  // Tạo dòng mới bằng jQuery (đảm bảo không lỗi escape)
  const newRow = $("<tr>")
    .attr("data-ingredient-id", id)
    .attr("data-name", name)
    .attr("data-unit", unit)
    .append($("<td>").text(id))
    .append($("<td>").text(name))
    .append($("<td>").text(unit))
    .append(
      $("<td>").append(`
        <div class="input-group input-group-sm">
          <button class="btn btn-outline-danger remove-ingredient-btn" type="button">Xóa</button>
        </div>
      `)
    );

  $("#currentIngredientBody").append(newRow);
  row.remove();

  if ($("#availableIngredientBody tr").length === 0) {
    $("#availableIngredientBody").html(`
      <tr><td colspan="4" class="text-center text-muted">Tất cả nguyên liệu đã được cung cấp.</td></tr>
    `);
  }
});

$(document).on("click", ".remove-ingredient-btn", function () {
  const row = $(this).closest("tr");
  const id = row.data("ingredient-id");
  const name = row.data("name");
  const unit = row.data("unit");

  console.log("❌ Xóa nguyên liệu:", { id, name, unit });

  row.remove();

  const newRow = $("<tr>")
    .attr("data-ingredient-id", id)
    .attr("data-name", name)
    .attr("data-unit", unit)
    .append($("<td>").text(id))
    .append($("<td>").text(name))
    .append($("<td>").text(unit))
    .append(
      $("<td class='text-center'>").append(`
        <button class="btn btn-outline-success btn-sm add-ingredient-btn">+ Thêm</button>
      `)
    );

  $("#availableIngredientBody").append(newRow);

  $("#availableIngredientBody .text-muted").closest("tr").remove();

  if ($("#currentIngredientBody tr").length === 0) {
    $("#currentIngredientBody").html(`
      <tr><td colspan="4" class="text-center text-muted">Chưa có nguyên liệu nào được cung cấp.</td></tr>
    `);
  }
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
