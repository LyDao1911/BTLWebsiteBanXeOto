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

    private BigDecimal price; // Dùng BigDecimal

    private BigDecimal subtotal;

    private String carImage; // ⭐ BỔ SUNG



    public String getCarImage() {

        return carImage;

    }



    public void setCarImage(String carImage) {

        this.carImage = carImage;

    }

    // ⭐ ĐÃ THÊM: Thuộc tính Tên Xe để lưu trữ kết quả JOIN từ DAO

    private String carName;



    public OrderDetail() {

    }



    // Constructor ĐÃ CẬP NHẬT để bao gồm carName

    public OrderDetail(int orderDetailID, int orderID, int carID, int quantity, String userName, BigDecimal price, BigDecimal subtotal, String carName) {

        this.orderDetailID = orderDetailID;

        this.orderID = orderID;

        this.carID = carID;

        this.quantity = quantity;

        this.userName = userName;

        this.price = price;

        this.subtotal = subtotal;

        this.carName = carName; // Khởi tạo tên xe

    }



    // --- GETTER/SETTER CHO CARNAME (ĐÃ THÊM) ---

    public String getCarName() {

        return carName;

    }



    public void setCarName(String carName) {

        this.carName = carName;

    }

    // ---------------------------------------------



    // --- Các Getter/Setter khác (Giữ nguyên) ---

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



    // toString() ĐÃ CẬP NHẬT để bao gồm carName

    @Override

    public String toString() {

        return "OrderDetail{" + "orderDetailID=" + orderDetailID + ", orderID=" + orderID + ", carID=" + carID + ", quantity=" + quantity + ", userName=" + userName + ", price=" + price + ", subtotal=" + subtotal + ", carName=" + carName + '}';

    }

}