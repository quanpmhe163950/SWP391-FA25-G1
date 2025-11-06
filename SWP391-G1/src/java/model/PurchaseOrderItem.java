package model;

public class PurchaseOrderItem {
    private int purchaseOrderItemID;
    private int purchaseOrderID;
    private int ingredientID;

    private double unitQuantity;
    private String unitType;

    private double subQuantityPerUnit;
    private String subUnit;

    private String weightPerSubUnit;

    private double pricePerUnit;

    private double quantityReceivedUnits;
    private double quantityReceivedSubUnits;

    private double totalPrice; // lấy từ view SELECT, không tự set

    // GETTER + SETTER

    public int getPurchaseOrderItemID() {
        return purchaseOrderItemID;
    }

    public void setPurchaseOrderItemID(int purchaseOrderItemID) {
        this.purchaseOrderItemID = purchaseOrderItemID;
    }

    public int getPurchaseOrderID() {
        return purchaseOrderID;
    }

    public void setPurchaseOrderID(int purchaseOrderID) {
        this.purchaseOrderID = purchaseOrderID;
    }

    public int getIngredientID() {
        return ingredientID;
    }

    public void setIngredientID(int ingredientID) {
        this.ingredientID = ingredientID;
    }

    public double getUnitQuantity() {
        return unitQuantity;
    }

    public void setUnitQuantity(double unitQuantity) {
        this.unitQuantity = unitQuantity;
    }

    public String getUnitType() {
        return unitType;
    }

    public void setUnitType(String unitType) {
        this.unitType = unitType;
    }

    public double getSubQuantityPerUnit() {
        return subQuantityPerUnit;
    }

    public void setSubQuantityPerUnit(double subQuantityPerUnit) {
        this.subQuantityPerUnit = subQuantityPerUnit;
    }

    public String getSubUnit() {
        return subUnit;
    }

    public void setSubUnit(String subUnit) {
        this.subUnit = subUnit;
    }

    public String getWeightPerSubUnit() {
        return weightPerSubUnit;
    }

    public void setWeightPerSubUnit(String weightPerSubUnit) {
        this.weightPerSubUnit = weightPerSubUnit;
    }

    public double getPricePerUnit() {
        return pricePerUnit;
    }

    public void setPricePerUnit(double pricePerUnit) {
        this.pricePerUnit = pricePerUnit;
    }

    public double getQuantityReceivedUnits() {
        return quantityReceivedUnits;
    }

    public void setQuantityReceivedUnits(double quantityReceivedUnits) {
        this.quantityReceivedUnits = quantityReceivedUnits;
    }

    public double getQuantityReceivedSubUnits() {
        return quantityReceivedSubUnits;
    }

    public void setQuantityReceivedSubUnits(double quantityReceivedSubUnits) {
        this.quantityReceivedSubUnits = quantityReceivedSubUnits;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    // totalPrice là computed column → không dùng setter

    public void setTotalPrice(double totalPrice) {
    this.totalPrice = totalPrice;
}
}
