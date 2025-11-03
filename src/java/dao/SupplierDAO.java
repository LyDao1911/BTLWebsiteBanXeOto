/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Hong Ly
 */
import model.Supplier;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SupplierDAO {

    private static final Logger LOGGER = Logger.getLogger(SupplierDAO.class.getName());

    // 1. Lấy tất cả nhà cung cấp
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String query = "SELECT * FROM supplier ORDER BY SupplierName";
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierID(rs.getInt("SupplierID"));
                supplier.setSupplierName(rs.getString("SupplierName"));
                supplier.setPhoneNumber(rs.getString("PhoneNumber"));
                supplier.setAddress(rs.getString("Address"));
                supplier.setEmail(rs.getString("Email"));
                list.add(supplier);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách nhà cung cấp", e);
        }
        return list;
    }

    // 2. Thêm nhà cung cấp
    public boolean addSupplier(Supplier supplier) {
        String query = "INSERT INTO supplier (SupplierName, PhoneNumber, Address, Email) VALUES (?, ?, ?, ?)";
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, supplier.getSupplierName());
            ps.setString(2, supplier.getPhoneNumber());
            ps.setString(3, supplier.getAddress());
            ps.setString(4, supplier.getEmail());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm nhà cung cấp", e);
            return false;
        }
    }

    // 3. Lấy 1 nhà cung cấp theo ID (để Sửa)
    public Supplier getSupplierById(int id) {
        String query = "SELECT * FROM supplier WHERE SupplierID = ?";
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Supplier supplier = new Supplier();
                    supplier.setSupplierID(rs.getInt("SupplierID"));
                    supplier.setSupplierName(rs.getString("SupplierName"));
                    supplier.setPhoneNumber(rs.getString("PhoneNumber"));
                    supplier.setAddress(rs.getString("Address"));
                    supplier.setEmail(rs.getString("Email"));
                    return supplier;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy NCC theo ID", e);
        }
        return null;
    }

    // 4. Cập nhật (Sửa) nhà cung cấp
    public boolean updateSupplier(Supplier supplier) {
        String query = "UPDATE supplier SET SupplierName = ?, PhoneNumber = ?, Address = ?, Email = ? WHERE SupplierID = ?";
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, supplier.getSupplierName());
            ps.setString(2, supplier.getPhoneNumber());
            ps.setString(3, supplier.getAddress());
            ps.setString(4, supplier.getEmail());
            ps.setInt(5, supplier.getSupplierID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật NCC", e);
            return false;
        }
    }

    // 5. Xóa nhà cung cấp
    public boolean deleteSupplier(int id) {
        // Lưu ý: Cậu cần đảm bảo không có Hóa đơn nhập nào tham chiếu đến NCC này trước khi xóa
        // Hoặc cài đặt ON DELETE SET NULL/RESTRICT trong CSDL
        String query = "DELETE FROM supplier WHERE SupplierID = ?";
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa NCC", e);
            return false; // Có thể do ràng buộc khóa ngoại
        }
    }
}
