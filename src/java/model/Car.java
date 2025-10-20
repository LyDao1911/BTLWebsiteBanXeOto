/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.math.BigDecimal;
/**
 *
 * @author Hong Ly
 */
public class Car {
    private int carID;
    private String carName;
    private int brandID;        // Khóa ngoại liên kết tới Brand.java
    private BigDecimal price;   // Dùng BigDecimal cho tiền tệ
    private String color;
    private String description;
    private String status;

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

    @Override
    public String toString() {
        return "Car{" + "carID=" + carID + ", carName=" + carName + ", brandID=" + brandID + ", price=" + price + ", color=" + color + ", description=" + description + ", status=" + status + '}';
    }

}
