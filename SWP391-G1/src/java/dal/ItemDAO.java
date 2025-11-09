/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Item;
import model.ItemSizePrice;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ItemDAO extends DBContext {

    // ====================== Thêm Item mới (và các size kèm giá) ======================
    public boolean addItem(Item item) {
        String insertItemSql = "INSERT INTO MenuItem (Name, Description, CategoryID, Status, ImagePath) VALUES (?, ?, ?, ?, ?)";
        String insertSizeSql = "INSERT INTO ItemSizePrice (ItemID, Size, Price, Status) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement psItem = null;
        PreparedStatement psSize = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // 1️⃣ Thêm item chính
            psItem = conn.prepareStatement(insertItemSql, Statement.RETURN_GENERATED_KEYS);
            psItem.setString(1, item.getName());
            psItem.setString(2, item.getDescription());
            psItem.setInt(3, item.getCategoryID());
            psItem.setString(4, item.getStatus());
            psItem.setString(5, item.getImagePath());
            psItem.executeUpdate();

            // 2️⃣ Lấy ID của item mới thêm
            rs = psItem.getGeneratedKeys();
            int newItemID = 0;
            if (rs.next()) {
                newItemID = rs.getInt(1);
            }

            // 3️⃣ Thêm size và giá
            if (item.getSizePriceList() != null && !item.getSizePriceList().isEmpty()) {
                psSize = conn.prepareStatement(insertSizeSql);
                for (ItemSizePrice isp : item.getSizePriceList()) {
                    psSize.setInt(1, newItemID);
                    psSize.setString(2, isp.getSize());
                    psSize.setDouble(3, isp.getPrice());
                    psSize.setString(4, isp.getStatus());
                    psSize.addBatch();
                }
                psSize.executeBatch();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi thêm item: " + e.getMessage());
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            closeAll(rs, psItem, psSize, conn);
        }
        return false;
    }

    // ====================== Kiểm tra trùng tên ======================
    public boolean existsByName(String name) {
        String sql = "SELECT COUNT(*) FROM MenuItem WHERE Name = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kiểm tra tên item: " + e.getMessage());
        }
        return false;
    }

    // ====================== Lấy danh sách item kèm size và giá ======================
    public List<Item> getItemsByStatus(String status, Map<Integer, String> categoryMap) {
    List<Item> list = new ArrayList<>();
    String sql = """
        SELECT m.ItemID, m.Name, m.Description, m.CategoryID, c.CategoryName, 
               m.Status, m.ImagePath
        FROM MenuItem m
        JOIN Categories c ON m.CategoryID = c.CategoryID
        WHERE m.Status = ?
        ORDER BY m.ItemID
    """;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = getConnection();
        ps = conn.prepareStatement(sql);
        ps.setString(1, status);
        rs = ps.executeQuery();

        while (rs.next()) {
            Item item = new Item(
                    rs.getInt("ItemID"),
                    rs.getString("Name"),
                    rs.getString("Description"),
                    rs.getInt("CategoryID"),
                    rs.getString("Status"),
                    rs.getString("ImagePath")
            );

            // Lưu categoryName riêng biệt ra ngoài
            categoryMap.put(item.getItemID(), rs.getString("CategoryName"));

            // Lấy size list
            List<ItemSizePrice> sizeList = getSizesByItemId(conn, item.getItemID());
            item.setSizePriceList(sizeList);

            list.add(item);
        }

    } catch (SQLException e) {
        System.err.println("❌ Lỗi khi lấy danh sách item: " + e.getMessage());
    } finally {
        closeAll(rs, ps, null, conn);
    }

    return list;
}

    // ====================== Lấy size & giá theo itemID (dùng connection mới) ======================
    public List<ItemSizePrice> getSizesByItemId(int itemID) {
        List<ItemSizePrice> list = new ArrayList<>();
        String sql = "SELECT * FROM ItemSizePrice WHERE ItemID = ?";
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
            System.err.println("❌ Lỗi khi lấy size/giá: " + e.getMessage());
        }
        return list;
    }

    // ====================== Lấy size & giá theo itemID (tái sử dụng connection hiện tại) ======================
    private List<ItemSizePrice> getSizesByItemId(Connection conn, int itemID) throws SQLException {
        List<ItemSizePrice> list = new ArrayList<>();
        String sql = "SELECT * FROM ItemSizePrice WHERE ItemID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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
        }
        return list;
    }

    // ====================== Soft Delete Item ======================
    public boolean softDeleteItem(int itemID) {
        String sql = "UPDATE MenuItem SET Status = 'Unavailable' WHERE ItemID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi soft delete item: " + e.getMessage());
        }
        return false;
    }

    // ====================== Cập nhật Item ======================
    public boolean updateItem(Item item, Map<String, Double> sizes) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;

        String updateItemSQL = "UPDATE MenuItem SET Name=?, Description=?, CategoryID=?, Status=?, ImagePath=? WHERE ItemID=?";
        String deleteSizeSQL = "DELETE FROM ItemSizePrice WHERE ItemID=?";
        String insertSizeSQL = "INSERT INTO ItemSizePrice (ItemID, Size, Price, Status) VALUES (?, ?, ?, 'Available')";

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // Cập nhật thông tin item
            ps = conn.prepareStatement(updateItemSQL);
            ps.setString(1, item.getName());
            ps.setString(2, item.getDescription());
            ps.setInt(3, item.getCategoryID());
            ps.setString(4, item.getStatus());
            ps.setString(5, item.getImagePath());
            ps.setInt(6, item.getItemID());
            ps.executeUpdate();
            ps.close();

            // Xóa size cũ
            ps = conn.prepareStatement(deleteSizeSQL);
            ps.setInt(1, item.getItemID());
            ps.executeUpdate();
            ps.close();

            // Thêm size mới
            ps = conn.prepareStatement(insertSizeSQL);
            for (Map.Entry<String, Double> entry : sizes.entrySet()) {
                ps.setInt(1, item.getItemID());
                ps.setString(2, entry.getKey());
                ps.setDouble(3, entry.getValue());
                ps.addBatch();
            }
            ps.executeBatch();

            conn.commit();
            success = true;

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi cập nhật item: " + e.getMessage());
            if (conn != null) try {
                conn.rollback();
            } catch (SQLException ignored) {
            }
        } finally {
            closeAll(null, ps, null, conn);
        }

        return success;
    }

    public List<Map<String, Object>> getItemsWithCategoryByStatus(String status) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT i.itemID, i.itemName, i.description, i.status, i.image, "
                + "i.categoryID, c.categoryName "
                + "FROM Item i "
                + "JOIN Category c ON i.categoryID = c.categoryID "
                + "WHERE i.status = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("itemID", rs.getInt("itemID"));
                row.put("itemName", rs.getString("itemName"));
                row.put("description", rs.getString("description"));
                row.put("status", rs.getString("status"));
                row.put("image", rs.getString("image"));
                row.put("categoryID", rs.getInt("categoryID"));
                row.put("categoryName", rs.getString("categoryName"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ====================== Lấy Item theo ID ======================
    public Item getItemById(int itemID) {
        String sql = "SELECT * FROM MenuItem WHERE ItemID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Item item = new Item(
                        rs.getInt("ItemID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getInt("CategoryID"),
                        rs.getString("Status"),
                        rs.getString("ImagePath")
                );
                item.setSizePriceList(getSizesByItemId(itemID));
                return item;
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy item theo ID: " + e.getMessage());
        }
        return null;
    }

    // ====================== Hàm tiện ích đóng tài nguyên ======================
    private void closeAll(ResultSet rs, PreparedStatement ps1, PreparedStatement ps2, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (ps1 != null) ps1.close();
            if (ps2 != null) ps2.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}