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
        String sql = "INSERT INTO Payment (PaymentID, OrderID, Amount, Method, Status, TransactionDate) VALUES (?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentID);
            ps.setInt(2, orderID);
            ps.setDouble(3, amount);
            ps.setString(4, method);
            ps.setString(5, status);
            ps.executeUpdate();
        }
    }
}
