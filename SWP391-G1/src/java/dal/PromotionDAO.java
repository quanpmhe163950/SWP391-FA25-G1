/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Promotion;
import java.sql.*;

/**
 *
 * @author ASUS
 */
public class PromotionDAO extends DBContext {

    public Promotion getPromotionById(int promoId) throws SQLException {
        String sql = "SELECT PromoID, Code, Description, DiscountType, Value, StartDate, EndDate, Status, ApplyCondition "
                + "FROM Promotion WHERE PromoID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, promoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Promotion promotion = new Promotion();
                    promotion.setPromoId(rs.getInt("PromoID"));
                    promotion.setCode(rs.getString("Code"));
                    promotion.setDescription(rs.getString("Description"));
                    promotion.setDiscountType(rs.getString("DiscountType"));
                    promotion.setValue(rs.getBigDecimal("Value"));
                    promotion.setStartDate(rs.getDate("StartDate"));
                    promotion.setEndDate(rs.getDate("EndDate"));
                    promotion.setStatus(rs.getString("Status"));
                    promotion.setApplyCondition(rs.getString("ApplyCondition"));
                    return promotion;
                }
            }
        }
        return null;
    }

    public List<Promotion> getAllPromotions() throws SQLException {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT PromoID, Code, Description, DiscountType, Value, StartDate, EndDate, Status,ApplyCondition  "
                + "FROM Promotion ORDER BY StartDate DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Promotion p = new Promotion();
                p.setPromoId(rs.getInt("PromoID"));
                p.setCode(rs.getString("Code"));
                p.setDescription(rs.getString("Description"));
                p.setDiscountType(rs.getString("DiscountType"));
                p.setValue(rs.getBigDecimal("Value"));
                p.setStartDate(rs.getDate("StartDate"));
                p.setEndDate(rs.getDate("EndDate"));
                p.setStatus(rs.getString("Status"));
                p.setApplyCondition(rs.getString("ApplyCondition"));
                list.add(p);
            }
        }
        return list;
    }

    public boolean addPromotion(Promotion p) throws SQLException {
        String sql = "INSERT INTO Promotion (Code, Description, DiscountType, Value, StartDate, EndDate, Status, ApplyCondition) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, p.getCode());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getDiscountType());
            ps.setBigDecimal(4, p.getValue());
            ps.setDate(5, new java.sql.Date(p.getStartDate().getTime()));
            ps.setDate(6, new java.sql.Date(p.getEndDate().getTime()));
            ps.setString(7, p.getStatus());
            ps.setString(8, p.getApplyCondition());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updatePromotion(Promotion p) throws SQLException {
        String sql = "UPDATE Promotion SET Code=?, Description=?, DiscountType=?, Value=?, StartDate=?, EndDate=?, Status=?, ApplyCondition=? "
                + "WHERE PromoID=?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, p.getCode());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getDiscountType());
            ps.setBigDecimal(4, p.getValue());
            ps.setDate(5, new java.sql.Date(p.getStartDate().getTime()));
            ps.setDate(6, new java.sql.Date(p.getEndDate().getTime()));
            ps.setString(7, p.getStatus());
            ps.setString(8, p.getApplyCondition());
            ps.setInt(9, p.getPromoId());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean deletePromotion(int promoId) throws SQLException {
        String sql = "DELETE FROM Promotion WHERE PromoID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, promoId);
            return ps.executeUpdate() > 0;
        }
    }
}
