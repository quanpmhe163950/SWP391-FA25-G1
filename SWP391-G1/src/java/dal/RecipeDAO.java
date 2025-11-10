package dal;

import java.sql.*;
import java.util.*;
import model.MenuItem;
import model.Recipe;
import model.RecipeDetail;

public class RecipeDAO extends DBContext {

    // 🧩 Lấy toàn bộ MenuItem
    public List<MenuItem> getAllItems() {
        List<MenuItem> list = new ArrayList<>();

        String sql = """
            SELECT ItemID, Name, Description, Price, Category, Status, ImagePath, CategoryID
            FROM MenuItem
            ORDER BY Name
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MenuItem item = new MenuItem(
                        rs.getInt("ItemID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getDouble("Price"),
                        rs.getString("Category"),
                        rs.getString("Status"),
                        rs.getString("ImagePath"),
                        rs.getInt("CategoryID")
                );
                list.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // 🔍 Tìm kiếm món ăn theo tên
    public List<MenuItem> searchItemByName(String keyword) {
        List<MenuItem> list = new ArrayList<>();

        String sql = """
            SELECT ItemID, Name, Description, Price, Category, Status, ImagePath, CategoryID
            FROM MenuItem
            WHERE Name LIKE ?
            ORDER BY Name
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(new MenuItem(
                            rs.getInt("ItemID"),
                            rs.getString("Name"),
                            rs.getString("Description"),
                            rs.getDouble("Price"),
                            rs.getString("Category"),
                            rs.getString("Status"),
                            rs.getString("ImagePath"),
                            rs.getInt("CategoryID")
                    ));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // 🧾 Lấy công thức theo MenuItemID
    public Recipe getRecipeByItem(int menuItemId) {
        Recipe recipe = null;

        String sql = "SELECT * FROM Recipe WHERE MenuItemID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, menuItemId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    recipe = new Recipe();
                    recipe.setRecipeID(rs.getInt("RecipeID"));
                    recipe.setItemID(menuItemId);
                    recipe.setDescription(rs.getString("Description"));
                    recipe.setCreateDate(rs.getDate("CreateDate"));

                    recipe.setDetails(getRecipeDetails(rs.getInt("RecipeID")));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return recipe;
    }

    // 📋 Lấy danh sách nguyên liệu của công thức
    public List<RecipeDetail> getRecipeDetails(int recipeId) {
        List<RecipeDetail> list = new ArrayList<>();

        String sql = """
            SELECT rd.RecipeDetailID, rd.RecipeID, rd.IngredientID, rd.Quantity,
                   i.Name AS IngredientName, i.Unit
            FROM RecipeDetail rd
            JOIN Ingredients i ON rd.IngredientID = i.id
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

    // ✅ Thêm công thức + chi tiết
    public int addRecipeWithDetails(int menuItemId, String description, List<RecipeDetail> details) {

        String insertRecipeSQL = """
            INSERT INTO Recipe (MenuItemID, Description, CreateDate)
            VALUES (?, ?, GETDATE())
        """;

        String insertDetailSQL = """
            INSERT INTO RecipeDetail (RecipeID, IngredientID, Quantity)
            VALUES (?, ?, ?)
        """;

        int recipeId = -1;

        try {
            connection.setAutoCommit(false);

            // Thêm Recipe
            try (PreparedStatement ps = connection.prepareStatement(insertRecipeSQL, Statement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, menuItemId);
                ps.setString(2, description);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        recipeId = rs.getInt(1);
                    }
                }
            }

            // Thêm detail
            if (recipeId > 0 && details != null) {

                try (PreparedStatement ps = connection.prepareStatement(insertDetailSQL)) {
                    for (RecipeDetail d : details) {
                        ps.setInt(1, recipeId);
                        ps.setInt(2, d.getIngredientID());
                        ps.setDouble(3, d.getQuantity());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            connection.commit();

        } catch (SQLException e) {
            e.printStackTrace();
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }

        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }

        return recipeId;
    }

    // ✏️ Cập nhật số lượng nguyên liệu
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
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }

        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }

    // 📦 Lấy danh sách MenuItemID đã có công thức
    public List<Integer> getItemsWithRecipeID() {
        List<Integer> list = new ArrayList<>();

        String sql = "SELECT MenuItemID FROM Recipe";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getInt("MenuItemID"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // ➕ Thêm nguyên liệu vào công thức hiện có
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

    // 🔧 Cập nhật công thức
    public void updateRecipe(int recipeId, String description,
                             List<RecipeDetail> updatedDetails,
                             List<RecipeDetail> newDetails,
                             List<Integer> deletedDetailIds) {

        String updateDescSQL = "UPDATE Recipe SET Description = ? WHERE RecipeID = ?";
        String updateDetailSQL = "UPDATE RecipeDetail SET Quantity = ? WHERE RecipeDetailID = ?";
        String deleteDetailSQL = "DELETE FROM RecipeDetail WHERE RecipeDetailID = ?";
        String insertDetailSQL = "INSERT INTO RecipeDetail (RecipeID, IngredientID, Quantity) VALUES (?, ?, ?)";

        try {
            connection.setAutoCommit(false);

            // 1️⃣ Cập nhật mô tả công thức
            try (PreparedStatement ps = connection.prepareStatement(updateDescSQL)) {
                ps.setString(1, description);
                ps.setInt(2, recipeId);
                ps.executeUpdate();
            }

            // 2️⃣ Cập nhật nguyên liệu
            if (updatedDetails != null) {
                try (PreparedStatement ps = connection.prepareStatement(updateDetailSQL)) {

                    for (RecipeDetail d : updatedDetails) {
                        ps.setDouble(1, d.getQuantity());
                        ps.setInt(2, d.getRecipeDetailID());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            // 3️⃣ Xóa các nguyên liệu được yêu cầu xóa
            if (deletedDetailIds != null) {
                try (PreparedStatement ps = connection.prepareStatement(deleteDetailSQL)) {

                    for (int id : deletedDetailIds) {
                        ps.setInt(1, id);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            // 4️⃣ Thêm nguyên liệu mới
            if (newDetails != null) {
                try (PreparedStatement ps = connection.prepareStatement(insertDetailSQL)) {

                    for (RecipeDetail d : newDetails) {
                        ps.setInt(1, recipeId);
                        ps.setInt(2, d.getIngredientID());
                        ps.setDouble(3, d.getQuantity());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            connection.commit();

        } catch (SQLException e) {
            e.printStackTrace();
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }

        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }
}
