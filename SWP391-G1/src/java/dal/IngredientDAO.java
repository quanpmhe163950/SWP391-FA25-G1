package dal;

import java.sql.*;
import java.util.*;
import model.Ingredient;

public class IngredientDAO extends DBContext {

    // ====== CRUD CƠ BẢN ======
    public List<Ingredient> getAll() {
        List<Ingredient> list = new ArrayList<>();
        String sql = "SELECT id, name, unit, quantity, price FROM Ingredients";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                list.add(new Ingredient(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("unit"),
                        rs.getDouble("quantity"),
                        rs.getDouble("price")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Ingredient getById(int id) {
        String sql = "SELECT id, name, unit, quantity, price FROM Ingredients WHERE id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Ingredient(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("unit"),
                            rs.getDouble("quantity"),
                            rs.getDouble("price")
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public void insert(Ingredient i) {
        String sql = "INSERT INTO Ingredients (name, unit, quantity, price) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, i.getName());
            st.setString(2, i.getUnit());
            st.setDouble(3, i.getQuantity());
            st.setDouble(4, i.getPrice());
            st.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(Ingredient i) {
        String sql = "UPDATE Ingredients SET name = ?, unit = ?, quantity = ?, price = ? WHERE id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, i.getName());
            st.setString(2, i.getUnit());
            st.setDouble(3, i.getQuantity());
            st.setDouble(4, i.getPrice());
            st.setInt(5, i.getId());
            st.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Ingredients WHERE id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setInt(1, id);
            st.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ====== CÁC HÀM MỞ RỘNG ======

    // 1️⃣ Tìm kiếm nguyên liệu theo tên
    public List<Ingredient> searchByName(String keyword) {
        List<Ingredient> list = new ArrayList<>();
        String sql = "SELECT id, name, unit, quantity, price FROM Ingredients WHERE name LIKE ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, "%" + keyword + "%");
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(new Ingredient(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("unit"),
                            rs.getDouble("quantity"),
                            rs.getDouble("price")
                    ));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // 2️⃣ Lấy danh sách nguyên liệu chưa có trong công thức của ItemSizePrice
    public List<Ingredient> getIngredientsNotInRecipe(int itemSizePriceId) {
        List<Ingredient> list = new ArrayList<>();
        String sql = """
            SELECT id, name, unit, quantity, price
            FROM Ingredients
            WHERE id NOT IN (
                SELECT IngredientID FROM RecipeDetail WHERE RecipeID IN (
                    SELECT RecipeID FROM Recipe WHERE ItemSizePriceID = ?
                )
            )
            ORDER BY name
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, itemSizePriceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ingredient i = new Ingredient();
                    i.setId(rs.getInt("id"));
                    i.setName(rs.getString("name"));
                    i.setUnit(rs.getString("unit"));
                    i.setQuantity(rs.getDouble("quantity"));
                    i.setPrice(rs.getDouble("price"));
                    list.add(i);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
