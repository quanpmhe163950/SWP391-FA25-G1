package dal;

import java.sql.*;
import java.util.*;
import model.*;

public class RecipeDAO extends DBContext {

    // 🧩 Lấy toàn bộ danh sách món ăn (bỏ HasRecipe vì model không có)
    public List<MenuItem> getAllMenuItems() {
        List<MenuItem> list = new ArrayList<>();
        String sql = """
            SELECT m.ItemID, m.Name, m.Description, m.Price, m.Category, m.Status
            FROM MenuItem m
            ORDER BY m.Name
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MenuItem m = new MenuItem();
                m.setItemID(rs.getInt("ItemID"));
                m.setName(rs.getString("Name"));
                m.setDescription(rs.getString("Description"));
                m.setPrice(rs.getDouble("Price"));
                m.setCategory(rs.getString("Category"));
                m.setStatus(rs.getBoolean("Status"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔍 Tìm kiếm món ăn theo tên
    public List<MenuItem> searchMenuItemByName(String keyword) {
        List<MenuItem> list = new ArrayList<>();
        String sql = """
            SELECT m.ItemID, m.Name, m.Description, m.Price, m.Category, m.Status
            FROM MenuItem m
            WHERE m.Name LIKE ?
            ORDER BY m.Name
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MenuItem m = new MenuItem();
                    m.setItemID(rs.getInt("ItemID"));
                    m.setName(rs.getString("Name"));
                    m.setDescription(rs.getString("Description"));
                    m.setPrice(rs.getDouble("Price"));
                    m.setCategory(rs.getString("Category"));
                    m.setStatus(rs.getBoolean("Status"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🧾 Lấy công thức (và chi tiết nguyên liệu) cho 1 món ăn
    public Recipe getRecipeByItem(int itemId) {
        Recipe recipe = null;
        String sql = "SELECT * FROM Recipe WHERE ItemID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    recipe = new Recipe();
                    recipe.setRecipeID(rs.getInt("RecipeID"));
                    recipe.setItemID(itemId);
                    recipe.setDescription(rs.getString("Description"));
                    recipe.setCreateDate(rs.getDate("CreateDate"));
                    recipe.setDetails(getRecipeDetails(recipe.getRecipeID()));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipe;
    }

    // 📋 Lấy danh sách nguyên liệu chi tiết theo RecipeID
    public List<RecipeDetail> getRecipeDetails(int recipeId) {
        List<RecipeDetail> list = new ArrayList<>();
        String sql = """
            SELECT rd.RecipeDetailID, rd.RecipeID, rd.IngredientID, rd.Quantity,
                   i.Name AS IngredientName, i.Unit
            FROM RecipeDetail rd
            JOIN Ingredients i ON rd.IngredientID = i.IngredientID
            WHERE rd.RecipeID = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, recipeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecipeDetail d = new RecipeDetail();
                    d.setRecipeDetailID(rs.getInt("RecipeDetailID"));
                    d.setRecipeID(rs.getInt("RecipeID"));
                    d.setIngredientID(rs.getInt("IngredientID"));
                    d.setIngredientName(rs.getString("IngredientName"));
                    d.setUnit(rs.getString("Unit"));
                    d.setQuantity(rs.getDouble("Quantity"));
                    list.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ➕ Thêm mới công thức
    public int addRecipe(int itemId, String description) {
        String sql = "INSERT INTO Recipe (ItemID, Description, CreateDate) VALUES (?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, itemId);
            ps.setString(2, description);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ➕ Thêm nguyên liệu vào công thức
    public void addIngredientToRecipe(int recipeId, int ingredientId, double quantity) {
        String sql = "INSERT INTO RecipeDetail (RecipeID, IngredientID, Quantity) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, recipeId);
            ps.setInt(2, ingredientId);
            ps.setDouble(3, quantity);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✏️ Cập nhật số lượng nguyên liệu trong công thức
    public void updateIngredientQuantity(int recipeDetailId, double quantity) {
        String sql = "UPDATE RecipeDetail SET Quantity = ? WHERE RecipeDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, quantity);
            ps.setInt(2, recipeDetailId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ❌ Xóa nguyên liệu khỏi công thức
    public void deleteIngredientFromRecipe(int recipeDetailId) {
        String sql = "DELETE FROM RecipeDetail WHERE RecipeDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, recipeDetailId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🗑️ Xóa toàn bộ công thức
    public void deleteRecipe(int recipeId) {
        String sql1 = "DELETE FROM RecipeDetail WHERE RecipeID = ?";
        String sql2 = "DELETE FROM Recipe WHERE RecipeID = ?";
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement ps1 = connection.prepareStatement(sql1);
                 PreparedStatement ps2 = connection.prepareStatement(sql2)) {
                ps1.setInt(1, recipeId);
                ps1.executeUpdate();
                ps2.setInt(1, recipeId);
                ps2.executeUpdate();
                connection.commit();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
    public List<Integer> getItemsWithRecipeID() {
    List<Integer> list = new ArrayList<>();
    String sql = "SELECT ItemID FROM Recipe";
    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            list.add(rs.getInt("ItemID"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

}
