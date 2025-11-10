/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import model.MenuItem;
import java.sql.*;

/**
 *
 * @author ASUS
 */
public class MenuItemDAO extends DBContext {

    public List<MenuItem> getAllMenuItems() {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT ItemID, Name, Description, Price, Category, Status, ImagePath, CategoryID FROM MenuItem";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MenuItem item = new MenuItem(
                        rs.getInt("ItemID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getDouble("Price"),
                        rs.getString("Category"),
                        rs.getString("Status"),
                        rs.getString("ImagePath"),
                        rs.getInt("CategoryID")
                );
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("=== [DAO] Lỗi lấy MenuItem: " + e.getMessage());
            return new ArrayList<>(); // TRẢ RỖNG, KHÔNG NULL
        }
        return list;
    }
    // CẬP NHẬT MÓN ĂN

    public boolean updateMenuItem(MenuItem item) throws SQLException {
        String sql = "UPDATE MenuItem SET Name=?, Description=?, Price=?, Category=?, Status=?, ImagePath=?, CategoryID=? WHERE ItemID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, item.getName());
            ps.setString(2, item.getDescription());
            ps.setDouble(3, item.getPrice());
            ps.setString(4, item.getCategory());
            ps.setString(5, item.getStatus());
            ps.setString(6, item.getImagePath());
            ps.setInt(7, item.getCategoryID());
            ps.setInt(8, item.getItemID());
            return ps.executeUpdate() > 0;
        }
    }

// XÓA MÓN ĂN
    public boolean deleteMenuItem(int itemID) throws SQLException {
        String sql = "DELETE FROM MenuItem WHERE ItemID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemID);
            return ps.executeUpdate() > 0;
        }
    }
}
