/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Promotion;

public class PromotionDAO {

    public Promotion getPromotionByCode(String code) {
        Promotion promo = null;
        String sql = "SELECT * FROM Promotion WHERE Code = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    promo = new Promotion();
                    promo.setPromoID(rs.getString("PromoID"));
                    promo.setCode(rs.getString("Code"));
                    promo.setDescription(rs.getString("Description"));
                    promo.setDiscountType(rs.getString("DiscountType"));
                    promo.setValue(rs.getBigDecimal("Value"));
                    promo.setStartDate(rs.getDate("StartDate"));
                    promo.setEndDate(rs.getDate("EndDate"));
                    promo.setStatus(rs.getString("Status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return promo;
    }

    public List<Promotion> getActivePromotions() {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT * FROM Promotion WHERE Status = 'Active' "
                + "AND (StartDate IS NULL OR StartDate <= GETDATE()) "
                + "AND (EndDate IS NULL OR EndDate >= GETDATE())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Promotion p = new Promotion();
                p.setPromoID(rs.getString("PromoID"));
                p.setCode(rs.getString("Code"));
                p.setDescription(rs.getString("Description"));
                p.setDiscountType(rs.getString("DiscountType"));
                p.setValue(rs.getBigDecimal("Value"));
                p.setStartDate(rs.getDate("StartDate"));
                p.setEndDate(rs.getDate("EndDate"));
                p.setStatus(rs.getString("Status"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Promotion> getActivePromotionsPaging(int page, int pageSize) {
        List<Promotion> list = new ArrayList<>();
        String sql = """
        SELECT * FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY StartDate DESC) AS rn, *
            FROM Promotion
            WHERE Status = 'Active'
              AND (StartDate IS NULL OR StartDate <= GETDATE())
              AND (EndDate IS NULL OR EndDate >= GETDATE())
        ) AS temp
        WHERE rn BETWEEN ? AND ?
    """;
        int start = (page - 1) * pageSize + 1;
        int end = page * pageSize;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, start);
            ps.setInt(2, end);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Promotion p = new Promotion();
                    p.setPromoID(rs.getString("PromoID"));
                    p.setCode(rs.getString("Code"));
                    p.setDescription(rs.getString("Description"));
                    p.setDiscountType(rs.getString("DiscountType"));
                    p.setValue(rs.getBigDecimal("Value"));
                    p.setStartDate(rs.getDate("StartDate"));
                    p.setEndDate(rs.getDate("EndDate"));
                    p.setStatus(rs.getString("Status"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalActivePromotions() {
        String sql = """
        SELECT COUNT(*)
        FROM Promotion
        WHERE Status = 'Active'
          AND (StartDate IS NULL OR StartDate <= GETDATE())
          AND (EndDate IS NULL OR EndDate >= GETDATE())
    """;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Kiểm tra xem mã khuyến mãi này đã được dùng cho đơn hàng chưa
    public boolean hasUsedPromotion(String orderCode, String promoCode) {
        String sql = "SELECT COUNT(*) FROM PromotionUsage WHERE OrderCode = ? AND PromotionCode = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            ps.setString(2, promoCode);
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
// Ghi nhận việc đã sử dụng mã khuyến mãi

    public void markPromotionUsed(String orderCode, String promoCode) {
        String sql = "INSERT INTO PromotionUsage (OrderCode, PromotionCode) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            ps.setString(2, promoCode);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void markPromotionUsedIfAbsent(String orderCode, String promoCode) {
        String sql = "INSERT INTO PromotionUsage (OrderCode, PromotionCode, UsedAt) VALUES (?, ?, GETDATE())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            ps.setString(2, promoCode);
            ps.executeUpdate();
        } catch (SQLException e) {
            // SQL Server: 2627 (vi phạm UNIQUE/PK), 2601 (trùng unique index)
            if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                // đã tồn tại -> coi như OK (idempotent)
                return;
            }
            throw new RuntimeException(e);
        }
    }

    public void markPromotionUsedIfAbsent(String orderCode, String promoCode, String customerID) {
        String sql = "INSERT INTO PromotionUsage (OrderCode, PromotionCode, CustomerID, UsedAt) VALUES (?, ?, ?, GETDATE())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            ps.setString(2, promoCode);
            ps.setString(3, customerID); // null nếu guest
            ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                return;
            }
            throw new RuntimeException(e);
        }
    }
}
