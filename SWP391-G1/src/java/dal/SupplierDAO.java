package dal;

import java.sql.*;
import java.util.*;
import model.Supplier;
import model.Ingredient;

public class SupplierDAO {

    // ✅ KHÔNG NHẬN CONNECTION TỪ NGOÀI NỮA
    public SupplierDAO() {}

    // =========================================================
    // PRIVATE CONNECTION HELPER
    // =========================================================
    private Connection getConnection() throws SQLException {
        // ✅ luôn mở connection mới → không dùng connection đã bị đóng
        return DBContext.getConnection();
    }

    // =========================================================
    // SUPPLIER CRUD
    // =========================================================
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM Supplier";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
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

    public void addSupplier(String name, String phone, String email, String address, boolean isActive) {
        String sql = "INSERT INTO Supplier (SupplierName, Phone, Email, Address, IsActive) VALUES (?, ?, ?, ?, ?)";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

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

    public void updateSupplier(int id, String name, String phone, String email, String address, boolean isActive) {
        String sql = """
            UPDATE Supplier
            SET SupplierName = ?, Phone = ?, Email = ?, Address = ?, IsActive = ?
            WHERE SupplierID = ?
        """;

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

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

    // =========================================================
    // INGREDIENTS MAPPING
    // =========================================================
    public List<Ingredient> getSuppliedIngredientsBySupplier(int supplierID) {
        List<Ingredient> list = new ArrayList<>();
        String sql = """
            SELECT i.id, i.Name, i.Unit, i.Quantity, isup.Price
            FROM Ingredients i
            JOIN IngredientSupplier isup ON i.id = isup.IngredientID
            WHERE isup.SupplierID = ?
        """;

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, supplierID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ingredient ing = new Ingredient();
                    ing.setId(rs.getInt("id"));
                    ing.setName(rs.getString("Name"));
                    ing.setUnit(rs.getString("Unit"));
                    ing.setQuantity(rs.getDouble("Quantity"));
                    ing.setPrice(rs.getDouble("Price"));
                    list.add(ing);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Ingredient> getUnsuppliedIngredientsBySupplier(int supplierID) {
        List<Ingredient> list = new ArrayList<>();
        String sql = """
            SELECT i.id, i.Name, i.Unit, i.Quantity, i.Price
            FROM Ingredients i
            WHERE i.id NOT IN (
                SELECT IngredientID FROM IngredientSupplier WHERE SupplierID = ?
            )
        """;

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, supplierID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ingredient ing = new Ingredient();
                    ing.setId(rs.getInt("id"));
                    ing.setName(rs.getString("Name"));
                    ing.setUnit(rs.getString("Unit"));
                    ing.setQuantity(rs.getDouble("Quantity"));
                    ing.setPrice(rs.getDouble("Price"));
                    list.add(ing);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addIngredientSupplier(int ingredientID, int supplierID, double price) {
        String sql = "INSERT INTO IngredientSupplier (IngredientID, SupplierID, Price, LastUpdated) VALUES (?, ?, ?, GETDATE())";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, ingredientID);
            ps.setInt(2, supplierID);
            ps.setDouble(3, price);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateIngredientPrice(int id, double newPrice) {
        String sql = "UPDATE IngredientSupplier SET Price = ?, LastUpdated = GETDATE() WHERE id = ?";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

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

        try (Connection c = getConnection();
             PreparedStatement checkPs = c.prepareStatement(checkSql)) {

            checkPs.setInt(1, supplierID);
            checkPs.setInt(2, ingredientID);

            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    try (PreparedStatement ps = c.prepareStatement(updateSql)) {
                        ps.setDouble(1, price);
                        ps.setInt(2, supplierID);
                        ps.setInt(3, ingredientID);
                        ps.executeUpdate();
                    }
                } else {
                    try (PreparedStatement ps = c.prepareStatement(insertSql)) {
                        ps.setInt(1, supplierID);
                        ps.setInt(2, ingredientID);
                        ps.setDouble(3, price);
                        ps.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =========================================================
    // SEARCH & UTILS
    // =========================================================
    public List<Supplier> searchSupplierByName(String keyword) {
        List<Supplier> list = new ArrayList<>();
        String sql = """
            SELECT SupplierID, SupplierName, Phone, Email, Address, IsActive
            FROM Supplier
            WHERE SupplierName LIKE ? AND IsActive = 1
            ORDER BY SupplierName ASC
        """;

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

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
        String sql = """
            SELECT TOP(?) SupplierID, SupplierName, Phone, Email, Address, IsActive
            FROM Supplier
            WHERE IsActive = 1
            ORDER BY SupplierName ASC
        """;

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

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

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("SupplierName");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "";
    }

    public String getIngredientNameById(int ingredientID) {
        String sql = "SELECT Name FROM Ingredients WHERE id = ?";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, ingredientID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("Name");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public String getIngredientUnitById(int ingredientID) {
        String sql = "SELECT Unit FROM Ingredients WHERE id = ?";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, ingredientID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("Unit");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "";
    }
}
