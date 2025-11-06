package dal;

import java.sql.*;
import java.util.*;
import model.Supplier;
import model.Ingredient;

public class SupplierDAO extends DBContext {

    public SupplierDAO(Connection conn) {
        this.connection = connection;
    }

    public SupplierDAO() {
    }

    // ===========================================
    // ============== SUPPLIER CRUD ==============
    // ===========================================

    // --- Lấy toàn bộ nhà cung cấp ---
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM Supplier";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierID(rs.getInt("SupplierID"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setPhone(rs.getString("Phone"));
                s.setEmail(rs.getString("Email"));
                s.setAddress(rs.getString("Address"));
                s.setActive(rs.getBoolean("IsActive"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- Thêm nhà cung cấp ---
    public void addSupplier(String name, String phone, String email, String address, boolean isActive) {
        String sql = "INSERT INTO Supplier (SupplierName, Phone, Email, Address, IsActive) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.setBoolean(5, isActive);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- Cập nhật nhà cung cấp ---
    public void updateSupplier(int id, String name, String phone, String email, String address, boolean isActive) {
        String sql = """
            UPDATE Supplier
            SET SupplierName = ?, Phone = ?, Email = ?, Address = ?, IsActive = ?
            WHERE SupplierID = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.setBoolean(5, isActive);
            ps.setInt(6, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===========================================
    // =========== INGREDIENTS MAPPING ============
    // ===========================================

    // --- Lấy danh sách nguyên liệu mà supplier đang cung cấp ---
    public List<Ingredient> getSuppliedIngredientsBySupplier(int supplierID) {
        List<Ingredient> list = new ArrayList<>();
        String sql = """
            SELECT i.id, i.Name, i.Unit, i.Quantity, isup.Price
            FROM Ingredients i
            JOIN IngredientSupplier isup ON i.id = isup.IngredientID
            WHERE isup.SupplierID = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Ingredient ing = new Ingredient();
                ing.setId(rs.getInt("id"));
                ing.setName(rs.getString("Name"));
                ing.setUnit(rs.getString("Unit"));
                ing.setQuantity(rs.getDouble("Quantity"));
                ing.setPrice(rs.getDouble("Price"));
                list.add(ing);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- Lấy danh sách nguyên liệu chưa được cung cấp ---
    public List<Ingredient> getUnsuppliedIngredientsBySupplier(int supplierID) {
        List<Ingredient> list = new ArrayList<>();
        String sql = """
            SELECT i.id, i.Name, i.Unit, i.Quantity, i.Price
            FROM Ingredients i
            WHERE i.id NOT IN (
                SELECT IngredientID FROM IngredientSupplier WHERE SupplierID = ?
            )
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Ingredient ing = new Ingredient();
                ing.setId(rs.getInt("id"));
                ing.setName(rs.getString("Name"));
                ing.setUnit(rs.getString("Unit"));
                ing.setQuantity(rs.getDouble("Quantity"));
                ing.setPrice(rs.getDouble("Price"));
                list.add(ing);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- Thêm nguyên liệu cho supplier ---
    public void addIngredientSupplier(int ingredientID, int supplierID, double price) {
        String sql = "INSERT INTO IngredientSupplier (IngredientID, SupplierID, Price, LastUpdated) VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, ingredientID);
            ps.setInt(2, supplierID);
            ps.setDouble(3, price);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- Cập nhật giá nguyên liệu ---
    public void updateIngredientPrice(int id, double newPrice) {
        String sql = "UPDATE IngredientSupplier SET Price = ?, LastUpdated = GETDATE() WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, newPrice);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void addOrUpdateSupplierIngredient(int supplierID, int ingredientID, double price) {
    String checkSql = "SELECT id FROM IngredientSupplier WHERE SupplierID = ? AND IngredientID = ?";
    String insertSql = "INSERT INTO IngredientSupplier (SupplierID, IngredientID, Price, LastUpdated) VALUES (?, ?, ?, GETDATE())";
    String updateSql = "UPDATE IngredientSupplier SET Price = ?, LastUpdated = GETDATE() WHERE SupplierID = ? AND IngredientID = ?";

    try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
        checkPs.setInt(1, supplierID);
        checkPs.setInt(2, ingredientID);
        ResultSet rs = checkPs.executeQuery();

        if (rs.next()) {
            // Đã tồn tại → update giá
            try (PreparedStatement updatePs = connection.prepareStatement(updateSql)) {
                updatePs.setDouble(1, price);
                updatePs.setInt(2, supplierID);
                updatePs.setInt(3, ingredientID);
                updatePs.executeUpdate();
            }
        } else {
            // Chưa có → thêm mới
            try (PreparedStatement insertPs = connection.prepareStatement(insertSql)) {
                insertPs.setInt(1, supplierID);
                insertPs.setInt(2, ingredientID);
                insertPs.setDouble(3, price);
                insertPs.executeUpdate();
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

    public List<Supplier> searchSupplierByName(String keyword) {
    List<Supplier> list = new ArrayList<>();

    String sql = "SELECT SupplierID, SupplierName, Phone, Email, Address, IsActive " +
                 "FROM Supplier " +
                 "WHERE SupplierName LIKE ? AND IsActive = 1 " +
                 "ORDER BY SupplierName ASC";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {

        ps.setString(1, "%" + keyword + "%");

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierID(rs.getInt("SupplierID"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setPhone(rs.getString("Phone"));
                s.setEmail(rs.getString("Email"));
                s.setAddress(rs.getString("Address"));
                s.setActive(rs.getBoolean("IsActive"));
                list.add(s);
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}

    public List<Supplier> getTopSuppliers(int limit) {
    List<Supplier> list = new ArrayList<>();

    String sql = "SELECT TOP(?) SupplierID, SupplierName, Phone, Email, Address, IsActive " +
                 "FROM Supplier " +
                 "WHERE IsActive = 1 " +
                 "ORDER BY SupplierName ASC";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {

        ps.setInt(1, limit);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierID(rs.getInt("SupplierID"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setPhone(rs.getString("Phone"));
                s.setEmail(rs.getString("Email"));
                s.setAddress(rs.getString("Address"));
                s.setActive(rs.getBoolean("IsActive"));
                list.add(s);
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}
public String getSupplierNameById(int id) {
    String sql = "SELECT SupplierName FROM Supplier WHERE SupplierID = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getString("SupplierName");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return "";
}

// --- Lấy tên nguyên liệu theo ID ---
public String getIngredientNameById(int ingredientID) {
    String name = null;
    String sql = "SELECT name FROM Ingredients WHERE id = ?"; // ✅ đổi tên bảng + cột
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, ingredientID);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                name = rs.getString("name"); // ✅ đổi tên cột
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return name;
}
public String getIngredientUnitById(int ingredientID) {
    String unit = "";
    String sql = "SELECT Unit FROM Ingredients WHERE id = ?";
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setInt(1, ingredientID);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            unit = rs.getString("Unit");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return unit;
}

}
