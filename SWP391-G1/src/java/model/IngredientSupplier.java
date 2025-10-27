package model;

import java.sql.Date;

public class IngredientSupplier {
    private int id;
    private int supplierID;
    private int ingredientID;
    private double price;
    private Date lastUpdated;

    // Liên kết đối tượng để JSP hiển thị thông tin rõ hơn
    private Supplier supplier;
    private Ingredient ingredient;

    // --- Constructors ---
    public IngredientSupplier() {}

    public IngredientSupplier(int id, int supplierID, int ingredientID, double price, Date lastUpdated) {
        this.id = id;
        this.supplierID = supplierID;
        this.ingredientID = ingredientID;
        this.price = price;
        this.lastUpdated = lastUpdated;
    }

    // --- Getters & Setters ---
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(int supplierID) {
        this.supplierID = supplierID;
    }

    public int getIngredientID() {
        return ingredientID;
    }

    public void setIngredientID(int ingredientID) {
        this.ingredientID = ingredientID;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Date getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }

    public Ingredient getIngredient() {
        return ingredient;
    }

    public void setIngredient(Ingredient ingredient) {
        this.ingredient = ingredient;
    }

    @Override
    public String toString() {
        return "IngredientSupplier{" +
                "id=" + id +
                ", supplierID=" + supplierID +
                ", ingredientID=" + ingredientID +
                ", price=" + price +
                ", lastUpdated=" + lastUpdated +
                ", supplier=" + (supplier != null ? supplier.getSupplierName() : "null") +
                ", ingredient=" + (ingredient != null ? ingredient.getName() : "null") +
                '}';
    }
}
