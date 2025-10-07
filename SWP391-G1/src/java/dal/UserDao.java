/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import java.sql.Connection;

/**
 *
 * @author ASUS
 */
public class UserDao extends DBContext {

    public Customer getById(String userId) throws SQLException {
        String sql = "SELECT FullName, Phone, Email FROM [User] WHERE UserID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String name = rs.getString("FullName");
                    String phone = rs.getString("Phone");
                    String email = rs.getString("Email");

                    return new Customer(name, phone, email);
                }
            }
        }
        return null;
    }
     public boolean checkCurrentPassword(String username, String currentPassword) {
        boolean result = false;
        String sql = "SELECT * FROM [User] WHERE Username=? AND PasswordHash=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, currentPassword);
            ResultSet rs = ps.executeQuery();
            result = rs.next();
        } catch (Exception e) {
            System.out.println(e);
        }
        return result;
    }

    public boolean updatePassword(String username, String newPassword) {
        boolean result = false;
        String sql = "UPDATE [User] SET PasswordHash=? WHERE Username=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, username);
            result = ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println(e);
        }
        return result;
    }
   
}


