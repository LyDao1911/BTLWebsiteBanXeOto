/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Hong Ly
 */
public class OrderDetailDAO {
    private static final String INSERT_DETAIL_SQL
            = "INSERT INTO `orderdetail` (OrderID, CarID, Quantity, UserName, Price, Subtotal) VALUES (?, ?, ?, ?, ?, ?)";

    /**
     * Lưu chi tiết đơn hàng.
     */
    // Giả sử bạn nhận OrderDetail Model, hoặc nhận trực tiếp các tham số cần thiết.
    public boolean saveOrderDetail(String orderId, int carId, int quantity, String userName, double price, double subtotal) {
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(INSERT_DETAIL_SQL)) {

            ps.setString(1, orderId);
            ps.setInt(2, carId);
            ps.setInt(3, quantity);
            ps.setString(4, userName); // Lấy từ Model hoặc session/form
            ps.setDouble(5, price);
            ps.setDouble(6, subtotal);

            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            Logger.getLogger(OrderDetailDAO.class.getName()).log(Level.SEVERE, "Lỗi khi lưu OrderDetail", ex);
            ex.printStackTrace();
            return false;
        }
    }

}
