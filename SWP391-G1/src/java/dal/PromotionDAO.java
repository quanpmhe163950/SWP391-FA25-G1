/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Promotion;
import java.math.BigDecimal;

public class PromotionDAO {

    // ✅ Lấy khuyến mãi theo code
    public Promotion getPromotionByCode(String code) {
        Promotion promo = null;
        String sql = "SELECT * FROM Promotion WHERE Code = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    promo = mapResultSetToPromotion(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return promo;
    }

    // ✅ Lấy danh sách khuyến mãi đang hoạt động
    public List<Promotion> getActivePromotions() {
        List<Promotion> list = new ArrayList<>();
        String sql = """
            SELECT * FROM Promotion
            WHERE Status = 'Active'
              AND (StartDate IS NULL OR StartDate <= GETDATE())
              AND (EndDate IS NULL OR EndDate >= GETDATE())
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToPromotion(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Lấy danh sách có phân trang
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

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, start);
            ps.setInt(2, end);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToPromotion(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Tổng số khuyến mãi active
    public int getTotalActivePromotions() {
        String sql = """
            SELECT COUNT(*)
            FROM Promotion
            WHERE Status = 'Active'
              AND (StartDate IS NULL OR StartDate <= GETDATE())
              AND (EndDate IS NULL OR EndDate >= GETDATE())
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ✅ Lấy toàn bộ khuyến mãi
    public List<Promotion> getAllPromotions() {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT * FROM Promotion";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToPromotion(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Lấy khuyến mãi theo ID
    public Promotion getPromotionById(int id) {
        String sql = "SELECT * FROM Promotion WHERE PromoID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToPromotion(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Thêm khuyến mãi
    public void addPromotion(Promotion p) {
        String sql = """
            INSERT INTO Promotion
                (Code, Description, DiscountType, Value, StartDate, EndDate, Status, ApplyCondition)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getCode());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getDiscountType());
            ps.setBigDecimal(4, p.getValue());
            ps.setDate(5, p.getStartDate() != null ? new java.sql.Date(p.getStartDate().getTime()) : null);
            ps.setDate(6, p.getEndDate() != null ? new java.sql.Date(p.getEndDate().getTime()) : null);
            ps.setString(7, p.getStatus());
            ps.setString(8, p.getApplyCondition());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Cập nhật khuyến mãi
    public void updatePromotion(Promotion p) {
        String sql = """
            UPDATE Promotion
            SET Code=?, Description=?, DiscountType=?, Value=?, StartDate=?, EndDate=?, Status=?, ApplyCondition=?
            WHERE PromoID=?
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getCode());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getDiscountType());
            ps.setBigDecimal(4, p.getValue());
            ps.setDate(5, p.getStartDate() != null ? new java.sql.Date(p.getStartDate().getTime()) : null);
            ps.setDate(6, p.getEndDate() != null ? new java.sql.Date(p.getEndDate().getTime()) : null);
            ps.setString(7, p.getStatus());
            ps.setString(8, p.getApplyCondition());
            ps.setInt(9, p.getPromoId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Xóa khuyến mãi
    public void deletePromotion(int id) {
        String sql = "DELETE FROM Promotion WHERE PromoID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Kiểm tra xem mã khuyến mãi đã dùng cho đơn hàng chưa
    public boolean hasUsedPromotion(String orderCode, String promoCode) {
        String sql = "SELECT COUNT(*) FROM PromotionUsage WHERE OrderCode = ? AND PromotionCode = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            ps.setString(2, promoCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Ghi nhận việc sử dụng mã khuyến mãi
    public void markPromotionUsed(String orderCode, String promoCode) {
        String sql = "INSERT INTO PromotionUsage (OrderCode, PromotionCode, UsedAt) VALUES (?, ?, GETDATE())";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            ps.setString(2, promoCode);
            ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                // Đã tồn tại — bỏ qua
                return;
            }
            e.printStackTrace();
        }
    }

    // ✅ Ghi nhận mã khuyến mãi theo customer (nếu có)
    public void markPromotionUsed(String orderCode, String promoCode, String customerID) {
        String sql = "INSERT INTO PromotionUsage (OrderCode, PromotionCode, CustomerID, UsedAt) VALUES (?, ?, ?, GETDATE())";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            ps.setString(2, promoCode);
            ps.setString(3, customerID);
            ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                return;
            }
            e.printStackTrace();
        }
    }

    // ✅ Helper: ánh xạ dữ liệu từ ResultSet sang Promotion object
    private Promotion mapResultSetToPromotion(ResultSet rs) throws SQLException {
        Promotion p = new Promotion();
        p.setPromoId(rs.getInt("PromoID"));
        p.setCode(rs.getString("Code"));
        p.setDescription(rs.getString("Description"));
        p.setDiscountType(rs.getString("DiscountType"));
        p.setValue(rs.getBigDecimal("Value"));
        p.setStartDate(rs.getDate("StartDate"));
        p.setEndDate(rs.getDate("EndDate"));
        p.setStatus(rs.getString("Status"));
        try {
            p.setApplyCondition(rs.getString("ApplyCondition"));
        } catch (SQLException ignored) {
        }
        return p;
    }
    
    public boolean markPromotionUsedIfAbsent(String orderCode, String promoCode, String customerID) {
    String sqlCheck = "SELECT COUNT(*) FROM PromotionUsage WHERE OrderCode = ? AND PromoCode = ?";
    String sqlInsert = "INSERT INTO PromotionUsage (OrderCode, PromoCode, CustomerID, UsedDate) VALUES (?, ?, ?, GETDATE())";

    try (Connection con = DBContext.getConnection();
         PreparedStatement psCheck = con.prepareStatement(sqlCheck);
         PreparedStatement psInsert = con.prepareStatement(sqlInsert)) {

        // 1️⃣ Kiểm tra xem record đã tồn tại chưa
        psCheck.setString(1, orderCode);
        psCheck.setString(2, promoCode);
        ResultSet rs = psCheck.executeQuery();

        if (rs.next() && rs.getInt(1) > 0) {
            // Đã tồn tại => không thêm mới
            return false;
        }

        // 2️⃣ Nếu chưa tồn tại => thêm mới
        psInsert.setString(1, orderCode);
        psInsert.setString(2, promoCode);
        psInsert.setString(3, customerID);
        psInsert.executeUpdate();

        return true;

    } catch (SQLException e) {
        System.out.println("Error at markPromotionUsedIfAbsent: " + e.getMessage());
        return false;
    }
}

}
