package dal;

import static dal.DBContext.getConnection;
import java.sql.*;
import java.util.*;
import model.Item;
import model.ItemSizePrice;
import model.MenuItem;

public class MenuItemDAO {

    public Map<String, List<MenuItem>> getAvailableItemsByCategory() {
        Map<String, List<MenuItem>> categoryMap = new LinkedHashMap<>();
        String sql = "SELECT Name, Category, ImagePath FROM MenuItem WHERE Status = 'Available' ORDER BY Category";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String category = rs.getString("Category");
                MenuItem item = new MenuItem();
                item.setName(rs.getString("Name"));
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
        String sql = "SELECT ItemID, Name FROM MenuItem WHERE Name = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MenuItem item = new MenuItem();
                    item.setId(rs.getInt("ItemID"));
                    item.setName(rs.getString("Name"));
                    return item;
                }
            }
        }
        return null;
    }
    public List<MenuItem> getAllMenuItems() {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT id, name, price, category, imagePath FROM MenuItem";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MenuItem item = new MenuItem();
                item.setId(rs.getInt("id"));
                item.setName(rs.getString("name"));
                item.setCategory(rs.getString("category"));
                item.setImagePath(rs.getString("imagePath"));
                list.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
public double getPriceByItemAndSize(int id, String size) {
    String sql = "SELECT Price FROM ItemSizePrice WHERE ItemID = ? AND Size = ? AND Status = 'Active'";
    double price = 0;

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        ps.setString(2, size);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                price = rs.getDouble("Price");
            }
        }
    } catch (SQLException e) {
        System.err.println("❌ Lỗi khi lấy giá theo size: " + e.getMessage());
    }

    return price;
}

   public List<Item> getAllItems() {
    List<Item> items = new ArrayList<>();
    String sql = "SELECT mi.ItemID, mi.Name, mi.Description, mi.ImagePath, " +
                 "       mi.CategoryID, mi.Status, c.CategoryName, " +
                 "       isp.ID AS SizeID, isp.Size, isp.Price, isp.Status AS SizeStatus " +
                 "FROM MenuItem mi " +
                 "JOIN Categories c ON mi.CategoryID = c.CategoryID " +
                 "JOIN ItemSizePrice isp ON mi.ItemID = isp.ItemID " +
                 "WHERE mi.Status = 'Available' AND isp.Status = 'Active' " +
                 "ORDER BY mi.ItemID, isp.Size";

    Map<Integer, Item> map = new HashMap<>();

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            int itemId = rs.getInt("ItemID");

            if (!map.containsKey(itemId)) {
                Item item = new Item();
                item.setItemID(itemId);
                item.setName(rs.getString("Name"));
                item.setDescription(rs.getString("Description"));
                item.setImagePath(rs.getString("ImagePath"));
                item.setCategoryID(rs.getInt("CategoryID"));
                item.setStatus(rs.getString("Status"));
                item.setCategoryName(rs.getString("CategoryName"));
                item.setSizePriceList(new ArrayList<>());
                item.setDefaultPrice(Double.MAX_VALUE); // set ban đầu là MAX
                map.put(itemId, item);
            }

            ItemSizePrice sp = new ItemSizePrice();
            sp.setId(rs.getInt("SizeID"));
            sp.setItemID(itemId);
            sp.setSize(rs.getString("Size"));
            sp.setPrice(rs.getDouble("Price"));
            sp.setStatus(rs.getString("SizeStatus"));

            map.get(itemId).getSizePriceList().add(sp);

            // Cập nhật giá mặc định = giá nhỏ nhất
            if (sp.getPrice() < map.get(itemId).getDefaultPrice()) {
                map.get(itemId).setDefaultPrice(sp.getPrice());
            }
        }

        items.addAll(map.values());

    } catch (SQLException e) {
        System.err.println("❌ Lỗi khi lấy danh sách món ăn: " + e.getMessage());
    }

    return items;
}


}
