/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 *
 * @author Hong Ly
 */
public class PurchaseInvoice {

    private int invoiceID;
    private int supplierID; 
    private LocalDateTime invoiceDate;
    private BigDecimal totalAmount;

    public PurchaseInvoice() {
    }

    public PurchaseInvoice(int invoiceID, int supplierID, LocalDateTime invoiceDate, BigDecimal totalAmount) {
        this.invoiceID = invoiceID;
        this.supplierID = supplierID;
        this.invoiceDate = invoiceDate;
        this.totalAmount = totalAmount;
    }

    public int getInvoiceID() {
        return invoiceID;
    }

    public void setInvoiceID(int invoiceID) {
        this.invoiceID = invoiceID;
    }

    public int getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(int supplierID) {
        this.supplierID = supplierID;
    }

    public LocalDateTime getInvoiceDate() {
        return invoiceDate;
    }

    public void setInvoiceDate(LocalDateTime invoiceDate) {
        this.invoiceDate = invoiceDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    @Override
    public String toString() {
        return "PurchaseInvoice{" + "invoiceID=" + invoiceID + ", supplierID=" + supplierID + ", invoiceDate=" + invoiceDate + ", totalAmount=" + totalAmount + '}';
    }
    
    
}
