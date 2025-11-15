<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
    :root {
        --primary: #ff6b35;     /* Cam chính – thay đỏ */
        --secondary: #f39c12;   /* Cam đậm hơn */
        --success: #28a745;
        --warning: #f39c12;
        --danger: #e74c3c;
        --light: #fdf5e6;
        --dark: #2c3e50;
        --gray: #7f8c8d;
        --border: #ffe0b3;
        --shadow: 0 4px 15px rgba(255, 107, 53, 0.15);
        --radius: 12px;
    }

    /* === Bảng chính === */
    table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: var(--radius);
        overflow: hidden;
        box-shadow: var(--shadow);
        margin-top: 20px;
        font-size: 0.95rem;
    }

    th {
        background: linear-gradient(135deg, var(--primary), var(--secondary));
        color: white;
        padding: 16px 12px;
        text-align: center;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.8px;
        font-size: 0.95rem;
    }

    td {
        padding: 16px 12px;
        border-bottom: 1px solid var(--border);
        text-align: center;
        vertical-align: middle;
        transition: background 0.2s ease;
    }

    tr:hover {
        background-color: #fff8e1 !important;
    }

    /* === Cột riêng === */
    .order-code {
        font-weight: 600;
        color: var(--primary);
        font-family: 'Courier New', monospace;
        font-size: 1.05rem;
    }

    .item-list {
        text-align: left !important;
        max-width: 280px;
        line-height: 1.5;
        color: var(--dark);
    }

    .amount {
        font-weight: 700;
        color: var(--primary);
        font-size: 1.1rem;
    }

    .status-badge {
        padding: 6px 14px;
        border-radius: 50px;
        font-size: 0.82rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        display: inline-block;
        min-width: 88px;
    }

    .status-completed   {
        background: #d4edda;
        color: #155724;
    }
    .status-processing  {
        background: #fff3cd;
        color: #856404;
    }
    .status-cancelled   {
        background: #f8d7da;
        color: #721c24;
    }

    /* === Empty state === */
    .empty-state {
        text-align: center;
        padding: 50px 20px;
        color: var(--gray);
        background: white;
        border-radius: var(--radius);
        box-shadow: var(--shadow);
        margin-top: 20px;
    }

    .empty-state p {
        font-size: 1.1rem;
        margin: 0;
        color: var(--primary);
        font-weight: 500;
    }

    /* === Responsive === */
    @media (max-width: 768px) {
        th, td {
            padding: 12px 8px;
            font-size: 0.88rem;
        }
        .item-list {
            max-width: 160px;
            font-size: 0.85rem;
        }
        .order-code {
            font-size: 1rem;
        }
        .amount {
            font-size: 1rem;
        }
    }
</style>

<c:choose>
    <c:when test="${empty historyList}">
        <p style="text-align: center; color: #999; padding: 30px;">
            Bạn chưa có đơn hàng nào.
        </p>
    </c:when>
    <c:otherwise>
        <table border="1" style="width: 100%; border-collapse: collapse; margin-top: 20px;">
            <thead>
                <tr style="background: #f7f7f7;">
                    <th>Mã đơn</th>
                    <th>Ngày đặt</th>
                    <th>Món ăn</th>
                    <th>Số lượng</th>
                    <th>Tổng tiền</th>
                    <th>Thanh toán</th>
                    <th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${historyList}">
                    <tr>
                        <td><span class="order-code">${o.orderCode}</span></td>
                        <td>
                            <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy"/><br>
                            <small style="color:#888;">
                                <fmt:formatDate value="${o.orderDate}" pattern="HH:mm"/>
                            </small>
                        </td>
                        <td class="item-list">${o.itemList}</td>
                        <td><strong>${o.totalQuantity}</strong></td>
                        <td class="amount">
                            <fmt:formatNumber value="${o.amount}" type="currency" currencySymbol="₫"/>
                        </td>
                        <td>${o.paymentMethod}</td>
                        <td>
                            <span class="status-badge
                                  ${o.orderStatus == 'Hoàn thành' ? 'status-completed' :
                                    o.orderStatus == 'Đang xử lý' ? 'status-processing' : 'status-cancelled'}">
                                      ${o.orderStatus}
                                  </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>