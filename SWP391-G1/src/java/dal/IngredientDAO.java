package dal;

import java.sql.*;
import java.util.*;
import model.Ingredient;

public class IngredientDAO extends DBContext {

    // ====== CRUD CƠ BẢN ======
    public List<Ingredient> getAll() {
        List<Ingredient> list = new ArrayList<>();
        String sql = "SELECT * FROM Ingredients";
        try (PreparedStatement st = connection.prepareStatement(sql);
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Ingredient getById(int id) {
        String sql = "SELECT * FROM Ingredients WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Ingredient(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("unit"),
                    rs.getDouble("quantity"),
                    rs.getDouble("price")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(Ingredient i) {
        String sql = "INSERT INTO Ingredients (name, unit, quantity, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, i.getName());
            st.setString(2, i.getUnit());
            st.setDouble(3, i.getQuantity());
            st.setDouble(4, i.getPrice());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Ingredient i) {
        String sql = "UPDATE Ingredients SET name=?, unit=?, quantity=?, price=? WHERE id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, i.getName());
            st.setString(2, i.getUnit());
            st.setDouble(3, i.getQuantity());
            st.setDouble(4, i.getPrice());
            st.setInt(5, i.getId());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Ingredients WHERE id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ====== CÁC HÀM MỞ RỘNG ======

    // 1️⃣ Tìm kiếm nguyên liệu theo tên (hỗ trợ LIKE)
    public List<Ingredient> searchByName(String keyword) {
        List<Ingredient> list = new ArrayList<>();
        String sql = "SELECT * FROM Ingredients WHERE name LIKE ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Ingredient(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("unit"),
                    rs.getDouble("quantity"),
                    rs.getDouble("price")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2️⃣ Tìm các món ăn có chứa nguyên liệu (JOIN với bảng trung gian RecipeDetail hoặc tương đương)
    public List<String> getDishesByIngredient(int ingredientId) {
        List<String> dishes = new ArrayList<>();
        String sql = """
            SELECT DISTINCT d.name 
            FROM Dishes d 
            JOIN RecipeDetail rd ON d.id = rd.dish_id 
            WHERE rd.ingredient_id = ?
        """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, ingredientId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                dishes.add(rs.getString("name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dishes;
    }

    // 3️⃣ Lấy danh sách món ăn chưa có công thức
    public List<String> getDishesWithoutRecipe() {
        List<String> dishes = new ArrayList<>();
        String sql = """
            SELECT d.name 
            FROM Dishes d
            LEFT JOIN RecipeDetail rd ON d.id = rd.dish_id
            WHERE rd.dish_id IS NULL
        """;
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                dishes.add(rs.getString("name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dishes;
    }
}
