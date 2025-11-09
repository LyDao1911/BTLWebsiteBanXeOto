/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.Date;
/**
 *
 * @author Hong Ly
 */
public class ReportDTO {
    private Date reportDate;
    private BigDecimal totalRevenue; // Tổng Doanh Thu
    private BigDecimal totalCost;

    public ReportDTO() {
    }

    public ReportDTO(Date reportDate, BigDecimal totalRevenue, BigDecimal totalCost) {
        this.reportDate = reportDate;
        this.totalRevenue = totalRevenue;
        this.totalCost = totalCost;
    }

    
    public Date getReportDate() {
        return reportDate;
    }

    public void setReportDate(Date reportDate) {
        this.reportDate = reportDate;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public BigDecimal getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(BigDecimal totalCost) {
        this.totalCost = totalCost;
    }
    
    public BigDecimal getTotalProfit() {
        if (totalRevenue != null && totalCost != null) {
            return totalRevenue.subtract(totalCost); // Lợi nhuận = Doanh thu - Giá vốn
        }
        return BigDecimal.ZERO;
    }
}
