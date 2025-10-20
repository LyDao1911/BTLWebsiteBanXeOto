/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp; 
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Car;
import model.CarImage;
import model.CarStock;

/**
 *
 * @author Hong Ly
 */
public class CarDAO {

    private static final Logger LOGGER = Logger.getLogger(CarDAO.class.getName());

    public int insertCarAndStock(Car car, CarStock stock) {

        // Query cho bảng car (Khớp với model Car.java)
        String carQuery = "INSERT INTO car (CarName, BrandID, Price, Color, Description, Status) VALUES (?, ?, ?, ?, ?, ?)";

        // Query cho bảng carstock (Khớp với model CarStock.java)
        String stockQuery = "INSERT INTO carstock (BrandID, CarID, Quantity, LastUpdated) VALUES (?, ?, ?, ?)";

        int generatedCarId = -1;
        Connection con = null;

        try {
            con = Connect.getCon();
            // Bắt đầu Transaction
            con.setAutoCommit(false);

            // 1. Chèn vào bảng 'car'
            try (PreparedStatement carPs = con.prepareStatement(carQuery, Statement.RETURN_GENERATED_KEYS)) {
                carPs.setString(1, car.getCarName());
                carPs.setInt(2, car.getBrandID());
                carPs.setBigDecimal(3, car.getPrice());
                carPs.setString(4, car.getColor());
                carPs.setString(5, car.getDescription());
                carPs.setString(6, car.getStatus());

                carPs.executeUpdate();

                // Lấy CarID tự tăng
                try (ResultSet rs = carPs.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedCarId = rs.getInt(1);
                    }
                }
            }

            // 2. Chèn vào bảng 'carstock' (Chỉ thực hiện nếu lấy được CarID)
            if (generatedCarId != -1) {
                try (PreparedStatement stockPs = con.prepareStatement(stockQuery)) {
                    stockPs.setInt(1, car.getBrandID()); // Lấy BrandID từ đối tượng Car
                    stockPs.setInt(2, generatedCarId); // Dùng CarID vừa tạo
                    stockPs.setInt(3, stock.getQuantity());
                    stockPs.setTimestamp(4, Timestamp.valueOf(stock.getLastUpdated())); // Chuyển LocalDateTime sang Timestamp

                    stockPs.executeUpdate();
                }
            } else {
                // Nếu không lấy được CarID, hủy bỏ
                throw new Exception("Không thể tạo CarID mới.");
            }

            // Commit transaction nếu cả hai lệnh INSERT đều thành công
            con.commit();
            return generatedCarId;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm xe và stock. Tiến hành Rollback.", e);
            if (con != null) {
                try {
                    con.rollback(); // Hoàn tác nếu có lỗi
                } catch (Exception rbEx) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi rollback.", rbEx);
                }
            }
            return -1; // Thêm thất bại
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true); // Trả lại chế độ AutoCommit
                    con.close();
                } catch (Exception closeEx) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối.", closeEx);
                }
            }
        }
    }

    /**
     * Phương thức chèn đối tượng CarImage vào bảng 'carimage'.
     *
     * @param image Đối tượng CarImage (chứa CarID, ImageURL, IsMain)
     * @return true nếu chèn thành công, false nếu thất bại
     */
    public boolean insertCarImage(CarImage image) {
        // Query khớp với model CarImage.java
        String query = "INSERT INTO carimage (CarID, ImageURL, IsMain) VALUES (?, ?, ?)";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, image.getCarID());
// (Lưu ý: Tên cột trong DB của cậu là ImageURL hay ImagePath? Tớ dùng ImageURL khớp với model)
            ps.setString(2, image.getImageURL());
            ps.setBoolean(3, image.isIsMain()); // Dùng getter isIsMain()

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi chèn ảnh mô tả cho CarID: " + image.getCarID(), e);
            return false;
        }
    }
}
