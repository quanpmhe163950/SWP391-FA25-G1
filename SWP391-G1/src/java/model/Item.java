/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

public class Item {
    private int itemID;
    private String name;
    private String description;
    private int categoryID;
    private String status;
    private String imagePath;
    private List<ItemSizePrice> sizePriceList;

    public Item() {
    }

    public Item(String name, String description, int categoryID, String status, String imagePath) {
        this.name = name;
        this.description = description;
        this.categoryID = categoryID;
        this.status = status;
        this.imagePath = imagePath;
    }

    public Item(int itemID, String name, String description, int categoryID, String status, String imagePath) {
        this.itemID = itemID;
        this.name = name;
        this.description = description;
        this.categoryID = categoryID;
        this.status = status;
        this.imagePath = imagePath;
    }

    public Item(int itemID, String name, int categoryID, String status) {
        this.itemID = itemID;
        this.name = name;
        this.categoryID = categoryID;
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

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
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

    public List<ItemSizePrice> getSizePriceList() {
        return sizePriceList;
    }

    public void setSizePriceList(List<ItemSizePrice> sizePriceList) {
        this.sizePriceList = sizePriceList;
    }
}