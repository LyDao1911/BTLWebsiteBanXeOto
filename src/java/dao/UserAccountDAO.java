/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import static com.sun.xml.ws.spi.db.BindingContextFactory.LOGGER;
import java.sql.*;
import model.Customer;
import model.UserAccount;
import java.util.logging.Level;

/**
 *
 * @author Hong Ly
 */
public class UserAccountDAO {

    public UserAccount findByUsername(String username) {
        String query = "SELECT * FROM useraccount WHERE Username = ?";
        UserAccount user = null;

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new UserAccount(
                            rs.getInt("UserID"),
                            rs.getString("Username"),
                            rs.getString("Password"),
                            rs.getString("FullName"),
                            rs.getString("Role"),
                            rs.getString("Status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    /**
     * Phương thức 2: Đăng ký người dùng mới (Lưu vào cả 2 bảng) Dùng
     * Transaction để đảm bảo an toàn dữ liệu
     */
    public boolean registerUser(UserAccount user, Customer customer) {
        String queryUser = "INSERT INTO useraccount (Username, Password, FullName, Role, Status) VALUES (?, ?, ?, 'Customer', 'Active')";
        String queryCustomer = "INSERT INTO customer (FullName, Email, PhoneNumber, Address, Username) VALUES (?, ?, ?, ?, ?)";

        Connection con = null;
        PreparedStatement psUser = null;
        PreparedStatement psCustomer = null;

        try {
            con = Connect.getCon();
            // Bắt đầu Transaction (quan trọng)
            con.setAutoCommit(false);

            // 1. Thêm vào bảng useraccount
            psUser = con.prepareStatement(queryUser);
            psUser.setString(1, user.getUsername());
            psUser.setString(2, user.getPassword()); // Cần mã hóa mật khẩu trong thực tế!
            psUser.setString(3, user.getFullName());
            psUser.executeUpdate();

            // 2. Thêm vào bảng customer
            psCustomer = con.prepareStatement(queryCustomer);
            psCustomer.setString(1, customer.getFullName());
            psCustomer.setString(2, customer.getEmail());
            psCustomer.setString(3, customer.getPhoneNumber());
            psCustomer.setString(4, customer.getAddress());
            psCustomer.setString(5, customer.getUserName()); // Khóa ngoại
            psCustomer.executeUpdate();

            // 3. Nếu cả 2 thành công, lưu thay đổi
            con.commit();
            return true;

        } catch (SQLException e) {
            // Nếu có lỗi, hủy bỏ tất cả thay đổi
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            // Đóng tất cả tài nguyên
            try {
                if (psUser != null) {
                    psUser.close();
                }
                if (psCustomer != null) {
                    psCustomer.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public UserAccount login(String username, String password) {
        // LƯU Ý: Trong thực tế, KHÔNG NÊN LƯU MẬT KHẨU THÔ (plaintext) VÀ CẦN DÙNG HASH.
        String query = "SELECT * FROM useraccount WHERE Username = ? AND Password = ?";
        UserAccount user = null;

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new UserAccount(
                            rs.getInt("UserID"),
                            rs.getString("Username"),
                            rs.getString("Password"),
                            rs.getString("FullName"),
                            rs.getString("Role"),
                            rs.getString("Status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean changePassword(String username, String oldPassword, String newPassword) {
        // Câu query này chỉ UPDATE nếu cả username VÀ oldPassword đều đúng
        String query = "UPDATE UserAccount SET Password = ? WHERE Username = ? AND Password = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, newPassword); // Mật khẩu mới
            ps.setString(2, username);    // Tên đăng nhập
            ps.setString(3, oldPassword); // Mật khẩu cũ (để xác thực)

            // ps.executeUpdate() trả về số dòng bị ảnh hưởng
            // Nếu > 0 nghĩa là đổi thành công (tìm thấy user và đúng mật khẩu)
            // Nếu = 0 nghĩa là mật khẩu cũ sai (không tìm thấy dòng nào khớp)
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đổi mật khẩu", e);
            return false;
        }
    }
}
