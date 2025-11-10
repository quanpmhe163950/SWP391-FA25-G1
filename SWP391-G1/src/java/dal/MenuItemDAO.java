package dal;

import java.sql.*;
import java.util.*;
import model.MenuItem;

public class MenuItemDAO {

    public Map<String, List<MenuItem>> getAvailableItemsByCategory() {
        Map<String, List<MenuItem>> categoryMap = new LinkedHashMap<>();
        String sql = "SELECT Name, Price, Category, ImagePath FROM MenuItem WHERE Status = 'Available' ORDER BY Category";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String category = rs.getString("Category");
                MenuItem item = new MenuItem();
                item.setName(rs.getString("Name"));
                item.setPrice(rs.getDouble("Price"));
                item.setCategory(category);
                item.setImagePath(rs.getString("ImagePath")); // ✅ Lấy đường dẫn ảnh
                categoryMap.computeIfAbsent(category, k -> new ArrayList<>()).add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categoryMap;
    }

    public MenuItem getItemByName(String name) throws Exception {
        String sql = "SELECT ItemID, Name, Price FROM MenuItem WHERE Name = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MenuItem item = new MenuItem();
                    item.setId(rs.getString("ItemID"));
                    item.setName(rs.getString("Name"));
                    item.setPrice(rs.getDouble("Price"));
                    return item;
                }
            }
        }
        return null;
    }
}
