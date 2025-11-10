/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.ItemSizePrice;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemSizePriceDAO extends DBContext {

    // ====================== Thêm mới một size/giá cho Item ======================
    public boolean addSizePrice(ItemSizePrice isp) {
        String sql = "INSERT INTO ItemSizePrice (ItemID, Size, Price, Status) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, isp.getItemID());
            ps.setString(2, isp.getSize());
            ps.setDouble(3, isp.getPrice());
            ps.setString(4, isp.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi thêm size/giá: " + e.getMessage());
        }
        return false;
    }

    // ====================== Lấy danh sách size/giá theo ItemID ======================
    public List<ItemSizePrice> getByItemID(int itemID) {
        List<ItemSizePrice> list = new ArrayList<>();
        String sql = "SELECT * FROM ItemSizePrice WHERE ItemID = ? ORDER BY ID";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new ItemSizePrice(
                        rs.getInt("ID"),
                        rs.getInt("ItemID"),
                        rs.getString("Size"),
                        rs.getDouble("Price"),
                        rs.getString("Status")
                ));
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy size/giá theo itemID: " + e.getMessage());
        }
        return list;
    }

    // ====================== Lấy thông tin size/giá theo ID ======================
    public ItemSizePrice getById(int id) {
        String sql = "SELECT * FROM ItemSizePrice WHERE ID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new ItemSizePrice(
                        rs.getInt("ID"),
                        rs.getInt("ItemID"),
                        rs.getString("Size"),
                        rs.getDouble("Price"),
                        rs.getString("Status")
                );
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy size/giá theo ID: " + e.getMessage());
        }
        return null;
    }

    // ====================== Cập nhật size/giá ======================
    public boolean updateSizePrice(ItemSizePrice isp) {
        String sql = "UPDATE ItemSizePrice SET Size = ?, Price = ?, Status = ? WHERE ID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, isp.getSize());
            ps.setDouble(2, isp.getPrice());
            ps.setString(3, isp.getStatus());
            ps.setInt(4, isp.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi cập nhật size/giá: " + e.getMessage());
        }
        return false;
    }

    // ====================== Xóa size/giá (soft delete) ======================
    public boolean softDeleteSizePrice(int id) {
        String sql = "UPDATE ItemSizePrice SET Status = 'Inactive' WHERE ID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi xóa size/giá: " + e.getMessage());
        }
        return false;
    }

    // ====================== Xóa cứng size/giá (delete thực sự) ======================
    public boolean deleteSizePrice(int id) {
        String sql = "DELETE FROM ItemSizePrice WHERE ID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi xóa cứng size/giá: " + e.getMessage());
        }
        return false;
    }

    // ====================== Lấy tất cả size/giá ======================
    public List<ItemSizePrice> getAll() {
        List<ItemSizePrice> list = new ArrayList<>();
        String sql = "SELECT * FROM ItemSizePrice ORDER BY ItemID";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ItemSizePrice(
                        rs.getInt("ID"),
                        rs.getInt("ItemID"),
                        rs.getString("Size"),
                        rs.getDouble("Price"),
                        rs.getString("Status")
                ));
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy tất cả size/giá: " + e.getMessage());
        }
        return list;
    }

    // ====================== Kiểm tra size trùng cho 1 Item ======================
    public boolean existsSizeForItem(int itemID, String size) {
        String sql = "SELECT COUNT(*) FROM ItemSizePrice WHERE ItemID = ? AND Size = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemID);
            ps.setString(2, size.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kiểm tra trùng size: " + e.getMessage());
        }
        return false;
    }
}
