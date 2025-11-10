package model;

import java.util.Date;

public class OrderHistory {

    private int orderID;
    private Date orderDate;
    private String itemName;
    private double totalPrice;
    private int itemID;
    private Integer rating;
    public OrderHistory() {
    }

    public OrderHistory(int orderID, Date orderDate, String itemName, double totalPrice, int itemID) {
        this.orderID = orderID;
        this.orderDate = orderDate;
        this.itemName = itemName;
        this.totalPrice = totalPrice;
        this.itemID = itemID;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public Integer getRating() {
        return rating;
    }

   
    
    public int getItemID() {
        return itemID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }
    
    // Getters & Setters
    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }
}
