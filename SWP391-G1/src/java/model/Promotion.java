/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.Date;

import java.util.Date;


public class Promotion {

    private int promoId;
    private String code;
    private String description;
    private String discountType; // "PERCENT" hoặc "FIXED"
   private BigDecimal value;
    private Date startDate;
    private Date endDate;
    private String status;
    private String applyCondition;// "ACTIVE", "INACTIVE", "EXPIRED"

    // Constructors

    public Promotion() {
    }

    public Promotion(int promoId, String code, String description, String discountType, BigDecimal value, Date startDate, Date endDate, String status, String applyCondition) {
        this.promoId = promoId;
        this.code = code;
        this.description = description;
        this.discountType = discountType;
        this.value = value;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.applyCondition = applyCondition;
    }

    public String getApplyCondition() {
        return applyCondition;
    }

    public void setApplyCondition(String applyCondition) {
        this.applyCondition = applyCondition;
    }
    

    // Getters and Setters
    public int getPromoId() {
        return promoId;
    }

    public void setPromoId(int promoId) {
        this.promoId = promoId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getValue() {
        return value;
    }

    public void setValue(BigDecimal value) {
        this.value = value;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
