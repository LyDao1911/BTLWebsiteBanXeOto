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
public class PurchaseInvoiceDetail {
    private int detailID;
    private int invoiceID; // Khóa ngoại
    private int carID;     // Khóa ngoại
    private int quantity;
    private BigDecimal importPrice;
    private BigDecimal subtotal;

    public PurchaseInvoiceDetail() {
    }

    public PurchaseInvoiceDetail(int detailID, int invoiceID, int carID, int quantity, BigDecimal importPrice, BigDecimal subtotal) {
        this.detailID = detailID;
        this.invoiceID = invoiceID;
        this.carID = carID;
        this.quantity = quantity;
        this.importPrice = importPrice;
        this.subtotal = subtotal;
    }

    public int getDetailID() {
        return detailID;
    }

    public void setDetailID(int detailID) {
        this.detailID = detailID;
    }

    public int getInvoiceID() {
        return invoiceID;
    }

    public void setInvoiceID(int invoiceID) {
        this.invoiceID = invoiceID;
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

    public BigDecimal getImportPrice() {
        return importPrice;
    }

    public void setImportPrice(BigDecimal importPrice) {
        this.importPrice = importPrice;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    @Override
    public String toString() {
        return "PurchaseInvoiceDetail{" + "detailID=" + detailID + ", invoiceID=" + invoiceID + ", carID=" + carID + ", quantity=" + quantity + ", importPrice=" + importPrice + ", subtotal=" + subtotal + '}';
    }
    
}
