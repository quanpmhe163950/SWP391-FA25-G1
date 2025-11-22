<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ================= BẢNG NGUYÊN LIỆU ĐANG CUNG CẤP ================= -->
<h6 class="fw-bold text-success mb-2">Nguyên liệu đang cung cấp</h6>
<table class="table table-bordered table-hover table-sm align-middle">
  <thead class="table-light text-center">
    <tr>
      <th style="width: 70px;">ID</th>
      <th>Tên nguyên liệu</th>
      <th>Đơn vị</th>
      <th style="width: 160px;">Giá cung cấp (VNĐ)</th>
    </tr>
  </thead>
  <tbody id="currentIngredientBody">
    <c:choose>
      <c:when test="${not empty provided}">
        <c:forEach var="i" items="${provided}">
          <tr data-ingredient-id="${i.id}" data-name="${i.name}" data-unit="${i.unit}">
  <td>${i.id}</td>
  <td>${i.name}</td>
  <td>${i.unit}</td>

            <td>
              <input type="number" class="form-control form-control-sm price-input"
                     value="${i.price}" min="0" step="100">
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr><td colspan="4" class="text-center text-muted">Chưa có nguyên liệu nào được cung cấp.</td></tr>
      </c:otherwise>
    </c:choose>
  </tbody>
</table>

<!-- ================= BẢNG NGUYÊN LIỆU CHƯA CUNG CẤP ================= -->
<h6 class="fw-bold text-secondary mt-4 mb-2">Nguyên liệu chưa cung cấp</h6>
<table class="table table-bordered table-hover table-sm align-middle">
  <thead class="table-light text-center">
    <tr>
      <th style="width: 70px;">ID</th>
      <th>Tên nguyên liệu</th>
      <th>Đơn vị</th>
      <th style="width: 100px;">Thao tác</th>
    </tr>
  </thead>
  <tbody id="availableIngredientBody">
    <c:choose>
      <c:when test="${not empty notProvided}">
        <c:forEach var="i" items="${notProvided}">
  <tr data-ingredient-id="${i.id}" data-name="${i.name}" data-unit="${i.unit}">
  <td>${i.id}</td>
  <td>${i.name}</td>
  <td>${i.unit}</td>
  <td class="text-center">
    <button class="btn btn-outline-success btn-sm add-ingredient-btn">+ Thêm</button>
  </td>
</tr>

</c:forEach>

      </c:when>
      <c:otherwise>
        <tr><td colspan="4" class="text-center text-muted">Tất cả nguyên liệu đã được cung cấp.</td></tr>
      </c:otherwise>
    </c:choose>
  </tbody>
</table>

