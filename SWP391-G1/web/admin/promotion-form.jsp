<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${promotion == null ? 'Thêm' : 'Sửa'} Mã Giảm Giá</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
        <style>
            .main-content {
                flex: 1;
                padding: 25px;
                background: #f4f6f8;
                overflow-y: auto;
            }
            .form-container {
                max-width: 700px;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            }
            .form-title {
                font-size: 24px;
                color: #2c3e50;
                margin-bottom: 20px;
                font-weight: 600;
            }
            label {
                display: block;
                margin: 15px 0 5px;
                font-weight: 600;
                color: #34495e;
            }
            input[type="text"],
            input[type="number"],
            input[type="date"],
            select,
            textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                box-sizing: border-box;
            }
            textarea {
                height: 100px;
                resize: vertical;
            }
            .input-group {
                position: relative;
            }
            .input-group input {
                padding-right: 60px;
            }
            .input-group .unit {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                color: #7f8c8d;
                font-size: 14px;
                pointer-events: none;
            }
            .btn-group {
                margin-top: 25px;
                display: flex;
                gap: 10px;
            }
            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                text-align: center;
            }
            .btn-primary {
                background: #27ae60;
                color: white;
            }
            .btn-primary:hover {
                background: #219a52;
            }
            .btn-secondary {
                background: #95a5a6;
                color: white;
            }
            .btn-secondary:hover {
                background: #7f8c8d;
            }
        </style>
    </head>
    <body>

        <!-- Include Admin Panel (Sidebar) -->
        <%@ include file="admin-panel.jsp" %>

        <!-- Nội dung chính -->
        <div class="main-content">
            <div class="form-container">
                <h1 class="form-title">
                    ${promotion == null ? 'Thêm Mã Giảm Giá Mới' : 'Chỉnh Sửa Mã Giảm Giá'}
                </h1>

                <form action="${pageContext.request.contextPath}/admin/promotion" method="post">
                    <input type="hidden" name="action" value="${promotion == null ? 'add' : 'update'}">
                    <c:if test="${promotion != null}">
                        <input type="hidden" name="promoId" value="${promotion.promoId}">
                    </c:if>

                    <!-- Mã giảm giá -->
                    <label>Mã Giảm Giá <span style="color:red;">*</span></label>
                    <input type="text" name="code" value="${promotion.code}" required maxlength="50"
                           placeholder="VD: GIAM10, FREESHIP">

                    <!-- Mô tả -->
                    <label>Mô tả</label>
                    <textarea name="description" placeholder="Nhập chi tiết chương trình khuyến mãi...">${promotion.description}</textarea>

                    <!-- Loại giảm giá -->
                    <label>Loại Giảm Giá <span style="color:red;">*</span></label>
                    <select name="discountType" id="discountType" onchange="updateUnit()" required>
                        <option value="PERCENT" ${promotion.discountType == 'PERCENT' ? 'selected' : ''}>Phần trăm (%)</option>
                        <option value="FIXED" ${promotion.discountType == 'FIXED' ? 'selected' : ''}>Số tiền cố định (VNĐ)</option>
                    </select>

                    <!-- Giá trị giảm (có đơn vị tự động) -->
                    <!-- Giá trị giảm (AN TOÀN) -->
                    <label>Giá Trị Giảm <span style="color:red;">*</span></label>
                    <div class="input-group">
                        <input type="number" 
                               name="value" 
                               id="valueInput" 
                               value="<fmt:formatNumber value='${promotion.value}' pattern='#,##0.##' />" 
                               required min="0" step="0.01"
                               placeholder="VD: 10 hoặc 50000">
                        <span class="unit" id="unitLabel">
                            ${promotion.discountType == 'PERCENT' ? '%' : 'VNĐ'}
                        </span>
                    </div>
                    <!-- Ngày bắt đầu -->
                    <label>Ngày Bắt Đầu <span style="color:red;">*</span></label>
                    <input type="date" name="startDate" value="<fmt:formatDate value='${promotion.startDate}' pattern='yyyy-MM-dd'/>" required>

                    <!-- Ngày kết thúc -->
                    <label>Ngày Kết Thúc <span style="color:red;">*</span></label>
                    <input type="date" name="endDate" value="<fmt:formatDate value='${promotion.endDate}' pattern='yyyy-MM-dd'/>" required>
                    <label>Điều Kiện Áp Dụng</label>
                    <textarea name="applyCondition" placeholder="VD: Tổng tiền ≥ 200000 hoặc Khách hàng VIP">${promotion.applyCondition}</textarea>

                    <!-- Trạng thái -->
                    <label>Trạng Thái <span style="color:red;">*</span></label>
                    <select name="status" required>
                        <option value="ACTIVE" ${promotion.status == 'ACTIVE' ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="INACTIVE" ${promotion.status == 'INACTIVE' ? 'selected' : ''}>Tạm dừng</option>
                    </select>

                    <!-- Nút hành động -->
                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">
                            ${promotion == null ? 'Tạo Mới' : 'Cập Nhật'}
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/promotion" class="btn btn-secondary">
                            Hủy bỏ
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- JS: Cập nhật đơn vị (%) hoặc (VNĐ) -->
        <script>
            function updateUnit() {
                const type = document.getElementById("discountType").value;
                const unitLabel = document.getElementById("unitLabel");
                const valueInput = document.getElementById("valueInput");

                if (type === "PERCENT") {
                    unitLabel.textContent = "%";
                    valueInput.step = "0.01";
                    valueInput.max = "100";
                    valueInput.placeholder = "VD: 10, 15.5 (tối đa 100)";
                } else {
                    unitLabel.textContent = "VNĐ";
                    valueInput.step = "1";
                    valueInput.removeAttribute("max");
                    valueInput.placeholder = "VD: 50000, 100000";
                }
            }

            // Gọi khi tải trang
            window.onload = updateUnit;
        </script>
    </body>
</html>