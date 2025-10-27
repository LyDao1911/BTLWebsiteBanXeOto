/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.View;

import java.math.BigDecimal;
/**
 *
 * @author Hong Ly
 */
public class CarDetailView {
    private int carID;
    private String carName;
    private int brandID;
    private String brandName; // Lấy từ bảng Brand
    private BigDecimal price;
    private String color;
    private int quantity;    // Lấy từ bảng CarStock
    private String description;
    private String status;

    public CarDetailView() {
    }

    public CarDetailView(int carID, String carName, int brandID, String brandName, BigDecimal price, String color, int quantity, String description, String status) {
        this.carID = carID;
        this.carName = carName;
        this.brandID = brandID;
        this.brandName = brandName;
        this.price = price;
        this.color = color;
        this.quantity = quantity;
        this.description = description;
        this.status = status;
    }

    public int getCarID() {
        return carID;
    }

    public void setCarID(int carID) {
        this.carID = carID;
    }

    public String getCarName() {
        return carName;
    }

    public void setCarName(String carName) {
        this.carName = carName;
    }

    public int getBrandID() {
        return brandID;
    }

    public void setBrandID(int brandID) {
        this.brandID = brandID;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "CarDetailView{" + "carID=" + carID + ", carName=" + carName + ", brandID=" + brandID + ", brandName=" + brandName + ", price=" + price + ", color=" + color + ", quantity=" + quantity + ", description=" + description + ", status=" + status + '}';
    }
    
}
