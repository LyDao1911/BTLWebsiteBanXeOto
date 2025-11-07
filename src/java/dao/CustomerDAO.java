/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement; // ✅ đúng package
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Hong Ly
 */
public class CustomerDAO {

    private static final Logger LOGGER = Logger.getLogger(CustomerDAO.class.getName());

    /**
     * Lấy thông tin Customer (Hồ sơ) bằng Username
     */
    public Customer getCustomerByUsername(String username) {
        String query = "SELECT * FROM Customer WHERE UserName = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer cust = new Customer();
                    cust.setCustomerID(rs.getInt("CustomerID"));
                    cust.setFullName(rs.getString("FullName"));
                    cust.setEmail(rs.getString("Email"));
                    cust.setPhoneNumber(rs.getString("PhoneNumber"));
                    cust.setAddress(rs.getString("Address"));
                    cust.setUserName(rs.getString("UserName"));
                    return cust;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy customer by username", e);
        }
        return null;
    }

    /**
     * Cập nhật thông tin hồ sơ Customer
     */
    public boolean updateCustomerProfile(Customer cust) {
        String query = "UPDATE Customer SET FullName = ?, Email = ?, PhoneNumber = ?, Address = ? WHERE UserName = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, cust.getFullName());
            ps.setString(2, cust.getEmail());
            ps.setString(3, cust.getPhoneNumber());
            ps.setString(4, cust.getAddress());
            ps.setString(5, cust.getUserName());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật customer profile", e);
            return false;
        }
    }

    /**
     * Thêm khách hàng mới và trả về ID vừa tạo
     */
    public int insertCustomer(Customer c) {
        String sql = "INSERT INTO Customer (FullName, Email, PhoneNumber, Address, UserName) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, c.getFullName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPhoneNumber());
            ps.setString(4, c.getAddress());
            ps.setString(5, c.getUserName());

            int affectedRows = ps.executeUpdate();
            System.out.println("🔍 DEBUG - insertCustomer affected rows: " + affectedRows);

            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int newId = rs.getInt(1);
                    System.out.println("🔍 DEBUG - insertCustomer generated ID: " + newId);
                    return newId;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm khách hàng mới", e);
            System.out.println("❌ ERROR - insertCustomer: " + e.getMessage());
        }
        return -1; // thất bại
    }

    /**
     * Lấy khách hàng theo email
     */
    /**
     * Lấy khách hàng theo email - PHIÊN BẢN ĐÃ SỬA
     */
    public Customer getCustomerByEmail(String email) {
        String sql = "SELECT * FROM Customer WHERE Email = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer customer = new Customer();
                    customer.setCustomerID(rs.getInt("CustomerID"));
                    customer.setFullName(rs.getString("FullName"));
                    customer.setEmail(rs.getString("Email"));
                    customer.setPhoneNumber(rs.getString("PhoneNumber"));
                    customer.setAddress(rs.getString("Address"));
                    customer.setUserName(rs.getString("UserName"));

                    // Thêm dòng này nếu có cột Password
                    

                    System.out.println("🔍 DEBUG - getCustomerByEmail found: " + customer.getCustomerID() + " - " + customer.getFullName());
                    return customer;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy customer by email", e);
            System.out.println("❌ ERROR - getCustomerByEmail: " + e.getMessage());
        }

        System.out.println("🔍 DEBUG - getCustomerByEmail not found for: " + email);
        return null;
    }

    /**
     * Kiểm tra xem cột có tồn tại trong ResultSet không
     */
    private boolean columnExists(ResultSet rs, String columnName) {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * Cập nhật thông tin khách hàng theo CustomerID
     */
    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE Customer SET FullName = ?, PhoneNumber = ?, Address = ? WHERE CustomerID = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getPhoneNumber());
            ps.setString(3, customer.getAddress());
            ps.setInt(4, customer.getCustomerID());

            int result = ps.executeUpdate();
            System.out.println("🔍 DEBUG - updateCustomer affected rows: " + result);

            return result > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật customer", e);
            System.out.println("❌ ERROR - updateCustomer: " + e.getMessage());
            return false;
        }
    }

    /**
     * Kiểm tra xem email đã tồn tại chưa (trừ customer hiện tại)
     */
    public boolean isEmailExists(String email, int excludeCustomerID) {
        String sql = "SELECT COUNT(*) FROM Customer WHERE Email = ? AND CustomerID != ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setInt(2, excludeCustomerID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra email tồn tại", e);
        }
        return false;
    }

    /**
     * Kiểm tra xem username đã tồn tại chưa (trừ customer hiện tại)
     */
    public boolean isUsernameExists(String username, int excludeCustomerID) {
        String sql = "SELECT COUNT(*) FROM Customer WHERE UserName = ? AND CustomerID != ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setInt(2, excludeCustomerID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra username tồn tại", e);
        }
        return false;
    }
}
