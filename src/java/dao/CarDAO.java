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
import java.math.BigDecimal; // Import thêm BigDecimal

/**
 *
 * @author Hong Ly
 */
public class CarDAO {

    private static final Logger LOGGER = Logger.getLogger(CarDAO.class.getName());

    public int insertCarAndStock(Car car, CarStock stock) {
        String carQuery = "INSERT INTO car (CarName, BrandID, Price, Color, Description, Status) VALUES (?, ?, ?, ?, ?, ?)";
        String stockQuery = "INSERT INTO carstock (BrandID, CarID, Quantity, LastUpdated) VALUES (?, ?, ?, ?)";

        int generatedCarId = -1;
        Connection con = null;

        try {
            con = Connect.getCon();
            con.setAutoCommit(false);

            try (PreparedStatement carPs = con.prepareStatement(carQuery, Statement.RETURN_GENERATED_KEYS)) {
                carPs.setString(1, car.getCarName());
                carPs.setInt(2, car.getBrandID());
                carPs.setBigDecimal(3, car.getPrice());
                carPs.setString(4, car.getColor());
                carPs.setString(5, car.getDescription());
                carPs.setString(6, car.getStatus());

                carPs.executeUpdate();

                try (ResultSet rs = carPs.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedCarId = rs.getInt(1);
                    }
                }
            }

            if (generatedCarId != -1) {
                try (PreparedStatement stockPs = con.prepareStatement(stockQuery)) {
                    stockPs.setInt(1, car.getBrandID());
                    stockPs.setInt(2, generatedCarId);
                    stockPs.setInt(3, stock.getQuantity());
                    stockPs.setTimestamp(4, Timestamp.valueOf(stock.getLastUpdated()));
                    stockPs.executeUpdate();
                }
            } else {
                throw new Exception("Không thể tạo CarID mới.");
            }

            con.commit();
            return generatedCarId;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm xe và stock. Tiến hành Rollback.", e);
            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception rbEx) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi rollback.", rbEx);
                }
            }
            return -1;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (Exception closeEx) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối.", closeEx);
                }
            }
        }
    }

    public boolean insertCarImage(CarImage image) {
        String query = "INSERT INTO carimage (CarID, ImageURL, IsMain) VALUES (?, ?, ?)";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, image.getCarID());
            ps.setString(2, image.getImageURL());
            ps.setBoolean(3, image.isIsMain());
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
                int quantity = rs.getInt("Quantity");
                car.setQuantity(quantity);
                list.add(car);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách xe có tồn kho.", e);
        }
        return list;
    }

    public boolean updateCarQuantity(int carID, int newQuantity) {
        String sql = "UPDATE carstock SET Quantity = ?, LastUpdated = NOW() WHERE CarID = ?";
        if (newQuantity < 0) {
            LOGGER.log(Level.WARNING, "Không thể cập nhật số lượng tồn kho âm cho CarID: " + carID);
            return false;
        }

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, carID);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("✅ [DAO] Cập nhật Quantity thành công cho CarID=" + carID + ". Số lượng mới: " + newQuantity);
                return true;
            } else {
                System.out.println("ℹ️ [DAO] Update Quantity thất bại: Không tìm thấy tồn kho cho CarID=" + carID);
                return false;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật tồn kho cho CarID: " + carID, e);
            e.printStackTrace();
            return false;
        }
    }

  public Car getCarById(int carId) {
    String sql = "SELECT c.CarID, c.CarName, c.Price, c.Color, c.Description, c.Status, "
            + "s.Quantity, "
            + "b.BrandName, b.BrandID, "
            + "ci.ImageURL AS MainImageURL "
            + "FROM car c "
            + "LEFT JOIN carstock s ON c.CarID = s.CarID "
            + "JOIN brand b ON c.BrandID = b.BrandID "
            + "LEFT JOIN carimage ci ON c.CarID = ci.CarID AND ci.IsMain = 1 "
            + "WHERE c.CarID = ?";

    Car car = null;
    try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, carId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                car = mapResultSetToCar(rs); // ⭐ SỬA: Dùng phương thức đã fix
            }
        }
    } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "Lỗi khi lấy chi tiết xe CarID: " + carId, e);
    }
    return car;
}

    public boolean updateCarWithStock(Car car, int quantity) {
        System.out.println(">>> [DAO] Đang cập nhật xe: " + car.getCarID() + " - " + car.getCarName());
        System.out.println(">>> [DAO] Số lượng tồn: " + quantity);

        String carQuery = "UPDATE car SET CarName=?, BrandID=?, Price=?, Color=?, Description=?, Status=? WHERE CarID=?";
        String stockQuery = "UPDATE carstock SET Quantity=?, LastUpdated=NOW() WHERE CarID=?";
        String insertStock = "INSERT INTO carstock (BrandID, CarID, Quantity, LastUpdated) VALUES (?, ?, ?, NOW())";
        String imageMainQuery = "UPDATE carimage SET ImageURL=? WHERE CarID=? AND IsMain=1";
        String insertMainImage = "INSERT INTO carimage (CarID, ImageURL, IsMain) VALUES (?, ?, 1)";
        String deleteThumbsQuery = "DELETE FROM carimage WHERE CarID=? AND IsMain=0";
        String insertThumbQuery = "INSERT INTO carimage (CarID, ImageURL, IsMain) VALUES (?, ?, 0)";

        Connection con = null;

        try {
            con = Connect.getCon();
            con.setAutoCommit(false);

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

                if (carRows == 0) {
                    throw new Exception("Lỗi: Không tìm thấy CarID=" + car.getCarID() + " để cập nhật.");
                }
            }

            int affectedRows = 0;
            try (PreparedStatement stockPs = con.prepareStatement(stockQuery)) {
                stockPs.setInt(1, quantity);
                stockPs.setInt(2, car.getCarID());
                affectedRows = stockPs.executeUpdate();
                System.out.println(">>> [DAO] Cập nhật bảng carstock: " + affectedRows + " dòng.");
            }

            if (affectedRows == 0) {
                try (PreparedStatement insertPs = con.prepareStatement(insertStock)) {
                    insertPs.setInt(1, car.getBrandID());
                    insertPs.setInt(2, car.getCarID());
                    insertPs.setInt(3, quantity);
                    insertPs.executeUpdate();
                    System.out.println("ℹ️ [DAO] Chưa có tồn kho → Đã thêm mới stock cho CarID=" + car.getCarID());
                }
            }

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
            e.printStackTrace();
            if (con != null) try {
                con.rollback();
            } catch (Exception ignore) {
            }
            System.out.println("❌ [DAO] Update thất bại: " + e.getMessage());
            return false;
        } finally {
            if (con != null) try {
                con.setAutoCommit(true);
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

    public boolean deleteCar(int carID) {
        System.out.println(">>> [DAO] Chuẩn bị xóa xe CarID=" + carID);

        String deleteImageQuery = "DELETE FROM carimage WHERE CarID=?";
        String deleteStockQuery = "DELETE FROM carstock WHERE CarID=?";
        String deleteCarQuery = "DELETE FROM car WHERE CarID=?";
        String checkOrderQuery = "SELECT 1 FROM orderdetail WHERE CarID=? LIMIT 1";

        Connection con = null;

        try {
            con = Connect.getCon();
            con.setAutoCommit(false);

            try (PreparedStatement checkPs = con.prepareStatement(checkOrderQuery)) {
                checkPs.setInt(1, carID);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        System.err.println("❌ [DAO] Xóa thất bại: CarID=" + carID + " đã có trong OrderDetail.");
                        con.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement imagePs = con.prepareStatement(deleteImageQuery)) {
                imagePs.setInt(1, carID);
                int rows = imagePs.executeUpdate();
                System.out.println(">>> [DAO] Đã xóa " + rows + " ảnh liên quan.");
            }

            try (PreparedStatement stockPs = con.prepareStatement(deleteStockQuery)) {
                stockPs.setInt(1, carID);
                int rows = stockPs.executeUpdate();
                System.out.println(">>> [DAO] Đã xóa " + rows + " tồn kho liên quan.");
            }

            int carRows;
            try (PreparedStatement carPs = con.prepareStatement(deleteCarQuery)) {
                carPs.setInt(1, carID);
                carRows = carPs.executeUpdate();
                System.out.println(">>> [DAO] Đã xóa " + carRows + " bản ghi chính.");
            }

            if (carRows > 0) {
                con.commit();
                System.out.println("✅ [DAO] Xóa cứng thành công CarID=" + carID);
                return true;
            } else {
                con.rollback();
                System.err.println("❌ [DAO] Xóa thất bại: Không tìm thấy CarID=" + carID + ".");
                return false;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa xe. Tiến hành Rollback.", e);
            if (con != null) {
                try {
                    con.rollback();
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
        String sql = "SELECT BrandID, BrandName, LogoURL FROM brand ORDER BY BrandName";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Brand brand = new Brand();
                brand.setBrandID(rs.getInt("BrandID"));
                brand.setBrandName(rs.getString("BrandName"));
                brand.setLogoURL(rs.getString("LogoURL"));
                brands.add(brand);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách hãng xe.", e);
        }
        return brands;
    }

    public Map<Brand, List<Car>> getCarsGroupedByBrand() {
        Map<Brand, List<Car>> groupedCars = new LinkedHashMap<>();
        String sql = "SELECT b.BrandID, b.BrandName, b.LogoURL, "
                + "c.CarID, c.CarName, c.Price, "
                + "ci.ImageURL AS MainImageURL "
                + "FROM car c "
                + "JOIN brand b ON c.BrandID = b.BrandID "
                + "LEFT JOIN carimage ci ON c.CarID = ci.CarID AND ci.IsMain = 1 "
                + "WHERE c.Status = 'Available' "
                + "ORDER BY b.BrandName, c.CarName";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int brandID = rs.getInt("BrandID");
                String brandName = rs.getString("BrandName");
                String logoURL = rs.getString("LogoURL");
                Brand brand = new Brand(brandID, brandName, logoURL);

                Car car = new Car();
                car.setCarID(rs.getInt("CarID"));
                car.setCarName(rs.getString("CarName"));
                car.setBrandID(brandID);
                car.setPrice(rs.getBigDecimal("Price"));
                car.setMainImageURL(rs.getString("MainImageURL"));

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

    // ========== PHƯƠNG THỨC QUAN TRỌNG CHO TÌM KIẾM ==========
    /**
     * Lấy danh sách thương hiệu CÓ SẴN - Nếu không có filter: trả về tất cả
     * brand từ bảng brand - Nếu có filter: trả về brand có xe phù hợp với
     * filter
     */
    public List<String> getAvailableBrands(String keyword, String[] colors, Double minPrice, Double maxPrice) {
        // Kiểm tra xem có filter active không
        boolean hasActiveFilter = (keyword != null && !keyword.trim().isEmpty())
                || (colors != null && colors.length > 0)
                || (minPrice != null) || (maxPrice != null);

        // Nếu không có filter, trả về tất cả brand từ bảng brand
        if (!hasActiveFilter) {
            List<String> brands = new ArrayList<>();
            String sql = "SELECT BrandName FROM brand ORDER BY BrandName";

            try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    brands.add(rs.getString("BrandName"));
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách thương hiệu", e);
            }
            System.out.println("✅ [DAO] Không có filter - Trả về tất cả brand: " + brands);
            return brands;
        }

        // Nếu có filter, thực hiện query với filter
        List<String> brands = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT DISTINCT b.BrandName ");
        sql.append("FROM car c ");
        sql.append("JOIN brand b ON c.BrandID = b.BrandID ");
        sql.append("WHERE c.Status = 'Available' ");

        // Áp dụng các bộ lọc hiện tại
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (c.CarName LIKE ? OR b.BrandName LIKE ? OR c.Description LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (colors != null && colors.length > 0) {
            sql.append("AND (");
            for (int i = 0; i < colors.length; i++) {
                if (i > 0) {
                    sql.append(" OR ");
                }
                sql.append("c.Color = ?");
                params.add(colors[i]);
            }
            sql.append(") ");
        }

        if (minPrice != null) {
            sql.append("AND c.Price >= ? ");
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sql.append("AND c.Price <= ? ");
            params.add(maxPrice);
        }

        sql.append("ORDER BY b.BrandName");

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    brands.add(rs.getString("BrandName"));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách thương hiệu có sẵn", e);
        }

        // Nếu không tìm thấy brand nào (do filter quá chặt), vẫn trả về tất cả brand
        if (brands.isEmpty() && hasActiveFilter) {
            return getAvailableBrands(null, null, null, null);
        }

        System.out.println("✅ [DAO] Có filter - Trả về brand phù hợp: " + brands);
        return brands;
    }

    /**
     * Lấy danh sách màu sắc CÓ SẴN
     */
    public List<String> getAvailableColors(String keyword, String[] brands, Double minPrice, Double maxPrice) {
        // Kiểm tra xem có filter active không
        boolean hasActiveFilter = (keyword != null && !keyword.trim().isEmpty())
                || (brands != null && brands.length > 0)
                || (minPrice != null) || (maxPrice != null);

        // Nếu không có filter, trả về tất cả màu từ xe available
        if (!hasActiveFilter) {
            List<String> colors = new ArrayList<>();
            String sql = "SELECT DISTINCT Color FROM car WHERE Color IS NOT NULL AND Color != '' AND Status = 'Available' ORDER BY Color";

            try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    colors.add(rs.getString("Color"));
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách màu sắc", e);
            }
            return colors;
        }

        // Nếu có filter, thực hiện query với filter
        List<String> colors = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT DISTINCT c.Color ");
        sql.append("FROM car c ");
        sql.append("JOIN brand b ON c.BrandID = b.BrandID ");
        sql.append("WHERE c.Status = 'Available' AND c.Color IS NOT NULL AND c.Color != '' ");

        // Áp dụng các bộ lọc hiện tại
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (c.CarName LIKE ? OR b.BrandName LIKE ? OR c.Description LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (brands != null && brands.length > 0) {
            sql.append("AND (");
            for (int i = 0; i < brands.length; i++) {
                if (i > 0) {
                    sql.append(" OR ");
                }
                sql.append("b.BrandName = ?");
                params.add(brands[i]);
            }
            sql.append(") ");
        }

        if (minPrice != null) {
            sql.append("AND c.Price >= ? ");
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sql.append("AND c.Price <= ? ");
            params.add(maxPrice);
        }

        sql.append("ORDER BY c.Color");

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    colors.add(rs.getString("Color"));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách màu sắc có sẵn", e);
        }

        // Nếu không tìm thấy màu nào (do filter quá chặt), vẫn trả về tất cả màu
        if (colors.isEmpty() && hasActiveFilter) {
            return getAvailableColors(null, null, null, null);
        }

        return colors;
    }

    /**
     * Lấy giá cao nhất trong hệ thống (cho filter giá)
     */
    public double getMaxPrice() {
        String sql = "SELECT MAX(Price) as MaxPrice FROM car WHERE Status = 'Available'";
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("MaxPrice");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy giá cao nhất", e);
        }
        return 10000000000.0;
    }

    /**
     * Helper method để map ResultSet thành Car object
     */
   /**
 * Helper method để map ResultSet thành Car object - ĐÃ SỬA LỖI ẢNH
 */
private Car mapResultSetToCar(ResultSet rs) throws SQLException {
    Car car = new Car();
    car.setCarID(rs.getInt("CarID"));
    car.setCarName(rs.getString("CarName"));
    
    // Xử lý Price
    Object priceObj = rs.getObject("Price");
    if (priceObj instanceof BigDecimal) {
        car.setPrice((BigDecimal) priceObj);
    } else if (priceObj != null) {
        car.setPrice(new BigDecimal(priceObj.toString()));
    } else {
        car.setPrice(BigDecimal.ZERO);
    }

    car.setColor(rs.getString("Color"));
    car.setDescription(rs.getString("Description"));
    car.setStatus(rs.getString("Status"));
    car.setBrandID(rs.getInt("BrandID"));
    car.setBrandName(rs.getString("BrandName"));
    car.setQuantity(rs.getInt("Quantity"));

    // ⭐⭐⭐ SỬA QUAN TRỌNG: Xử lý ảnh nhất quán ⭐⭐⭐
    String mainImage = rs.getString("MainImageURL");
    
    System.out.println(">>> [DAO DEBUG] MainImageURL từ DB: " + mainImage);
    
    if (mainImage != null && !mainImage.trim().isEmpty()) {
     
        car.setMainImageURL(mainImage);
    } else {
        // Ảnh mặc định
        car.setMainImageURL("image/default-car.jpg");
    }
    
    System.out.println(">>> [DAO DEBUG] MainImageURL sau xử lý: " + car.getMainImageURL());

    return car;
}
    /**
     * Tìm kiếm xe với bộ lọc HOÀN CHỈNH
     */
    public List<Car> searchCarsWithFilters(String keyword, List<String> brands, List<String> colors,
            Double minPrice, Double maxPrice, String sortBy, String sortOrder) {
        List<Car> result = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT DISTINCT c.CarID, c.CarName, c.Price, c.Color, c.Description, c.Status, ")
                .append("b.BrandName, b.BrandID, ")
                .append("ci.ImageURL AS MainImageURL, ")
                .append("s.Quantity ")
                .append("FROM car c ")
                .append("JOIN brand b ON c.BrandID = b.BrandID ")
                .append("LEFT JOIN carimage ci ON c.CarID = ci.CarID AND ci.IsMain = 1 ")
                .append("LEFT JOIN carstock s ON c.CarID = s.CarID ")
                .append("WHERE c.Status = 'Available' ");

        // Lọc theo từ khóa
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (c.CarName LIKE ? OR b.BrandName LIKE ? OR c.Description LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Lọc theo hãng xe
        if (brands != null && !brands.isEmpty()) {
            sql.append("AND b.BrandName IN ("); // SỬA: Dùng IN thay cho chuỗi OR dài
            for (int i = 0; i < brands.size(); i++) {
                sql.append("?");
                if (i < brands.size() - 1) {
                    sql.append(", ");
                }
                params.add(brands.get(i));
            }
            sql.append(") ");
        }

        // Lọc theo màu sắc
        if (colors != null && !colors.isEmpty()) {
            sql.append("AND c.Color IN ("); // SỬA: Dùng IN thay cho chuỗi OR dài
            for (int i = 0; i < colors.size(); i++) {
                sql.append("?");
                if (i < colors.size() - 1) {
                    sql.append(", ");
                }
                params.add(colors.get(i));
            }
            sql.append(") ");
        }

        // Lọc theo giá
        if (minPrice != null) {
            sql.append("AND c.Price >= ? ");
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sql.append("AND c.Price <= ? ");
            params.add(maxPrice);
        }

        // Sắp xếp
        if (sortBy != null && !sortBy.isEmpty()) {
            switch (sortBy) {
                case "price":
                    sql.append("ORDER BY c.Price ");
                    break;
                case "name":
                    sql.append("ORDER BY c.CarName ");
                    break;
                case "brand":
                    sql.append("ORDER BY b.BrandName ");
                    break;
                case "newest":
                default:
                    sql.append("ORDER BY c.CarID ");
                    break; // SỬA: Thêm DESC/ASC vào phần sau
            }

            if ("desc".equalsIgnoreCase(sortOrder)) {
                sql.append("DESC ");
            } else {
                sql.append("ASC ");
            }
        } else {
            sql.append("ORDER BY c.CarID DESC ");
        }

        System.out.println("SQL: " + sql.toString());
        System.out.println("Params: " + params);

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                // SỬA LỖI QUAN TRỌNG: Phải sử dụng phương thức set phù hợp với kiểu dữ liệu
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Double) {
                    ps.setDouble(i + 1, (Double) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof BigDecimal) {
                    ps.setBigDecimal(i + 1, (BigDecimal) param);
                } else {
                    ps.setObject(i + 1, param);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(mapResultSetToCar(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm xe với bộ lọc: " + sql.toString(), e);
            e.printStackTrace();
        }
        return result;
    }
}
