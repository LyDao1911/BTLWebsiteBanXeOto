package dao;

import java.math.BigDecimal;
import java.sql.*;
import model.Customer;
import model.OrderDetail;
import model.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO {
    
    // ⭐ CHỈ GIỮ LẠI 1 LOGGER
    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    /**
     * Phương thức nội bộ để tạo đối tượng Order từ ResultSet.
     * (GIỮ NGUYÊN LocalDateTime CỦA CẬU)
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderID(rs.getInt("OrderID"));
        order.setCustomerID(rs.getInt("CustomerID"));
        // GIỮ NGUYÊN toLocalDateTime() CỦA CẬU
        order.setOrderDate(rs.getTimestamp("OrderDate").toLocalDateTime()); 
        order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
        order.setPaymentStatus(rs.getString("PaymentStatus"));
        order.setDeliveryStatus(rs.getString("DeliveryStatus"));
        
        // (Bỏ getOrderDetails() ở đây để tránh lỗi N+1 Query)
        
        return order;
    }

    public int getCustomerIDByUsername(String username) {
        // (Giữ nguyên code của cậu)
        String sql = "SELECT CustomerID FROM customer WHERE Username = ?";
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("CustomerID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Order> getAllOrdersByCustomerId(int customerId) {
        // (Giữ nguyên code của cậu, nhưng thêm Load Details)
        String sql = "SELECT * FROM `order` WHERE CustomerID = ? ORDER BY OrderDate DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                List<OrderDetail> details = getOrderDetails(order.getOrderID()); // Load details
                order.setOrderDetails(details);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getOrdersByCustomerIdAndPaymentStatus(int customerId, String status) {
        // (Giữ nguyên code của cậu, nhưng thêm Load Details)
        String sql = "SELECT * FROM `order` WHERE CustomerID = ? AND PaymentStatus = ? ORDER BY OrderDate DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                List<OrderDetail> details = getOrderDetails(order.getOrderID()); // Load details
                order.setOrderDetails(details);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getCompletedOrdersByCustomerId(int customerId) {
        // (Giữ nguyên code của cậu, nhưng thêm Load Details)
        String sql = "SELECT * FROM `order` WHERE CustomerID = ? AND DeliveryStatus = 'Hoàn thành' ORDER BY OrderDate DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                List<OrderDetail> details = getOrderDetails(order.getOrderID()); // Load details
                order.setOrderDetails(details);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getIncompleteOrdersByCustomerId(int customerId) {
        // (Giữ nguyên code của cậu, nhưng thêm Load Details)
        String sql = "SELECT * FROM `order` WHERE CustomerID = ? AND DeliveryStatus != 'Hoàn thành' ORDER BY OrderDate DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                List<OrderDetail> details = getOrderDetails(order.getOrderID()); // Load details
                order.setOrderDetails(details);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // (Giữ nguyên code getOrderDetails của cậu, vì nó đã JOIN ảnh đúng)
    private List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT od.*, c.CarName, ci.ImageURL "
                + "FROM orderdetail od "
                + "JOIN car c ON od.CarID = c.CarID "
                + "LEFT JOIN carimage ci ON c.CarID = ci.CarID AND ci.IsMain = 1 "
                + "WHERE od.OrderID = ?";
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderDetailID(rs.getInt("OrderDetailID"));
                detail.setOrderID(rs.getInt("OrderID"));
                detail.setCarID(rs.getInt("CarID"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setUserName(rs.getString("UserName"));
                detail.setPrice(rs.getBigDecimal("Price"));
                detail.setSubtotal(rs.getBigDecimal("Subtotal"));
                detail.setCarName(rs.getString("CarName"));
                detail.setCarImage(rs.getString("ImageURL")); 
                details.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }

    // (Giữ nguyên các hàm: getOrdersByUser, getOrdersByUserAndPaymentStatus, getOrdersByUserAndDeliveryStatus)
    public List<Order> getOrdersByUser(String username) {
        int customerId = getCustomerIDByUsername(username);
        if (customerId == 0) return new ArrayList<>();
        return getAllOrdersByCustomerId(customerId);
    }
    public List<Order> getOrdersByUserAndPaymentStatus(String username, boolean paid) {
        int customerId = getCustomerIDByUsername(username);
        if (customerId == 0) return new ArrayList<>();
        String status = paid ? "Đã thanh toán" : "Chưa thanh toán";
        return getOrdersByCustomerIdAndPaymentStatus(customerId, status);
    }
    public List<Order> getOrdersByUserAndDeliveryStatus(String username, boolean completed) {
        int customerId = getCustomerIDByUsername(username);
        if (customerId == 0) return new ArrayList<>();
        if (completed) return getCompletedOrdersByCustomerId(customerId);
        else return getIncompleteOrdersByCustomerId(customerId);
    }


    // (Giữ nguyên code createOrderWithDetails của cậu)
    public int createOrderWithDetails(Order order, List<OrderDetail> details) {
        String insertOrder = "INSERT INTO `order` (CustomerID, OrderDate, TotalAmount, PaymentStatus, DeliveryStatus, Note) VALUES (?, ?, ?, ?, ?, ?)";
        String insertDetail = "INSERT INTO orderdetail (OrderID, CarID, Quantity, UserName, Price, Subtotal) VALUES (?, ?, ?, ?, ?, ?)";
        String updateStock = "UPDATE carstock SET Quantity = Quantity - ? WHERE CarID = ?";
        try (Connection conn = Connect.getCon()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getCustomerID());
                // GIỮ NGUYÊN Timestamp.valueOf() CỦA CẬU
                psOrder.setTimestamp(2, Timestamp.valueOf(order.getOrderDate())); 
                psOrder.setBigDecimal(3, order.getTotalAmount());
                psOrder.setString(4, order.getPaymentStatus());
                psOrder.setString(5, order.getDeliveryStatus());
                psOrder.setString(6, order.getNote());
                psOrder.executeUpdate();

                int orderId;
                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    rs.next();
                    orderId = rs.getInt(1);
                }
                try (PreparedStatement psDetail = conn.prepareStatement(insertDetail); PreparedStatement psStock = conn.prepareStatement(updateStock)) {
                    for (OrderDetail d : details) {
                        psDetail.setInt(1, orderId);
                        psDetail.setInt(2, d.getCarID());
                        psDetail.setInt(3, d.getQuantity());
                        psDetail.setString(4, d.getUserName());
                        psDetail.setBigDecimal(5, d.getPrice());
                        psDetail.setBigDecimal(6, d.getSubtotal());
                        psDetail.addBatch();

                        psStock.setInt(1, d.getQuantity());
                        psStock.setInt(2, d.getCarID());
                        psStock.addBatch();
                    }
                    psDetail.executeBatch();
                    psStock.executeBatch();
                }
                conn.commit();
                return orderId;
            } catch (SQLException e) {
                conn.rollback();
                throw e; // Ném lỗi ra ngoài
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    // (Giữ nguyên các hàm: updatePaymentStatus, updateDeliveryStatus, getOrderTotalAmount, getOrderById, getCustomerByOrderId, getPaymentMethodByOrderId)
    public boolean updatePaymentStatus(int orderID, String paymentStatus) {
        String sql = "UPDATE `order` SET PaymentStatus = ? WHERE OrderID = ?";
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateDeliveryStatus(int orderID, String deliveryStatus) {
        String sql = "UPDATE `order` SET DeliveryStatus = ? WHERE OrderID = ?";
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, deliveryStatus);
            ps.setInt(2, orderID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public BigDecimal getOrderTotalAmount(int orderId) {
        String sql = "SELECT TotalAmount FROM `order` WHERE OrderID = ?";
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("TotalAmount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public Order getOrderById(int orderId) {
        Order order = null;
        try {
            Connection con = Connect.getCon();
            String sql = "SELECT o.*, c.FullName, c.PhoneNumber, c.Address, p.PaymentMethod "
                    + "FROM `order` o "
                    + "JOIN customer c ON o.CustomerID = c.CustomerID "
                    + "LEFT JOIN payment p ON o.OrderID = p.OrderID " 
                    + "WHERE o.OrderID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                order = mapResultSetToOrder(rs);
                List<OrderDetail> orderDetails = getOrderDetails(orderId); // Load details
                order.setOrderDetails(orderDetails);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }
    public Customer getCustomerByOrderId(int orderId) {
        Customer customer = null;
        try {
            Connection con = Connect.getCon();
            String sql = "SELECT c.* FROM customer c "
                    + "JOIN `order` o ON c.CustomerID = o.CustomerID "
                    + "WHERE o.OrderID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                customer = new Customer();
                customer.setCustomerID(rs.getInt("CustomerID"));
                customer.setFullName(rs.getString("FullName"));
                customer.setEmail(rs.getString("Email"));
                customer.setPhoneNumber(rs.getString("PhoneNumber"));
                customer.setAddress(rs.getString("Address"));
                customer.setUserName(rs.getString("UserName"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }
    public String getPaymentMethodByOrderId(int orderId) {
        try {
            Connection con = Connect.getCon();
            String sql = "SELECT PaymentMethod FROM payment WHERE OrderID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("PaymentMethod");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // ⭐ HÀM MỚI CHO ADMIN (Code tớ gửi lần trước, đã sửa lại cho khớp code cậu)
    /**
     * Lấy tất cả đơn hàng (cho Admin), JOIN với bảng Customer để lấy Tên Khách Hàng
     * Sắp xếp theo ngày mới nhất
     */
    public List<Order> getAllOrders() {
        List<Order> orderList = new ArrayList<>();
        String sql = "SELECT o.*, c.FullName AS CustomerName " +
                     "FROM `order` o " +
                     "JOIN customer c ON o.CustomerID = c.CustomerID " +
                     "ORDER BY o.OrderDate DESC";

        try (Connection con = Connect.getCon();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // Dùng hàm mapResultSetToOrder
                Order order = mapResultSetToOrder(rs);
                
                // Gán tên khách hàng (từ JOIN)
                order.setCustomerName(rs.getString("CustomerName"));
                
                // Load details
                List<OrderDetail> details = getOrderDetails(order.getOrderID());
                order.setOrderDetails(details);
                
                orderList.add(order);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách đơn hàng (getAllOrders)", e);
        }
        return orderList;
    }
}