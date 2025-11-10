/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 *
 * @author dotha
 */
public class OrderDAO {

    public int insertOrder(String orderCode, String customerID, String waiterID, String status, String promoID) throws Exception {
        String sql = "INSERT INTO [Order] (OrderCode, CustomerID, WaiterID, OrderDate, Status, PromoID) VALUES (?, ?, ?, GETDATE(), ?, ?)";
        try (Connection conn = DBConnection.getConnection();
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
}
