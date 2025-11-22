package model;

import java.sql.Timestamp;

public class Order {

    private int orderID;
    private int customerID;
    private int waiterID;
    private Timestamp orderDate;
    private String status;
    private int promoID;
    private String orderCode;

    public Order() {
    }

    public Order(int orderID, int customerID, int waiterID, Timestamp orderDate,
                 String status, int promoID, String orderCode) {
        this.orderID = orderID;
        this.customerID = customerID;
        this.waiterID = waiterID;
        this.orderDate = orderDate;
        this.status = status;
        this.promoID = promoID;
        this.orderCode = orderCode;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getWaiterID() {
        return waiterID;
    }

    public void setWaiterID(int waiterID) {
        this.waiterID = waiterID;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getPromoID() {
        return promoID;
    }

    public void setPromoID(int promoID) {
        this.promoID = promoID;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }
}
