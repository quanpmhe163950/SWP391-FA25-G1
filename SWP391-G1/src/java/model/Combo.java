package model;

import java.io.Serializable;

public class Combo implements Serializable {
    private int comboID;
    private String comboName;
    private String description;
    private double price;
    private String imagePath;
    private String status;

    public Combo() {}

    public Combo(int comboID, String comboName, String description, double price, String imagePath, String status) {
        this.comboID = comboID;
        this.comboName = comboName;
        this.description = description;
        this.price = price;
        this.imagePath = imagePath;
        this.status = status;
    }

    public int getComboID() { return comboID; }
    public void setComboID(int comboID) { this.comboID = comboID; }

    public String getComboName() { return comboName; }
    public void setComboName(String comboName) { this.comboName = comboName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return "Combo{" +
                "comboID=" + comboID +
                ", comboName='" + comboName + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", imagePath='" + imagePath + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
