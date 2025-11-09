/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Hong Ly
 */
public class ProductReportDTO {
    private String carName;
    private int totalSold;

    public ProductReportDTO() {
    }

    public ProductReportDTO(String carName, int totalSold) {
        this.carName = carName;
        this.totalSold = totalSold;
    }

    public String getCarName() {
        return carName;
    }

    public void setCarName(String carName) {
        this.carName = carName;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(int totalSold) {
        this.totalSold = totalSold;
    }
    
}
