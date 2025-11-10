<%-- 
    Document   : CusInfo
    Created on : 14 thg 10, 2025, 14:25:16
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- CusInfo.jsp - CHỈ NỘI DUNG -->
<div class="content">
    <h2 style="text-align: center; color:#ff6600;">Thông tin chung</h2>
    <table>
        <tr>
            <td class="label-col">Họ và tên</td>
            <td class="value-col">${a.fullName}</td>
            <td class="action-col">
                <a class="edit-btn" href="editinfo?id=${a.userID}">Chỉnh sửa thông tin</a>

            </td>
        </tr>
        <tr>
            <td class="label-col">Số điện thoại</td>
            <td class="value-col">${a.phone}</td>
            <td class="action-col"></td>
        </tr>
        <tr>
            <td class="label-col">Email</td>
            <td class="value-col">${a.email}</td>
            <td class="action-col"></td>
        </tr>
    </table>
</div>