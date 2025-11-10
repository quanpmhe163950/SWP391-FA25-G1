package model;

import java.sql.Timestamp;

public class Review {

    private int reviewID;
    private int customerID;
    private int itemID;
    private int rating;
    private String comment;
    private Timestamp reviewDate;
    private String customerName;
    private String itemName;

    public Review(int reviewID, int customerID, int itemID, int rating, String comment, Timestamp reviewDate) {
        this.reviewID = reviewID;
        this.customerID = customerID;
        this.itemID = itemID;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
    }

    public int getReviewID() {
        return reviewID;
    }

    public void setReviewID(int reviewID) {
        this.reviewID = reviewID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getItemID() {
        return itemID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }

    @Override
    public String toString() {
        return "Review{"
                + "reviewID=" + reviewID
                + ", customerID=" + customerID
                + ", itemID=" + itemID
                + ", rating=" + rating
                + ", comment='" + comment + '\''
                + ", reviewDate=" + reviewDate
                + '}';
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

}
