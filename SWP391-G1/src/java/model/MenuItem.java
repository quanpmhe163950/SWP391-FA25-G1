package model;

public class MenuItem {
    private int itemID;
    private String name;
    private String description;
    private double price;
    private String category;
    private boolean status;

    public MenuItem() {
    }

    public MenuItem(int itemID, String name, String description, double price, String category, boolean status) {
        this.itemID = itemID;
        this.name = name;
        this.description = description;
        this.price = price;
        this.category = category;
        this.status = status;
    }

    public int getItemID() {
        return itemID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
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

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "MenuItem{" +
                "itemID=" + itemID +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", category='" + category + '\'' +
                ", status=" + status +
                '}';
    }
}
