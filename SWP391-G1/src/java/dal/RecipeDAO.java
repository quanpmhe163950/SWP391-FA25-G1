package dal;

import java.sql.*;
import java.util.*;
import model.ItemSizePrice;
import model.MenuItem;
import model.Recipe;
import model.RecipeDetail;

public class RecipeDAO {

    // 🔹 Lấy tất cả ItemSizePrice kèm MenuItem
    public List<ItemSizePrice> getAllItems() {
        List<ItemSizePrice> list = new ArrayList<>();

        String sql = """
            SELECT isp.ID AS ID,
                   isp.ItemID,
                   isp.Size,
                   isp.Price,
                   isp.Status,
                   mi.ItemID AS MenuItemID,
                   mi.Name AS ItemName,
                   mi.Description,
                   mi.Category,
                   mi.Status AS MenuStatus,
                   mi.ImagePath,
                   mi.CategoryID
            FROM ItemSizePrice isp
            JOIN MenuItem mi ON mi.ItemID = isp.ItemID
            ORDER BY mi.Name, isp.Size
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ItemSizePrice isp = new ItemSizePrice();
                isp.setId(rs.getInt("ID"));
                isp.setItemID(rs.getInt("ItemID"));
                isp.setSize(rs.getString("Size"));
                isp.setPrice(rs.getDouble("Price"));
                isp.setStatus(rs.getString("Status"));

                MenuItem mi = new MenuItem();
                mi.setId(rs.getInt("MenuItemID")); // ItemID đúng
                mi.setName(rs.getString("ItemName"));
                mi.setDescription(rs.getString("Description"));
                mi.setCategory(rs.getString("Category"));
                mi.setStatus(rs.getString("MenuStatus"));
                mi.setImagePath(rs.getString("ImagePath"));
                mi.setCategoryId(rs.getInt("CategoryID"));

                isp.setMenuItem(mi);
                list.add(isp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // 🔍 Tìm kiếm ItemSizePrice theo tên món
    public List<ItemSizePrice> searchItemByName(String keyword) {
        List<ItemSizePrice> list = new ArrayList<>();

        String sql = """
            SELECT isp.ID AS ID,
                   isp.ItemID,
                   isp.Size,
                   isp.Price,
                   isp.Status AS SizeStatus,
                   mi.ItemID AS MenuItemID,
                   mi.Name AS ItemName,
                   mi.Description,
                   mi.Category,
                   mi.Status AS MenuStatus,
                   mi.ImagePath,
                   mi.CategoryID
            FROM ItemSizePrice isp
            JOIN MenuItem mi ON mi.ItemID = isp.ItemID
            WHERE mi.Name LIKE ?
            ORDER BY mi.Name, isp.Size
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ItemSizePrice isp = new ItemSizePrice();
                    isp.setId(rs.getInt("ID"));
                    isp.setItemID(rs.getInt("ItemID"));
                    isp.setSize(rs.getString("Size"));
                    isp.setPrice(rs.getDouble("Price"));
                    isp.setStatus(rs.getString("SizeStatus"));

                    MenuItem mi = new MenuItem();
                    mi.setId(rs.getInt("MenuItemID"));
                    mi.setName(rs.getString("ItemName"));
                    mi.setDescription(rs.getString("Description"));
                    mi.setCategory(rs.getString("Category"));
                    mi.setStatus(rs.getString("MenuStatus"));
                    mi.setImagePath(rs.getString("ImagePath"));
                    mi.setCategoryId(rs.getInt("CategoryID"));

                    isp.setMenuItem(mi);
                    list.add(isp);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // 🧾 Lấy công thức theo ItemSizePriceID
    public Recipe getRecipeByItemSizePrice(int itemSizePriceId) {
        Recipe recipe = null;
        String sql = "SELECT * FROM Recipe WHERE ItemSizePriceID = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, itemSizePriceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    recipe = new Recipe();
                    recipe.setRecipeID(rs.getInt("RecipeID"));
                    recipe.setItemSizePriceID(itemSizePriceId);
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

    // 📋 Lấy chi tiết công thức
    public List<RecipeDetail> getRecipeDetails(int recipeId) {
        List<RecipeDetail> list = new ArrayList<>();

        String sql = """
            SELECT rd.RecipeDetailID, rd.RecipeID, rd.IngredientID, rd.Quantity,
                   i.Name AS IngredientName, i.Unit
            FROM RecipeDetail rd
            JOIN Ingredients i ON rd.IngredientID = i.id
            WHERE rd.RecipeID = ?
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

    // ➕ Thêm công thức kèm chi tiết
    public int addRecipeWithDetails(int itemSizePriceId, String description, List<RecipeDetail> details) {
        int recipeId = -1;
        String insertRecipeSQL = "INSERT INTO Recipe (ItemSizePriceID, Description, CreateDate) VALUES (?, ?, GETDATE())";
        String insertDetailSQL = "INSERT INTO RecipeDetail (RecipeID, IngredientID, Quantity) VALUES (?, ?, ?)";

        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(insertRecipeSQL, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, itemSizePriceId);
                ps.setString(2, description);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) recipeId = rs.getInt(1);
                }
            }

            if (recipeId > 0 && details != null) {
                try (PreparedStatement ps = conn.prepareStatement(insertDetailSQL)) {
                    for (RecipeDetail d : details) {
                        ps.setInt(1, recipeId);
                        ps.setInt(2, d.getIngredientID());
                        ps.setDouble(3, d.getQuantity());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            conn.commit();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return recipeId;
    }

    // ✏️ Cập nhật số lượng nguyên liệu
    public void updateIngredientQuantity(int recipeDetailId, double quantity) {
        String sql = "UPDATE RecipeDetail SET Quantity = ? WHERE RecipeDetailID = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(sql1);
                 PreparedStatement ps2 = conn.prepareStatement(sql2)) {

                ps1.setInt(1, recipeId);
                ps1.executeUpdate();

                ps2.setInt(1, recipeId);
                ps2.executeUpdate();

                conn.commit();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 📦 Lấy ItemSizePriceID đã có công thức
    public List<Integer> getItemsWithRecipeID() {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT ItemSizePriceID FROM Recipe";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getInt("ItemSizePriceID"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // ➕ Thêm nguyên liệu vào công thức hiện có
    public void addIngredientToRecipe(int recipeId, int ingredientId, double quantity) {
        String sql = "INSERT INTO RecipeDetail (RecipeID, IngredientID, Quantity) VALUES (?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(updateDescSQL)) {
                ps.setString(1, description);
                ps.setInt(2, recipeId);
                ps.executeUpdate();
            }

            if (updatedDetails != null) {
                try (PreparedStatement ps = conn.prepareStatement(updateDetailSQL)) {
                    for (RecipeDetail d : updatedDetails) {
                        ps.setDouble(1, d.getQuantity());
                        ps.setInt(2, d.getRecipeDetailID());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            if (deletedDetailIds != null) {
                try (PreparedStatement ps = conn.prepareStatement(deleteDetailSQL)) {
                    for (int id : deletedDetailIds) {
                        ps.setInt(1, id);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            if (newDetails != null) {
                try (PreparedStatement ps = conn.prepareStatement(insertDetailSQL)) {
                    for (RecipeDetail d : newDetails) {
                        ps.setInt(1, recipeId);
                        ps.setInt(2, d.getIngredientID());
                        ps.setDouble(3, d.getQuantity());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            conn.commit();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
