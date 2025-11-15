package model;

import java.util.Date;

public class OrderHistory {
private String orderCode;
    private Date orderDate;
    private String itemName;
    private int totalQuantity;
    private double amount;
    private String paymentMethod;
    private String orderStatus;
    private String itemList;

    public OrderHistory() {
    }

    public OrderHistory(String orderCode, Date orderDate, String itemName, int quantity, double amount, String paymentMethod, String orderStatus) {
        this.orderCode = orderCode;
        this.orderDate = orderDate;
        this.itemName = itemName;
        this.totalQuantity= quantity;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.orderStatus = orderStatus;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
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

    public int getQuantity() {
        return totalQuantity;
    }

    public void setQuantity(int quantity) {
        this.totalQuantity = quantity;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getItemList() {
        return itemList;
    }

    public void setItemList(String itemList) {
        this.itemList = itemList;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }
    
}
