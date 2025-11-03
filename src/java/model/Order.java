package model;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List; // ⭐ Cần Import List

/**
 *
 * @author Hong Ly
 */
public class Order {
    private int orderID;
    private int customerID;
    private LocalDateTime orderDate; 
    private BigDecimal totalAmount; 
    private String paymentStatus;
    private String deliveryStatus;
    private String note;
    
    // ⭐ BỔ SUNG: Thuộc tính chứa danh sách chi tiết đơn hàng
    private List<OrderDetail> orderDetails; 

    public Order() {
    }

    public Order(int orderID, int customerID, LocalDateTime orderDate, BigDecimal totalAmount, String paymentStatus, String deliveryStatus, String note) {
        this.orderID = orderID;
        this.customerID = customerID;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.paymentStatus = paymentStatus;
        this.deliveryStatus = deliveryStatus;
        this.note = note;
    }
    
    // ⭐ BỔ SUNG: Getter và Setter cho OrderDetails
    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }
    // ⭐ KẾT THÚC BỔ SUNG

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    @Override
    public String toString() {
        return "Order{" + "orderID=" + orderID + ", customerID=" + customerID + ", orderDate=" + orderDate + ", totalAmount=" + totalAmount + ", paymentStatus=" + paymentStatus + ", deliveryStatus=" + deliveryStatus + ", note=" + note + '}';
    }
    
}