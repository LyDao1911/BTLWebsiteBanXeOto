/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Car;
import model.CarImage;
import model.CarStock;
import model.Brand;
import java.util.Map;
import java.util.LinkedHashMap;

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

    public List<Car> getAllCarsWithStock() {
        List<Car> list = new ArrayList<>();
        String query = "SELECT c.CarID, c.CarName, c.BrandID, c.Price, c.Color, "
                + "c.Description, c.Status, s.Quantity "
                + "FROM car c "
                + "LEFT JOIN carstock s ON c.CarID = s.CarID";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Car car = new Car();
                car.setCarID(rs.getInt("CarID"));
                car.setCarName(rs.getString("CarName"));
                car.setBrandID(rs.getInt("BrandID"));
                car.setPrice(rs.getBigDecimal("Price"));
                car.setColor(rs.getString("Color"));
                car.setDescription(rs.getString("Description"));
                car.setStatus(rs.getString("Status"));

                // Lấy thêm Quantity
                int quantity = rs.getInt("Quantity");
                car.setQuantity(quantity);

                list.add(car);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách xe có tồn kho.", e);
        }

        return list;
    }

    // Trong CarDAO.java
    public Car getCarById(int carId) {
        // KẾT HỢP: Lấy thông tin xe, tồn kho, tên hãng và URL ảnh chính trong 1 QUERY
        String sql = "SELECT c.CarID, c.CarName, c.Price, c.Color, c.Description, c.Status, "
                + "s.Quantity, " // Lấy tồn kho
                + "b.BrandName, b.BrandID, " // Lấy tên và ID hãng xe
                + "ci.ImageURL AS MainImageURL " // Lấy ảnh chính
                + "FROM car c "
                + "LEFT JOIN carstock s ON c.CarID = s.CarID "
                + "JOIN brand b ON c.BrandID = b.BrandID " // Dùng JOIN thay vì chỉ lấy BrandID
                + "LEFT JOIN carimage ci ON c.CarID = ci.CarID AND ci.IsMain = 1 "
                + "WHERE c.CarID = ?";

        Car car = null;
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, carId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    car = new Car();
                    car.setCarID(rs.getInt("CarID"));
                    car.setCarName(rs.getString("CarName"));
                    // CẬP NHẬT: Gán BrandName
                    car.setBrandID(rs.getInt("BrandID"));
                    car.setBrandName(rs.getString("BrandName"));
                    // ---
                    car.setPrice(rs.getBigDecimal("Price"));
                    car.setColor(rs.getString("Color"));
                    car.setDescription(rs.getString("Description"));
                    car.setStatus(rs.getString("Status"));
                    car.setQuantity(rs.getInt("Quantity"));
                    // CẬP NHẬT: Gán MainImageURL (đã có trong query JOIN)
                    String mainImage = rs.getString("MainImageURL");
                    if (mainImage != null && !mainImage.startsWith("uploads/")) {
                        mainImage = mainImage;
                    }
                    car.setMainImageURL(mainImage);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy chi tiết xe CarID: " + carId, e);
        }
        // Bỏ khối finally rườm rà vì try-with-resources đã tự đóng connection

        return car;
    }

    // // 🔹 Cập nhật thông tin xe, tồn kho, và ảnh
    public boolean updateCarWithStock(Car car, int quantity) {
        System.out.println(">>> [DAO] Đang cập nhật xe: " + car.getCarID() + " - " + car.getCarName());
        System.out.println(">>> [DAO] Số lượng tồn: " + quantity);

        String carQuery = "UPDATE car SET CarName=?, BrandID=?, Price=?, Color=?, Description=?, Status=? WHERE CarID=?";

        // SỬA LỖI 1: Thay GETDATE() bằng NOW() cho MySQL/Hỗ trợ chung
        String stockQuery = "UPDATE carstock SET Quantity=?, LastUpdated=NOW() WHERE CarID=?";
        String insertStock = "INSERT INTO carstock (BrandID, CarID, Quantity, LastUpdated) VALUES (?, ?, ?, NOW())";

        String imageMainQuery = "UPDATE carimage SET ImageURL=? WHERE CarID=? AND IsMain=1";
        // Query INSERT ảnh chính nếu UPDATE thất bại (Đã thêm biến mới)
        String insertMainImage = "INSERT INTO carimage (CarID, ImageURL, IsMain) VALUES (?, ?, 1)";

        String deleteThumbsQuery = "DELETE FROM carimage WHERE CarID=? AND IsMain=0";
        String insertThumbQuery = "INSERT INTO carimage (CarID, ImageURL, IsMain) VALUES (?, ?, 0)";

        Connection con = null;

        try {
            con = Connect.getCon();
            con.setAutoCommit(false);

            // 🟢 1. Cập nhật thông tin xe
            int carRows = 0;
            try (PreparedStatement carPs = con.prepareStatement(carQuery)) {
                carPs.setString(1, car.getCarName());
                carPs.setInt(2, car.getBrandID());
                carPs.setBigDecimal(3, car.getPrice());
                carPs.setString(4, car.getColor());
                carPs.setString(5, car.getDescription());
                carPs.setString(6, car.getStatus());
                carPs.setInt(7, car.getCarID());
                carRows = carPs.executeUpdate();
                System.out.println(">>> [DAO] Cập nhật bảng car: " + carRows + " dòng.");

                // NẾU carRows == 0 thì CarID không tồn tại, cần ROLLBACK ngay
                if (carRows == 0) {
                    throw new Exception("Lỗi: Không tìm thấy CarID=" + car.getCarID() + " để cập nhật.");
                }
            }

            // 🟢 2. Cập nhật tồn kho (Stock)
            int affectedRows = 0;
            try (PreparedStatement stockPs = con.prepareStatement(stockQuery)) {
                stockPs.setInt(1, quantity);
                stockPs.setInt(2, car.getCarID());
                affectedRows = stockPs.executeUpdate();
                System.out.println(">>> [DAO] Cập nhật bảng carstock: " + affectedRows + " dòng.");
            }

            if (affectedRows == 0) {
                // Nếu UPDATE không thành công (chưa có tồn kho), thì INSERT mới
                try (PreparedStatement insertPs = con.prepareStatement(insertStock)) {
                    insertPs.setInt(1, car.getBrandID());
                    insertPs.setInt(2, car.getCarID());
                    insertPs.setInt(3, quantity);
                    insertPs.executeUpdate();
                    System.out.println("ℹ️ [DAO] Chưa có tồn kho → Đã thêm mới stock cho CarID=" + car.getCarID());
                }
            }

            // 🟢 3. SỬA LỖI 2: Cập nhật hoặc Thêm mới ảnh chính
            if (car.getMainImageURL() != null && !car.getMainImageURL().isEmpty()) {
                String imgName = car.getMainImageURL();
                if (imgName.startsWith("uploads/")) {
                    imgName = imgName.substring("uploads/".length());
                }

                try (PreparedStatement imgPs = con.prepareStatement(imageMainQuery)) {
                    imgPs.setString(1, imgName);
                    imgPs.setInt(2, car.getCarID());
                    int imgRows = imgPs.executeUpdate();

                    if (imgRows == 0) {
                        try (PreparedStatement insertPs = con.prepareStatement(insertMainImage)) {
                            insertPs.setInt(1, car.getCarID());
                            insertPs.setString(2, imgName);
                            insertPs.executeUpdate();
                        }
                    }
                }
            }

            // 🟢 4. Ảnh mô tả (Thumbs)
            // 🟢 4. Ảnh mô tả (Thumbs)
            if (car.getThumbs() != null) {
                try (PreparedStatement delPs = con.prepareStatement(deleteThumbsQuery)) {
                    delPs.setInt(1, car.getCarID());
                    delPs.executeUpdate();
                }

                if (!car.getThumbs().isEmpty()) {
                    try (PreparedStatement insPs = con.prepareStatement(insertThumbQuery)) {
                        for (String thumb : car.getThumbs()) {
                            if (thumb.startsWith("uploads/")) {
                                thumb = thumb.substring("uploads/".length());
                            }
                            insPs.setInt(1, car.getCarID());
                            insPs.setString(2, thumb);
                            insPs.addBatch();
                        }
                        insPs.executeBatch();
                    }
                }
            }

            con.commit();
            System.out.println("✅ [DAO] Update thành công CarID=" + car.getCarID());
            return true;

        } catch (Exception e) {
            // Lỗi ở đây sẽ in ra chi tiết SQLException, giúp bạn debug chính xác hơn
            e.printStackTrace();
            if (con != null) try {
                con.rollback();
            } catch (Exception ignore) {
            }
            System.out.println("❌ [DAO] Update thất bại: " + e.getMessage());
            return false;
        } finally {
            if (con != null) try {
                con.setAutoCommit(true); // Quan trọng: Đưa về trạng thái AutoCommit ban đầu
                con.close();
            } catch (Exception ignore) {
            }
        }
    }

    public boolean updateCarImage(int carId, String imageURL) {
        String sql = "UPDATE carimage SET ImageURL = ? WHERE CarID = ? AND IsMain = 1";
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, imageURL);
            ps.setInt(2, carId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // Thêm vào lớp dao.CarDAO.java

    public boolean deleteCar(int carID) {
        System.out.println(">>> [DAO] Chuẩn bị xóa xe CarID=" + carID);

        // Xóa tất cả bản ghi liên quan trước khi xóa bản ghi chính
        String deleteImageQuery = "DELETE FROM carimage WHERE CarID=?";
        String deleteStockQuery = "DELETE FROM carstock WHERE CarID=?";
        String deleteCarQuery = "DELETE FROM car WHERE CarID=?";

        // Query kiểm tra sự tồn tại trong orderdetail
        String checkOrderQuery = "SELECT 1 FROM orderdetail WHERE CarID=? LIMIT 1";

        Connection con = null;

        try {
            con = Connect.getCon();
            con.setAutoCommit(false); // Bắt đầu Transaction

            // 0. Kiểm tra OrderDetail (Nếu có, không được xóa)
            try (PreparedStatement checkPs = con.prepareStatement(checkOrderQuery)) {
                checkPs.setInt(1, carID);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        // Nếu xe đã được đặt hàng, KHÔNG xóa
                        System.err.println("❌ [DAO] Xóa thất bại: CarID=" + carID + " đã có trong OrderDetail.");
                        con.rollback();
                        return false;
                    }
                }
            }

            // 1. Xóa trong carimage
            try (PreparedStatement imagePs = con.prepareStatement(deleteImageQuery)) {
                imagePs.setInt(1, carID);
                int rows = imagePs.executeUpdate();
                System.out.println(">>> [DAO] Đã xóa " + rows + " ảnh liên quan.");
            }

            // 2. Xóa trong carstock
            try (PreparedStatement stockPs = con.prepareStatement(deleteStockQuery)) {
                stockPs.setInt(1, carID);
                int rows = stockPs.executeUpdate();
                System.out.println(">>> [DAO] Đã xóa " + rows + " tồn kho liên quan.");
            }

            // 3. Xóa trong car (Bản ghi chính)
            int carRows;
            try (PreparedStatement carPs = con.prepareStatement(deleteCarQuery)) {
                carPs.setInt(1, carID);
                carRows = carPs.executeUpdate();
                System.out.println(">>> [DAO] Đã xóa " + carRows + " bản ghi chính.");
            }

            if (carRows > 0) {
                con.commit(); // Hoàn tất Transaction
                System.out.println("✅ [DAO] Xóa cứng thành công CarID=" + carID);
                return true;
            } else {
                con.rollback(); // Nếu không xóa được bản ghi chính (CarID không tồn tại)
                System.err.println("❌ [DAO] Xóa thất bại: Không tìm thấy CarID=" + carID + ".");
                return false;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa xe. Tiến hành Rollback.", e);
            if (con != null) {
                try {
                    con.rollback(); // Hoàn tác nếu có lỗi SQL
                } catch (SQLException rbEx) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi rollback.", rbEx);
                }
            }
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException closeEx) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối.", closeEx);
                }
            }
        }
    }

    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        // Giả định tên bảng là 'brand' và có các cột BrandID, BrandName, LogoURL
        String sql = "SELECT BrandID, BrandName, LogoURL FROM brand ORDER BY BrandName";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Brand brand = new Brand();
                brand.setBrandID(rs.getInt("BrandID"));
                brand.setBrandName(rs.getString("BrandName"));
                brand.setLogoURL(rs.getString("LogoURL")); // Giả định tên cột là LogoURL
                brands.add(brand);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách hãng xe.", e);
        }
        return brands;
    }

    public Map<Brand, List<Car>> getCarsGroupedByBrand() {
        // LinkedHashMap để đảm bảo thứ tự các hãng xe được giữ nguyên (nếu cần)
        Map<Brand, List<Car>> groupedCars = new LinkedHashMap<>();

        // Query kết hợp 3 bảng: car, carimage (để lấy ảnh chính), và brand
        String sql = "SELECT b.BrandID, b.BrandName, b.LogoURL, "
                + "c.CarID, c.CarName, c.Price, "
                + "ci.ImageURL AS MainImageURL "
                + "FROM car c "
                + "JOIN brand b ON c.BrandID = b.BrandID "
                + "LEFT JOIN carimage ci ON c.CarID = ci.CarID AND ci.IsMain = 1 "
                + "WHERE c.Status = 'Available' " // Chỉ lấy xe đang bán
                + "ORDER BY b.BrandName, c.CarName";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // Lấy thông tin Brand
                int brandID = rs.getInt("BrandID");
                String brandName = rs.getString("BrandName");
                String logoURL = rs.getString("LogoURL");
                Brand brand = new Brand(brandID, brandName, logoURL);

                // Lấy thông tin Car
                Car car = new Car();
                car.setCarID(rs.getInt("CarID"));
                car.setCarName(rs.getString("CarName"));
                car.setBrandID(brandID);
                car.setPrice(rs.getBigDecimal("Price"));
                car.setMainImageURL(rs.getString("MainImageURL")); // Lấy từ JOIN

                // Tìm Brand trong Map, nếu chưa có thì thêm mới. Sau đó thêm Car vào List.
                // Dùng Brand ID/tên làm key sẽ tiện hơn, nhưng dùng object Brand làm key để lấy LogoURL tiện hơn.
                // Để đảm bảo Brand object là duy nhất (vì BrandID là khóa chính), ta cần một cách so sánh (equals/hashCode)
                // Tối ưu hóa: Thay vì dùng object Brand làm Key, ta có thể dùng Brand Name (String) làm Key
                List<Car> carList = groupedCars.computeIfAbsent(brand, k -> new ArrayList<>());
                carList.add(car);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách xe theo hãng.", e);
        }
        return groupedCars;
    }

    public List<String> getCarThumbs(int carID) {
        List<String> thumbs = new ArrayList<>();
        // Lấy tất cả ảnh không phải ảnh chính (IsMain = 0)
        String sql = "SELECT ImageURL FROM carimage WHERE CarID = ? AND IsMain = 0";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, carID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String img = rs.getString("ImageURL");
                    if (img != null && !img.startsWith("uploads/")) {
                        img = img;
                    }
                    thumbs.add(img);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy ảnh phụ cho CarID: " + carID, e);
        }
        return thumbs;
    }

}
