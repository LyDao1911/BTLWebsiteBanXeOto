/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Brand;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Hong Ly
 */
public class BrandDAO {

    private static final Logger LOGGER = Logger.getLogger(BrandDAO.class.getName());

    /**
     * Lấy BrandID dựa vào BrandName (Tên thương hiệu).
     *
     * @param brandName Tên thương hiệu (ví dụ: "Toyota")
     * @return BrandID (int) nếu tìm thấy, ngược lại trả về -1
     */
    public int getBrandIdByName(String brandName) {
        // Sử dụng 'brandName' giống như trong model Brand.java
        String query = "SELECT BrandID FROM brand WHERE brandName = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, brandName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("BrandID");
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm BrandID_by_Name", e);
        }

        return -1; // Trả về -1 nếu không tìm thấy hoặc có lỗi
    }

    /**
     * HÀM 1: Lấy tất cả các hãng (để hiển thị bảng bên phải)
     */
    public List<Brand> getAllBrands() {
        List<Brand> brandList = new ArrayList<>();
        String query = "SELECT * FROM Brand"; // Giả sử tên bảng là Brand

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Brand b = new Brand(
                        rs.getInt("BrandID"),
                        rs.getString("BrandName"),
                        rs.getString("LogoURL")
                );
                brandList.add(b);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách Brand", e);
        }
        return brandList;
    }

    /**
     * HÀM 2: Thêm một hãng mới
     */
    public boolean addBrand(Brand brand) {
        String query = "INSERT INTO Brand (BrandName, LogoURL) VALUES (?, ?)";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, brand.getBrandName());
            ps.setString(2, brand.getLogoURL());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm Brand", e);
            return false;
        }
    }

    /**
     * HÀM 3: Sửa một hãng
     */
    public boolean updateBrandWithLogo(Brand brand) {
        String query = "UPDATE Brand SET BrandName = ?, LogoURL = ? WHERE BrandID = ?";
        
        try (Connection con = Connect.getCon();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, brand.getBrandName());
            ps.setString(2, brand.getLogoURL()); // Cập nhật ảnh mới
            ps.setInt(3, brand.getBrandID());
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi sửa Brand (có logo)", e);
            return false;
        }
    }
    
    /**
     * HÀM 4 (MỚI): Sửa hãng (Không cập nhật ảnh)
     */
    public boolean updateBrandNoLogo(Brand brand) {
        String query = "UPDATE Brand SET BrandName = ? WHERE BrandID = ?";
        
        try (Connection con = Connect.getCon();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, brand.getBrandName()); // Chỉ cập nhật tên
            ps.setInt(2, brand.getBrandID());
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi sửa Brand (ko logo)", e);
            return false;
        }
    }

    /**
     * HÀM 4: Xóa một hãng
     */
    public boolean deleteBrand(int brandID) {
        String query = "DELETE FROM Brand WHERE BrandID = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, brandID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa Brand", e);
            return false;
        }
    }
}
