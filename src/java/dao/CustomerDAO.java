/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
                    // Đã xóa NgaySinh
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
        // Đã xóa NgaySinh khỏi query
        String query = "UPDATE Customer SET FullName = ?, Email = ?, PhoneNumber = ?, Address = ? WHERE UserName = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, cust.getFullName());
            ps.setString(2, cust.getEmail());
            ps.setString(3, cust.getPhoneNumber());
            ps.setString(4, cust.getAddress());
            ps.setString(5, cust.getUserName()); // WHERE

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật customer profile", e);
            return false;
        }
    }
}
