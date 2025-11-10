/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class ItemSizePrice {
    private int id;
    private int itemID;
    private String size;
    private double price;
    private String status;
    private MenuItem menuItem; // ✅ thêm object MenuItem để mapping, KHÔNG thay đổi DB
    
    public ItemSizePrice() {
    }

    public ItemSizePrice(int id, int itemID, String size, double price, String status) {
        this.id = id;
        this.itemID = itemID;
        this.size = size;
        this.price = price;
        this.status = status;
    }
    
    public ItemSizePrice(int id, int itemID, String size, double price) {
        this.id = id;
        this.itemID = itemID;
        this.size = size;
        this.price = price;
        this.status = "Regular";
    }

    public ItemSizePrice(int itemID, String size, double price, String status) {
        this.itemID = itemID;
        this.size = size;
        this.price = price;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getItemID() {
        return itemID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public MenuItem getMenuItem() {
        return menuItem;
    }

    public void setMenuItem(MenuItem menuItem) {
        this.menuItem = menuItem;
    }
    
}