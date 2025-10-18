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
public class OrderDetail {
    private int orderDetailID;
    private int orderID;
    private int carID;
    private int quantity;
    private String userName;
    private BigDecimal price;   // Dùng BigDecimal
    private BigDecimal subtotal;

    public OrderDetail() {
    }

    public OrderDetail(int orderDetailID, int orderID, int carID, int quantity, String userName, BigDecimal price, BigDecimal subtotal) {
        this.orderDetailID = orderDetailID;
        this.orderID = orderID;
        this.carID = carID;
        this.quantity = quantity;
        this.userName = userName;
        this.price = price;
        this.subtotal = subtotal;
    }

    public int getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(int orderDetailID) {
        this.orderDetailID = orderDetailID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    @Override
    public String toString() {
        return "OrderDetail{" + "orderDetailID=" + orderDetailID + ", orderID=" + orderID + ", carID=" + carID + ", quantity=" + quantity + ", userName=" + userName + ", price=" + price + ", subtotal=" + subtotal + '}';
    }
    
}
