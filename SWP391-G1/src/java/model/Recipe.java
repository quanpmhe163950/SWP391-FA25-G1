package model;

import java.util.Date;
import java.util.List;

public class Recipe {
    private int recipeID;
    private int itemID;
    private String description;
    private Date createDate;

    // Danh sách chi tiết công thức (một recipe có nhiều RecipeDetail)
    private List<RecipeDetail> details;

    public Recipe() {
    }

    public Recipe(int recipeID, int itemID, String description, Date createDate) {
        this.recipeID = recipeID;
        this.itemID = itemID;
        this.description = description;
        this.createDate = createDate;
    }

    public int getRecipeID() {
        return recipeID;
    }

    public void setRecipeID(int recipeID) {
        this.recipeID = recipeID;
    }

    public int getItemID() {
        return itemID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public List<RecipeDetail> getDetails() {
        return details;
    }

    public void setDetails(List<RecipeDetail> details) {
        this.details = details;
    }
}
