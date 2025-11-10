/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Review;

public class ReviewDAO extends DBContext {

    public Review getReview(int customerID, int itemID) {
        String sql = "SELECT * FROM Review WHERE CustomerID = ? AND ItemID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.setInt(2, itemID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Review(
                            rs.getInt("ReviewID"),
                            rs.getInt("CustomerID"),
                            rs.getInt("ItemID"),
                            rs.getInt("Rating"),
                            rs.getString("Comment"),
                            rs.getTimestamp("ReviewDate")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertReview(int customerID, int itemID, int rating, String comment) {
        String sql = "INSERT INTO Review (CustomerID, ItemID, Rating, Comment, ReviewDate) VALUES (?, ?, ?, ?, GETDATE())";
        executeUpdate(sql, customerID, itemID, rating, comment);
    }

    public void updateReview(int reviewID, int rating, String comment) {
        String sql = "UPDATE Review SET Rating = ?, Comment = ?, ReviewDate = GETDATE() WHERE ReviewID = ?";
        executeUpdate(sql, rating, comment, reviewID);
    }

    // Helper để tái sử dụng
    private void executeUpdate(String sql, Object... params) {
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // LẤY TẤT CẢ REVIEW

    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        String sql = """
        SELECT r.*, c.FullName AS CustomerName, m.Name AS ItemName 
        FROM Review r
        JOIN [Order] o ON r.CustomerID = o.CustomerID
        JOIN OrderItem oi ON o.OrderID = oi.OrderID AND r.ItemID = oi.ItemID
        JOIN [User] c ON r.CustomerID = c.UserID
        JOIN MenuItem m ON r.ItemID = m.ItemID
        ORDER BY r.ReviewDate DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Review r = new Review(
                        rs.getInt("ReviewID"),
                        rs.getInt("CustomerID"),
                        rs.getInt("ItemID"),
                        rs.getInt("Rating"),
                        rs.getString("Comment"),
                        rs.getTimestamp("ReviewDate")
                );
                // Thêm thông tin phụ
                r.setCustomerName(rs.getString("CustomerName"));
                r.setItemName(rs.getString("ItemName"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

// XÓA REVIEW
    public boolean deleteReview(int reviewID) {
        String sql = "DELETE FROM Review WHERE ReviewID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reviewID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
