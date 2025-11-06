<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Supplier" %>

<%
    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
%>

<% if (suppliers != null && !suppliers.isEmpty()) { %>

    <% for (Supplier s : suppliers) { %>
        <option value="<%= s.getSupplierID() %>">
            <%= s.getSupplierName() %>
        </option>
    <% } %>

<% } else { %>
    <!-- Không có nhà cung cấp nào -->
    <option disabled>Không tìm thấy nhà cung cấp</option>
<% } %>
