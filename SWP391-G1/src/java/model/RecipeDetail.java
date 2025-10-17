package model;

public class RecipeDetail {
    private int recipeDetailID;
    private int recipeID;
    private int ingredientID;
    private double quantity;

    // Thông tin thêm khi join bảng Ingredients
    private String ingredientName;
    private String unit;

    public RecipeDetail() {
    }

    public RecipeDetail(int recipeDetailID, int recipeID, int ingredientID, double quantity) {
        this.recipeDetailID = recipeDetailID;
        this.recipeID = recipeID;
        this.ingredientID = ingredientID;
        this.quantity = quantity;
    }

    public int getRecipeDetailID() {
        return recipeDetailID;
    }

    public void setRecipeDetailID(int recipeDetailID) {
        this.recipeDetailID = recipeDetailID;
    }

    public int getRecipeID() {
        return recipeID;
    }

    public void setRecipeID(int recipeID) {
        this.recipeID = recipeID;
    }

    public int getIngredientID() {
        return ingredientID;
    }

    public void setIngredientID(int ingredientID) {
        this.ingredientID = ingredientID;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public String getIngredientName() {
        return ingredientName;
    }

    public void setIngredientName(String ingredientName) {
        this.ingredientName = ingredientName;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }
}
