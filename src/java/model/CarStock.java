/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.time.LocalDateTime;
/**
 *
 * @author Hong Ly
 */
public class CarStock {
   private int stockID;
    private int brandID;
    private int carID;
    private int quantity;
    private LocalDateTime lastUpdated;

    public CarStock() {
    }

    public CarStock(int stockID, int brandID, int carID, int quantity, LocalDateTime lastUpdated) {
        this.stockID = stockID;
        this.brandID = brandID;
        this.carID = carID;
        this.quantity = quantity;
        this.lastUpdated = lastUpdated;
    }

    public int getStockID() {
        return stockID;
    }

    public void setStockID(int stockID) {
        this.stockID = stockID;
    }

    public int getBrandID() {
        return brandID;
    }

    public void setBrandID(int brandID) {
        this.brandID = brandID;
    }

    public int getCarID() {
        return carID;
    }

    public void setCarID(int carID) {
        this.carID = carID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    @Override
    public String toString() {
        return "CarStock{" + "stockID=" + stockID + ", brandID=" + brandID + ", carID=" + carID + ", quantity=" + quantity + ", lastUpdated=" + lastUpdated + '}';
    }
    
}
