/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.SQLException;
import static dal.DBContext.connection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Order;

/**
 *
 * @author dotha
 */
public class OrderDAO {

    public int insertOrder(String orderCode, String customerID, String waiterID, String status, String promoID) throws Exception {
        String sql = "INSERT INTO [Order] (OrderCode, CustomerID, WaiterID, OrderDate, Status, PromoID) VALUES (?, ?, ?, GETDATE(), ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, orderCode);
            ps.setString(2, customerID);
            ps.setString(3, waiterID);
            ps.setString(4, status);
            ps.setString(5, promoID);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                int orderID = 0;
                if (rs.next()) {
                    orderID = rs.getInt(1);
                }
                return orderID;
            }
        }
    }
    public List<Order> getOrdersByStatus(String status) {
    List<Order> list = new ArrayList<>();
    String sql = "SELECT * FROM [Order] WHERE Status = ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, status);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Order o = new Order();
            o.setOrderID(rs.getInt("OrderID"));
            o.setStatus(rs.getString("Status"));
            o.setOrderCode(rs.getString("OrderCode"));
            list.add(o);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

   // Cập nhật trạng thái order
public void updateOrderStatus(int orderID, String newStatus) {
    String sql = "UPDATE [Order] SET Status = ? WHERE OrderID = ?";
    try (Connection con = DBContext.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, newStatus);
        ps.setInt(2, orderID);
        ps.executeUpdate();

    } catch (SQLException e) {
        e.printStackTrace();
    }
}

}
