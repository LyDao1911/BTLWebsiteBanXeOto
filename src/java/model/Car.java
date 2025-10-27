/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.List;

/**
 *
 * @author Hong Ly
 */
public class Car {

    private int carID;
    private String carName;
    private int brandID;        // Khóa ngoại liên kết tới Brand.java
    private String brandName; // Tên hãng xe - lấy từ bảng Brand

    private BigDecimal price;   // Dùng BigDecimal cho tiền tệ
    private String color;
    private String description;
    private String status;
    private int quantity;
    private String mainImageURL;

    // Danh sách ảnh phụ (thumbs)
    private List<String> thumbs;

    public Car() {
    }

    public Car(int carID, String carName, int brandID, BigDecimal price, String color, String description, String status) {
        this.carID = carID;
        this.carName = carName;
        this.brandID = brandID;
        this.price = price;
        this.color = color;
        this.description = description;
        this.status = status;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getMainImageURL() {
        return mainImageURL;
    }

    public void setMainImageURL(String mainImageURL) {
        this.mainImageURL = mainImageURL;
    }

    public List<String> getThumbs() {
        return thumbs;
    }

    public void setThumbs(List<String> thumbs) {
        this.thumbs = thumbs;
    }

    @Override
    public String toString() {
        return "Car{"
                + "carID=" + carID
                + ", carName=" + carName
                + ", brandID=" + brandID
                + ", price=" + price
                + ", color=" + color
                + ", description=" + description
                + ", status=" + status
                + ", quantity=" + quantity
                + ", mainImageURL=" + mainImageURL
                + ", thumbs=" + thumbs
                + '}';
    }
}
