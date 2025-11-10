package model;

public class MenuItem {

    private int itemID;
    private String name;
    private String description;
    private double price;
    private String category;
    private String status;
    private String imagePath;
    private int categoryID;

    // Constructor
    public MenuItem(int itemID, String name, String description, double price,
            String category, String status, String imagePath, int categoryID) {
        this.itemID = itemID;
        this.name = name;
        this.description = description;
        this.price = price;
        this.category = category;
        this.status = status;
        this.imagePath = imagePath;
        this.categoryID = categoryID;
    }

    public MenuItem() {
    }
    

    // Getter & Setter
    public int getItemID() {
        return itemID;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public double getPrice() {
        return price;
    }

    public String getCategory() {
        return category;
    }

    public String getStatus() {
        return status;
    }

    public String getImagePath() {
        return imagePath;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }
}
