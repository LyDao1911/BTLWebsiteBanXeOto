package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import model.Customer;
import model.Order;
import model.OrderDetail;
// import utils.Connect; // Giả định lớp Connect

public class OrderDAO {

    /**
     * Phương thức nội bộ để tạo đối tượng Order từ ResultSet.
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderID(rs.getInt("OrderID"));
        order.setCustomerID(rs.getInt("CustomerID"));
        order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
        order.setPaymentStatus(rs.getString("PaymentStatus"));
        order.setDeliveryStatus(rs.getString("DeliveryStatus"));

        // Load OrderDetails cho từng Order
        List<OrderDetail> details = getOrderDetails(order.getOrderID());
        order.setOrderDetails(details);
        return order;
    }

    public int getCustomerIDByUsername(String username) {
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
        String sql = "SELECT * FROM `order` WHERE CustomerID = ? ORDER BY OrderDate DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getOrdersByCustomerIdAndPaymentStatus(int customerId, String status) {
        String sql = "SELECT * FROM `order` WHERE CustomerID = ? AND PaymentStatus = ? ORDER BY OrderDate DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getCompletedOrdersByCustomerId(int customerId) {
        String sql = "SELECT * FROM `order` WHERE CustomerID = ? AND DeliveryStatus = 'Hoàn thành' ORDER BY OrderDate DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getIncompleteOrdersByCustomerId(int customerId) {
        String sql = "SELECT * FROM `order` WHERE CustomerID = ? AND DeliveryStatus != 'Hoàn thành' ORDER BY OrderDate DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    private List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> details = new ArrayList<>();

        // ✅ CÂU LỆNH SQL ĐÃ SỬA: JOIN carimage để lấy ImageURL (ảnh chính)
        // Đây là thay đổi quan trọng để lấy tên ảnh từ bảng carimage
        String sql = "SELECT od.*, c.CarName, ci.ImageURL "
                + "FROM orderdetail od "
                + "JOIN car c ON od.CarID = c.CarID "
                + "LEFT JOIN carimage ci ON c.CarID = ci.CarID AND ci.IsMain = 1 "
                + // Lấy ImageURL có cờ IsMain = 1
                "WHERE od.OrderID = ?";

        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderDetailID(rs.getInt("OrderDetailID"));
                detail.setOrderID(rs.getInt("OrderID"));
                detail.setCarID(rs.getInt("CarID"));

                // ✅ Lấy Quantity: Cột này đã được xác nhận tồn tại trong orderdetail
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setUserName(rs.getString("UserName"));

                detail.setPrice(rs.getBigDecimal("Price"));
                detail.setSubtotal(rs.getBigDecimal("Subtotal"));

                // ✅ Lấy Tên xe và Tên ảnh (từ cột ImageURL)
                detail.setCarName(rs.getString("CarName"));
                detail.setCarImage(rs.getString("ImageURL")); // Lấy từ cột ImageURL

                details.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }

    public List<Order> getOrdersByUser(String username) {
        int customerId = getCustomerIDByUsername(username);
        if (customerId == 0) {
            return new ArrayList<>();
        }
        return getAllOrdersByCustomerId(customerId);
    }

    public List<Order> getOrdersByUserAndPaymentStatus(String username, boolean paid) {
        int customerId = getCustomerIDByUsername(username);
        if (customerId == 0) {
            return new ArrayList<>();
        }
        String status = paid ? "Đã thanh toán" : "Chưa thanh toán";
        return getOrdersByCustomerIdAndPaymentStatus(customerId, status);
    }

    public List<Order> getOrdersByUserAndDeliveryStatus(String username, boolean completed) {
        int customerId = getCustomerIDByUsername(username);
        if (customerId == 0) {
            return new ArrayList<>();
        }
        if (completed) {
            return getCompletedOrdersByCustomerId(customerId);
        } else {
            return getIncompleteOrdersByCustomerId(customerId);
        }
    }

    // PHẦN createOrderWithDetails ĐƯỢC GIỮ NGUYÊN (và đang sử dụng Quantity đúng đắn)
    public int createOrderWithDetails(Order order, List<OrderDetail> details) {
        String insertOrder = "INSERT INTO `order` (CustomerID, OrderDate, TotalAmount, PaymentStatus, DeliveryStatus, Note) VALUES (?, ?, ?, ?, ?, ?)";
        String insertDetail = "INSERT INTO orderdetail (OrderID, CarID, Quantity, UserName, Price, Subtotal) VALUES (?, ?, ?, ?, ?, ?)";
        String updateStock = "UPDATE carstock SET Quantity = Quantity - ? WHERE CarID = ?";

        try (Connection conn = Connect.getCon()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psOrder = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getCustomerID());
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
                throw e;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

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
                + "LEFT JOIN payment p ON o.OrderID = p.OrderID "  // LEFT JOIN để lấy payment method
                + "WHERE o.OrderID = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, orderId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            order = new Order();
            order.setOrderID(rs.getInt("OrderID"));
            order.setCustomerID(rs.getInt("CustomerID"));
            order.setOrderDate(rs.getTimestamp("OrderDate").toLocalDateTime());
            order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
            order.setPaymentStatus(rs.getString("PaymentStatus"));
            order.setDeliveryStatus(rs.getString("DeliveryStatus"));
            order.setNote(rs.getString("Note"));

           
            List<OrderDetail> orderDetails = getOrderDetails(orderId);
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
}
