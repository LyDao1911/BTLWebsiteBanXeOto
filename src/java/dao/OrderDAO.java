/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Car;
import model.Order;

/**
 *
 * @author Hong Ly
 */
public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    // 1. insertOrder: Khôi phục SQL 6 cột
    public boolean insertOrder(Order order) {
        String sql = "INSERT INTO `order` (CustomerID, OrderDate, TotalAmount, PaymentStatus, DeliveryStatus, Note) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, order.getCustomerID());
            ps.setTimestamp(2, Timestamp.valueOf(order.getOrderDate()));
            ps.setBigDecimal(3, order.getTotalAmount());
            ps.setString(4, order.getPaymentStatus());
            ps.setString(5, order.getDeliveryStatus());
            ps.setString(6, order.getNote()); // Lưu ý: Cột này sẽ chứa thông tin người nhận

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. insertOrderAndReturnId: Khôi phục SQL 6 cột
    public int insertOrderAndReturnId(Order order) {
        String sql = "INSERT INTO `order` (CustomerID, OrderDate, TotalAmount, PaymentStatus, DeliveryStatus, Note) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        int generatedOrderID = -1;

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getCustomerID());
            ps.setTimestamp(2, Timestamp.valueOf(order.getOrderDate()));
            ps.setBigDecimal(3, order.getTotalAmount());
            ps.setString(4, order.getPaymentStatus());
            ps.setString(5, order.getDeliveryStatus());
            ps.setString(6, order.getNote()); // Lưu ý: Cột này sẽ chứa thông tin người nhận

            ps.executeUpdate();

            // ... (Phần lấy ID giữ nguyên)
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedOrderID = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi chèn Order và lấy ID.", e);
        }
        return generatedOrderID;
    }

    // 3. insertOrderDetail: Giữ nguyên
    public boolean insertOrderDetail(int orderID, int carID, int quantity, BigDecimal priceAtOrder) {
        // ... (Giữ nguyên)
        String sql = "INSERT INTO `orderdetail` (OrderID, CarID, Quantity, PriceAtOrder) "
                + "VALUES (?, ?, ?, ?)";
        // ...
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            ps.setInt(2, carID);
            ps.setInt(3, quantity);
            ps.setBigDecimal(4, priceAtOrder);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi chèn Order Detail cho OrderID: " + orderID, e);
            return false;
        }
    }

    // 4. getOrderById: Khôi phục SQL 6 cột (chỉ đọc)
    public Order getOrderById(int id) {
        String sql = "SELECT * FROM `order` WHERE OrderID = ?";
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Order o = new Order();
                o.setOrderID(rs.getInt("OrderID"));
                o.setCustomerID(rs.getInt("CustomerID"));
                o.setOrderDate(rs.getTimestamp("OrderDate").toLocalDateTime());
                o.setTotalAmount(rs.getBigDecimal("TotalAmount"));

                // Chỉ đọc 6 cột gốc
                o.setPaymentStatus(rs.getString("PaymentStatus"));
                o.setDeliveryStatus(rs.getString("DeliveryStatus"));
                o.setNote(rs.getString("Note"));

                return o;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 5. updatePaymentStatusInOrder: SỬA orderId từ String thành INT
    public boolean updatePaymentStatusInOrder(int orderId, String newStatus) {
        String sql = "UPDATE `order` SET PaymentStatus = ? WHERE OrderID = ?";
        // ...
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId); // ✅ SỬA: Dùng setInt cho OrderID
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("LỖI SQL KHI CẬP NHẬT TRẠNG THÁI PAYMENT TRONG BẢNG ORDER:");
            ex.printStackTrace();
            return false;
        }
    }

    // 6. updateDeliveryStatus: SỬA orderId từ String thành INT
    public boolean updateDeliveryStatus(int orderId, String newStatus) {
        String sql = "UPDATE `order` SET DeliveryStatus = ? WHERE OrderID = ?";
        // ...
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId); // ✅ SỬA: Dùng setInt cho OrderID
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("LỖI SQL KHI CẬP NHẬT TRẠNG THÁI DELIVERY TRONG BẢNG ORDER:");
            ex.printStackTrace();
            return false;
        }
    }

    // 7. createOrderWithDetails: KHÔI PHỤC SQL 6 CỘT
    public int createOrderWithDetails(Order order, List<Car> itemsToCheckout) {
        Connection con = null;
        int generatedOrderID = -1;

        try {
            con = Connect.getCon();
            con.setAutoCommit(false);

            // Khôi phục SQL chỉ với 6 cột gốc
            String insertOrderSQL = "INSERT INTO `order` (CustomerID, OrderDate, TotalAmount, PaymentStatus, DeliveryStatus, Note) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement psOrder = con.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {

                psOrder.setInt(1, order.getCustomerID());
                psOrder.setTimestamp(2, Timestamp.valueOf(order.getOrderDate()));
                psOrder.setBigDecimal(3, order.getTotalAmount());
                psOrder.setString(4, order.getPaymentStatus());
                psOrder.setString(5, order.getDeliveryStatus());
                psOrder.setString(6, order.getNote()); // Lưu ý: Cột này chứa tất cả thông tin bổ sung

                psOrder.executeUpdate();

                // ... (Phần lấy ID giữ nguyên)
                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedOrderID = rs.getInt(1);
                    } else {
                        throw new SQLException("Không thể lấy OrderID tự sinh.");
                    }
                }
            }

            // ... (Phần chèn Order Details giữ nguyên)
            String insertDetailSQL = "INSERT INTO `orderdetail` (OrderID, CarID, Quantity, PriceAtOrder) "
                    + "VALUES (?, ?, ?, ?)";

            try (PreparedStatement psDetail = con.prepareStatement(insertDetailSQL)) {
                for (Car car : itemsToCheckout) {
                    BigDecimal pricePerUnit = car.getPrice();
                    BigDecimal totalItemPrice = pricePerUnit.multiply(new BigDecimal(car.getQuantity()));

                    psDetail.setInt(1, generatedOrderID);
                    psDetail.setInt(2, car.getCarID());
                    psDetail.setInt(3, car.getQuantity());
                    psDetail.setBigDecimal(4, totalItemPrice);

                    psDetail.addBatch();
                }

                psDetail.executeBatch();
            }

            con.commit();
            return generatedOrderID;

        } catch (SQLException e) {
            // ... (Phần Rollback và Logging giữ nguyên)
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi Rollback.", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo Order và OrderDetail.", e);
            return -1;
        } finally {
            // ... (Phần đóng Connection giữ nguyên)
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi đóng Connection.", ex);
                }
            }
        }
    }
    // 8. Cập nhật trạng thái thanh toán (gọi khi xác nhận OTP thành công)

    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE `order` SET PaymentStatus = ? WHERE OrderID = ?";
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật trạng thái thanh toán cho OrderID " + orderId, e);
            return false;
        }
    }
}
