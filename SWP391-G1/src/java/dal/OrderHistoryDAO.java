package dal;

import java.sql.*;
import java.util.*;
import model.OrderHistory;

public class OrderHistoryDAO extends DBContext {

    public List<OrderHistory> getOrderHistoryByCustomer(int customerId) throws SQLException {
        List<OrderHistory> list = new ArrayList<>();
        String sql = "SELECT o.OrderID, o.OrderDate, m.Name AS ItemName, "
                + "oi.ItemID, "
                + "SUM(oi.Quantity * oi.Price) AS TotalPrice, "
                + "r.Rating "
                + "FROM [Order] o "
                + "JOIN OrderItem oi ON o.OrderID = oi.OrderID "
                + "JOIN MenuItem m ON oi.ItemID = m.ItemID "
                + "LEFT JOIN Review r ON r.ItemID = oi.ItemID AND r.CustomerID = o.CustomerID "
                + "WHERE o.CustomerID = ? "
                + "GROUP BY o.OrderID, o.OrderDate, m.Name, oi.ItemID, r.Rating "
                + "ORDER BY o.OrderDate DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderHistory oh = new OrderHistory();
                    oh.setOrderID(rs.getInt("OrderID"));
                    oh.setOrderDate(rs.getTimestamp("OrderDate"));
                    oh.setItemName(rs.getString("ItemName"));
                    oh.setItemID(rs.getInt("ItemID"));
                    oh.setTotalPrice(rs.getDouble("TotalPrice"));
                    Object ratingObj = rs.getObject("Rating");
                    Integer rating = null;
                    if (ratingObj instanceof Integer) {
                        rating = (Integer) ratingObj;
                    } else if (ratingObj instanceof Number) {
                        rating = ((Number) ratingObj).intValue();
                    }
                    oh.setRating(rating);

                    list.add(oh);
                }
            }
        }
        return list;
    }
}
