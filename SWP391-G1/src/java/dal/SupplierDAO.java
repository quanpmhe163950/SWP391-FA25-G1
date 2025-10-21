package dal;

import java.sql.*;
import java.util.*;
import model.Supplier;
import model.Ingredient;
import model.IngredientSupplier;

public class SupplierDAO extends DBContext {

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
                s.setContactName(rs.getString("ContactName"));
                s.setPhone(rs.getString("Phone"));
                s.setAddress(rs.getString("Address"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- Lấy danh sách nguyên liệu mà 1 nhà cung cấp cung cấp ---
    public List<IngredientSupplier> getIngredientsBySupplier(int supplierID) {
        List<IngredientSupplier> list = new ArrayList<>();
        String sql = """
            SELECT isup.ID, isup.SupplierID, isup.IngredientID, isup.Price, isup.LastUpdated,
                   s.SupplierName, s.ContactName, s.Phone, s.Address,
                   i.IngredientName, i.Unit
            FROM IngredientSupplier isup
            JOIN Supplier s ON isup.SupplierID = s.SupplierID
            JOIN Ingredient i ON isup.IngredientID = i.IngredientID
            WHERE isup.SupplierID = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                IngredientSupplier isup = new IngredientSupplier(
                        rs.getInt("ID"),
                        rs.getInt("SupplierID"),
                        rs.getInt("IngredientID"),
                        rs.getDouble("Price"),
                        rs.getDate("LastUpdated")
                );

                // Gắn Supplier & Ingredient
                Supplier supplier = new Supplier(
                        rs.getInt("SupplierID"),
                        rs.getString("SupplierName"),
                        rs.getString("ContactName"),
                        rs.getString("Phone"),
                        rs.getString("Address")
                );
                Ingredient ingredient = new Ingredient(
                        rs.getInt("IngredientID"),
                        rs.getString("IngredientName"),
                        rs.getString("Unit")
                );

                isup.setSupplier(supplier);
                isup.setIngredient(ingredient);
                list.add(isup);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- Thêm nhà cung cấp mới ---
    public void addSupplier(String name, String contactName, String phone, String address) {
        String sql = "INSERT INTO Supplier (SupplierName, ContactName, Phone, Address) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, contactName);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- Thêm liên kết nguyên liệu - nhà cung cấp ---
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

    // --- Cập nhật giá nhập ---
    public void updateIngredientPrice(int id, double newPrice) {
        String sql = "UPDATE IngredientSupplier SET Price = ?, LastUpdated = GETDATE() WHERE ID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, newPrice);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- Xóa liên kết ---
    public void deleteIngredientSupplier(int id) {
        String sql = "DELETE FROM IngredientSupplier WHERE ID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- Tìm kiếm theo tên nhà cung cấp và/hoặc nguyên liệu ---
    public List<IngredientSupplier> search(String supplierName, String ingredientName) {
        List<IngredientSupplier> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT isup.ID, isup.SupplierID, isup.IngredientID, isup.Price, isup.LastUpdated,
                   s.SupplierName, s.ContactName, s.Phone, s.Address,
                   i.IngredientName, i.Unit
            FROM IngredientSupplier isup
            JOIN Supplier s ON isup.SupplierID = s.SupplierID
            JOIN Ingredient i ON isup.IngredientID = i.IngredientID
            WHERE 1=1
        """);

        if (supplierName != null && !supplierName.isBlank()) {
            sql.append(" AND s.SupplierName LIKE ?");
        }
        if (ingredientName != null && !ingredientName.isBlank()) {
            sql.append(" AND i.IngredientName LIKE ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (supplierName != null && !supplierName.isBlank()) {
                ps.setString(idx++, "%" + supplierName + "%");
            }
            if (ingredientName != null && !ingredientName.isBlank()) {
                ps.setString(idx++, "%" + ingredientName + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                IngredientSupplier isup = new IngredientSupplier(
                        rs.getInt("ID"),
                        rs.getInt("SupplierID"),
                        rs.getInt("IngredientID"),
                        rs.getDouble("Price"),
                        rs.getDate("LastUpdated")
                );

                Supplier supplier = new Supplier(
                        rs.getInt("SupplierID"),
                        rs.getString("SupplierName"),
                        rs.getString("ContactName"),
                        rs.getString("Phone"),
                        rs.getString("Address")
                );
                Ingredient ingredient = new Ingredient(
                        rs.getInt("IngredientID"),
                        rs.getString("IngredientName"),
                        rs.getString("Unit")
                );

                isup.setSupplier(supplier);
                isup.setIngredient(ingredient);
                list.add(isup);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
