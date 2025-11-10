package model;

public class MenuItem {

    private int id;             // ItemID
    private String name;
    private String description; // ✅ thiếu trong model
    private double price;
    private String category;
    private String status;      // ✅ thiếu trong model
    private String imagePath;
    private int categoryId;     // ✅ thiếu trong model

    public MenuItem() {
    }

    public MenuItem(int id, String name, String description, double price, 
                    String category, String status, String imagePath, int categoryId) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.category = category;
        this.status = status;
        this.imagePath = imagePath;
        this.categoryId = categoryId;
    }

    // Getter – Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

}
