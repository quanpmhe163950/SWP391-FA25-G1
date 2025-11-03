<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Ingredient" %>

<%
    List<Ingredient> ingredients = (List<Ingredient>) request.getAttribute("ingredients");
%>

<table style="width:100%; border-collapse: collapse; margin-top: 10px;">
    <tr style="background:#f2f2f2;">
        <th></th>
        <th>Tên nguyên liệu</th>
        <th>Đơn vị chuẩn</th>
        <th>Giá gốc (tham khảo)</th>
        <th>Giá nhập</th>
        <th>Đơn vị nhập</th>
        <th>SL / đơn vị nhập</th>
        <th>Số lượng nhập</th>
    </tr>

    <% if (ingredients == null || ingredients.isEmpty()) { %>
        <tr><td colspan="8" style="text-align:center;">Không có dữ liệu</td></tr>
    <% } else { %>
        <% for (Ingredient ing : ingredients) { %>
            <tr>
                <td><input class="ing-check" type="checkbox" value="<%= ing.getId() %>"></td>
                <td><%= ing.getName() %></td>
                <td><%= ing.getUnit() %></td>
                <td><%= String.format("%,.0f", ing.getPrice()) %> VND</td>

                <!-- ✅ Cho phép nhập giá nhập -->
                <td>
                    <input 
                        type="number"
                        id="price_<%= ing.getId() %>"
                        value="<%= ing.getPrice() %>"
                        min="0"
                        step="500"
                        style="width:100px; text-align:right;">
                </td>

                <td>
                    <select id="unit_<%= ing.getId() %>">
                        <option value="thùng">Thùng</option>
                        <option value="gói">Gói</option>
                        <option value="<%= ing.getUnit() %>"><%= ing.getUnit() %></option>
                    </select>
                </td>

                <td><input id="sub_<%= ing.getId() %>" type="number" value="1" min="1" style="width:60px;"></td>
                <td><input id="qty_<%= ing.getId() %>" type="number" value="1" min="1" style="width:60px;"></td>
            </tr>
        <% } %>
    <% } %>
</table>
