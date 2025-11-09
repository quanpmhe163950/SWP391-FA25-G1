/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
public class Category {
    private int categoryID;
    private String categoryName;
    private String description;
    private String status;

    public Category() {}

    public Category(int categoryID, String categoryName, String description, String status) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.description = description;
        this.status = status;
    }

    public int getCategoryID() {
        return categoryID;
    }
    
    public String getCategoryName() {
        return categoryName;
    }

    public String getDescription() {
        return description;
    }
    
    public String getStatus() {
        return status;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
