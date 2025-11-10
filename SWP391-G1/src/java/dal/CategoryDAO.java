/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext {

    public boolean isCategoryNameExist(String categoryName) {
        String sql = "SELECT COUNT(*) FROM Categories WHERE CategoryName = ?";
        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, categoryName.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addCategory(String categoryName, String Description, String status) {
        if (status == null || status.isEmpty()) {
            status = "Available";
        }

        String sql = "INSERT INTO Categories (CategoryName, Description, Status) VALUES (?, ?, ?)";
        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, categoryName);
            ps.setString(2, Description);
            ps.setString(3, status);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm Category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName, Description, Status FROM Categories ORDER BY CategoryID";
        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("CategoryID"),
                        rs.getString("CategoryName"),
                        rs.getString("Description"),
                        rs.getString("Status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addCategory(String categoryName) {
        String sql = "INSERT INTO Categories (CategoryName) VALUES (?)";
        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, categoryName);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm Category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Lấy danh mục theo trạng thái
    public List<Category> getCategoriesByStatus(String status) {
    List<Category> list = new ArrayList<>();
    String sql = "SELECT CategoryID, CategoryName, Description, Status FROM Categories WHERE Status = ? ORDER BY CategoryID";
    
    try (
        Connection conn = getConnection(); 
        PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, status); 
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Category(
                    rs.getInt("CategoryID"),
                    rs.getString("CategoryName"),
                    rs.getString("Description"),
                    rs.getString("Status") 
                ));
            }
        }
    } catch (SQLException e) {
        e.printStackTrace(); 
    }
    return list;
}

    public Category getCategoryById(int id) {
        String sql = "SELECT CategoryID, CategoryName, Description, Status FROM Categories WHERE CategoryID = ?";
        try (
                Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Category(
                            rs.getInt("CategoryID"),
                            rs.getString("CategoryName"),
                            rs.getString("Description"), 
                            rs.getString("Status")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCategory(Category category) {
        String sql = "UPDATE Categories SET CategoryName = ?, Description = ?,  Status = ? WHERE CategoryID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getStatus());
            ps.setInt(4, category.getCategoryID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đổi trạng thái sang Unavailable (soft delete)
    public boolean softDeleteCategory(int categoryID) {
        String sql = "UPDATE Categories SET Status = 'Unavailable' WHERE CategoryID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

