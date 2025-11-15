package dal;

import java.sql.*;
import java.util.*;
import model.OrderHistory;

public class OrderHistoryDAO extends DBContext {

    public List<OrderHistory> getOrderHistoryByCustomer(int customerId) {
        List<OrderHistory> list = new ArrayList<>();
        String sql = """
            SELECT 
                o.OrderCode,
                o.OrderDate,
                STRING_AGG(i.name + ' (x' + CAST(oi.Quantity AS VARCHAR) + ')', ', ') 
                    WITHIN GROUP (ORDER BY i.name) AS ItemList,
                SUM(oi.Quantity) AS TotalQuantity,
                p.Amount,
                p.Method AS PaymentMethod,
                o.Status AS OrderStatus
            FROM [Order] o
            JOIN [OrderItem] oi ON o.OrderID = oi.OrderID
            JOIN [MenuItem] i ON oi.ItemID = i.ItemID
            JOIN [Payment] p ON o.OrderID = p.OrderID
            WHERE o.CustomerID = ?
            GROUP BY o.OrderID, o.OrderCode, o.OrderDate, p.Amount, p.Method, o.Status
            ORDER BY o.OrderDate DESC
            """;

       try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, customerId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OrderHistory oh = new OrderHistory();
                oh.setOrderCode(rs.getString("OrderCode"));
                oh.setOrderDate(rs.getTimestamp("OrderDate"));
                oh.setItemList(rs.getString("ItemList"));
                oh.setTotalQuantity(rs.getInt("TotalQuantity"));
                oh.setAmount(rs.getDouble("Amount"));
                oh.setPaymentMethod(rs.getString("PaymentMethod"));
                oh.setOrderStatus(rs.getString("OrderStatus"));
                list.add(oh);
            }
        }
    } catch (SQLException e) {
        System.err.println("Lỗi truy vấn lịch sử đơn hàng cho customerID = " + customerId);
        e.printStackTrace();
    }
    return list;
   }
}
