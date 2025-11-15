package dal;

import java.sql.*;
import java.util.*;
import model.Combo;

public class ComboDAO extends DBContext {

    // Lấy tất cả combo
    public List<Combo> getAllCombos() {
        List<Combo> list = new ArrayList<>();
        String sql = "SELECT * FROM Combo ORDER BY ComboID DESC";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Combo c = new Combo(
                    rs.getInt("ComboID"),
                    rs.getString("ComboName"),
                    rs.getString("Description"),
                    rs.getDouble("Price"),
                    rs.getString("ImagePath"),
                    rs.getString("Status")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            System.err.println("❌ [getAllCombos] Lỗi khi lấy danh sách combo: " + e.getMessage());
        }

        return list;
    }

    // Lấy combo theo ID
    public Combo getComboById(int id) {
        String sql = "SELECT * FROM Combo WHERE ComboID = ?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Combo(
                        rs.getInt("ComboID"),
                        rs.getString("ComboName"),
                        rs.getString("Description"),
                        rs.getDouble("Price"),
                        rs.getString("ImagePath"),
                        rs.getString("Status")
                    );
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ [getComboById] Lỗi khi lấy combo theo ID: " + e.getMessage());
        }

        return null;
    }

    // Thêm combo mới
    public boolean addCombo(Combo c) {
        String sql = "INSERT INTO Combo (ComboName, Description, Price, ImagePath, Status) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, c.getComboName());
            ps.setString(2, c.getDescription());
            ps.setDouble(3, c.getPrice());
            ps.setString(4, c.getImagePath());
            ps.setString(5, c.getStatus());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ [addCombo] Lỗi khi thêm combo: " + e.getMessage());
        }

        return false;
    }

    // Cập nhật combo
    public boolean updateCombo(Combo c) {
        String sql = "UPDATE Combo SET ComboName=?, Description=?, Price=?, ImagePath=?, Status=? "
                   + "WHERE ComboID=?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, c.getComboName());
            ps.setString(2, c.getDescription());
            ps.setDouble(3, c.getPrice());
            ps.setString(4, c.getImagePath());
            ps.setString(5, c.getStatus());
            ps.setInt(6, c.getComboID());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ [updateCombo] Lỗi khi cập nhật combo: " + e.getMessage());
        }

        return false;
    }

    // Xóa combo
    public boolean deleteCombo(int id) {
        String sql = "DELETE FROM Combo WHERE ComboID=?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ [deleteCombo] Lỗi khi xóa combo: " + e.getMessage());
        }

        return false;
    }
}
