/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 *
 * @author Hong Ly
 */
public class PaymentDAO {

    private static final String CREATE_PAYMENT_SQL = "INSERT INTO `payment` (OrderID, PaymentMethod, PaymentDate, Amount, Status) VALUES (?, ?, NOW(), ?, ?)";
    private static final String UPDATE_STATUS_SQL = "UPDATE `payment` SET Status = ?, Amount = ? WHERE OrderID = ?";

    public boolean createPaymentRecord(String orderId, String method, double amount, String status) {
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(CREATE_PAYMENT_SQL)) {

            ps.setString(1, orderId);
            ps.setString(2, method);
            ps.setDouble(3, amount);
            ps.setString(4, status);

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(); // 🛑 RẤT QUAN TRỌNG: In lỗi SQL ra Console
            return false;
        }
    }

    public boolean updatePaymentStatusByOrderId(String orderId, String newStatus) {
        // Chỉ cập nhật cột Status
        String sql = "UPDATE `payment` SET Status = ? WHERE OrderID = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setString(2, orderId);

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("LỖI SQL KHI CẬP NHẬT TRẠNG THÁI PAYMENT TRONG BẢNG PAYMENT:");
            ex.printStackTrace();
            return false;
        }
    }
}
