package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.Payment; // Import model Payment
import java.sql.Timestamp; // Cần thiết để lưu LocalDateTime

// Giả định bạn có lớp Connect
// import utils.Connect; 

public class PaymentDAO {

    // CHUỖI SQL GHI MỚI DỮ LIỆU PAYMENT
    private static final String CREATE_PAYMENT_SQL = "INSERT INTO `payment` (OrderID, PaymentMethod, PaymentDate, Amount, Status) VALUES (?, ?, ?, ?, ?)";

    /**
     * Ghi một bản ghi Payment mới vào Database.
     * Sử dụng Payment model.
     * Status mặc định sẽ là "Đã thanh toán" (nếu null) để khớp với logic OTP.
     */
    public boolean createPayment(Payment payment) {
        try (Connection con = Connect.getCon(); 
             PreparedStatement ps = con.prepareStatement(CREATE_PAYMENT_SQL)) {

            // Chuyển đổi LocalDateTime sang Timestamp để lưu vào DB
            Timestamp paymentTimestamp = payment.getPaymentDate() != null ? 
                                         Timestamp.valueOf(payment.getPaymentDate()) : 
                                         new Timestamp(System.currentTimeMillis()); 
            
            // Xử lý Status: Sử dụng "Đã thanh toán" nếu giá trị từ model là null
            String statusToSave = payment.getStatus() != null ? payment.getStatus() : "Đã thanh toán";
            
            ps.setInt(1, payment.getOrderID());
            ps.setString(2, payment.getPaymentMethod());
            ps.setTimestamp(3, paymentTimestamp); // Lưu ngày giờ
            ps.setBigDecimal(4, payment.getAmount()); // Dùng BigDecimal
            ps.setString(5, statusToSave); // Ghi trạng thái tiếng Việt

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("LỖI SQL KHI TẠO PAYMENT RECORD:");
            ex.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cập nhật trạng thái Payment trong bảng payment (Thường không cần thiết
     * vì trạng thái chính nằm trong bảng 'order', nhưng giữ lại để đồng bộ).
     */
    public boolean updatePaymentStatusByOrderId(int orderId, String newStatus) { 
        String sql = "UPDATE `payment` SET Status = ? WHERE OrderID = ?";

        try (Connection con = Connect.getCon(); 
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, orderId); 

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("LỖI SQL KHI CẬP NHẬT TRẠNG THÁI PAYMENT TRONG BẢNG PAYMENT:");
            ex.printStackTrace();
            return false;
        }
    }
}