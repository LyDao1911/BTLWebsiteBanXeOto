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
public class Payment {
    private int paymentID;
    private int orderID;
    private String paymentMethod;
    private LocalDateTime paymentDate; // Sử dụng LocalDateTime
    private BigDecimal amount;        // Sử dụng BigDecimal
    private String status;

    public Payment() {
    }

    public Payment(int paymentID, int orderID, String paymentMethod, LocalDateTime paymentDate, BigDecimal amount, String status) {
        this.paymentID = paymentID;
        this.orderID = orderID;
        this.paymentMethod = paymentMethod;
        this.paymentDate = paymentDate;
        this.amount = amount;
        this.status = status;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Payment{" + "paymentID=" + paymentID + ", orderID=" + orderID + ", paymentMethod=" + paymentMethod + ", paymentDate=" + paymentDate + ", amount=" + amount + ", status=" + status + '}';
    }
    
}
