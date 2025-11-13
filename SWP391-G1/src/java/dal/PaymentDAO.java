/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author dotha
 */
public class PaymentDAO {

    public void insertPayment(String paymentID, int orderID, double amount, String method, String status) throws Exception {
        String sql = "INSERT INTO Payment (OrderID, Amount, Method, Status, TransactionDate) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            ps.setDouble(2, amount);
            ps.setString(3, method);
            ps.setString(4, status);
            ps.executeUpdate();
        }
    }
}
