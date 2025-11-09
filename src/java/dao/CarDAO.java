/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import com.mysql.cj.jdbc.result.ResultSetMetaData;
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
                    car = new Car();
                    car.setCarID(rs.getInt("CarID"));
                    car.setCarName(rs.getString("CarName"));
                    car.setBrandID(rs.getInt("BrandID"));
                    car.setBrandName(rs.getString("BrandName"));
                    car.setPrice(rs.getBigDecimal("Price"));
                    car.setColor(rs.getString("Color"));
                    car.setDescription(rs.getString("Description"));
                    car.setStatus(rs.getString("Status"));
                    car.setQuantity(rs.getInt("Quantity"));
                    String mainImage = rs.getString("MainImageURL");
                    if (mainImage != null && !mainImage.startsWith("uploads/")) {
                        // Sửa lỗi logic đường dẫn ảnh (giữ nguyên logic gốc của bạn, nhưng cần đảm bảo nó khớp với mapResultSetToCar)
                        mainImage = mainImage;
                    }
                    car.setMainImageURL(mainImage);
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
    public List<Car> searchCarsWithFilters(String keyword, List<String> brands, List<String> colors,
            Double minPrice, Double maxPrice, String sortBy, String sortOrder) {
        List<Car> result = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        // ⭐ SỬA LỖI 1: THÊM MainImageURL VÀ JOIN BẢNG carimage
        StringBuilder sql = new StringBuilder(
                "SELECT c.CarID, c.CarName, c.BrandID, c.Price, c.Color, "
                + "c.Description, c.Status, s.Quantity, b.BrandName, "
                + "MAX(ci.ImageURL) AS MainImageURL "
                + // Dùng MAX để lấy 1 ảnh bất kỳ
                "FROM car c "
                + "JOIN brand b ON c.BrandID = b.BrandID "
                + "LEFT JOIN carstock s ON c.CarID = s.CarID "
                + "LEFT JOIN carimage ci ON c.CarID = ci.CarID AND ci.IsMain = 1 "
                + "GROUP BY c.CarID, c.CarName, c.BrandID, c.Price, c.Color, "
                + "c.Description, c.Status, s.Quantity, b.BrandName " // Group by tất cả cột không aggregate
        );

        StringBuilder whereClause = new StringBuilder();

        // 1. Keyword
        if (keyword != null && !keyword.trim().isEmpty()) {
            whereClause.append("c.CarName LIKE ? ");
            params.add("%" + keyword + "%");
        }

        // 2. Brands
        if (brands != null && !brands.isEmpty()) {
            if (whereClause.length() > 0) {
                whereClause.append("AND ");
            }
            whereClause.append("b.BrandName IN (");
            for (int i = 0; i < brands.size(); i++) {
                whereClause.append("?");
                if (i < brands.size() - 1) {
                    whereClause.append(",");
                }
                params.add(brands.get(i));
            }
            whereClause.append(") ");
        }

        // 3. Colors
        if (colors != null && !colors.isEmpty()) {
            if (whereClause.length() > 0) {
                whereClause.append("AND ");
            }
            whereClause.append("c.Color IN (");
            for (int i = 0; i < colors.size(); i++) {
                whereClause.append("?");
                if (i < colors.size() - 1) {
                    whereClause.append(",");
                }
                params.add(colors.get(i));
            }
            whereClause.append(") ");
        }

        // 4. Min Price
        if (minPrice != null) {
            if (whereClause.length() > 0) {
                whereClause.append("AND ");
            }
            whereClause.append("c.Price >= ? ");
            params.add(minPrice);
        }

        // 5. Max Price
        if (maxPrice != null) {
            if (whereClause.length() > 0) {
                whereClause.append("AND ");
            }
            whereClause.append("c.Price <= ? ");
            params.add(maxPrice);
        }

        if (whereClause.length() > 0) {
            sql.append("WHERE ").append(whereClause);
        }

        // 6. Sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append("ORDER BY ");
            if ("price".equals(sortBy)) {
                sql.append("c.Price ");
            } else if ("newest".equals(sortBy)) {
                sql.append("c.CarID "); // Giả sử CarID mới nhất là ID cao nhất
            } else {
                sql.append("c.CarID "); // Mặc định
            }

            if ("desc".equals(sortOrder)) {
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
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm xe với bộ lọc", e);
            e.printStackTrace();
        }

        return result;
    }

    /**
     * Hàm trợ giúp map ResultSet to Car (An toàn)
     */
    private Car mapResultSetToCar(ResultSet rs) throws SQLException {
        Car car = new Car();
        car.setCarID(rs.getInt("CarID"));
        car.setCarName(rs.getString("CarName"));
        car.setBrandID(rs.getInt("BrandID"));
        car.setPrice(rs.getBigDecimal("Price"));
        car.setColor(rs.getString("Color"));
        car.setDescription(rs.getString("Description"));
        car.setStatus(rs.getString("Status"));

        // ⭐ SỬA LỖI 2: THÊM CÁC CỘT TỪ JOIN VÀO MAPPER
        // (Dùng hàm hasColumn để kiểm tra, phòng khi hàm này được gọi bởi 1 query khác)
        if (hasColumn(rs, "Quantity")) {
            car.setQuantity(rs.getInt("Quantity"));
        }
        if (hasColumn(rs, "BrandName")) {
            car.setBrandName(rs.getString("BrandName"));
        }
        if (hasColumn(rs, "MainImageURL")) { // Thêm hàm set ảnh
            car.setMainImageURL(rs.getString("MainImageURL"));
        }

        return car;
    }

    /**
     * Hàm trợ giúp kiểm tra sự tồn tại của cột trong ResultSet
     */
    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData rsmd = (ResultSetMetaData) rs.getMetaData();
        int columns = rsmd.getColumnCount();
        for (int x = 1; x <= columns; x++) {
            if (columnName.equalsIgnoreCase(rsmd.getColumnName(x))) {
                return true;
            }
        }
        return false;
    }

    // Lấy các brand CÒN TỒN TẠI sau khi lọc (để làm mờ bộ lọc)
    public List<String> getAvailableBrands(String keyword, String[] colors,
            Double minPrice, Double maxPrice) {
        List<String> result = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT DISTINCT b.BrandName "
                + "FROM car c "
                + "JOIN brand b ON c.BrandID = b.BrandID "
        );
        StringBuilder whereClause = new StringBuilder();

        // Lọc theo Keyword, Color, Price (NHƯNG BỎ QUA BRAND)
        if (keyword != null && !keyword.trim().isEmpty()) {
            whereClause.append("c.CarName LIKE ? ");
            params.add("%" + keyword + "%");
        }
        if (colors != null && colors.length > 0) {
            if (whereClause.length() > 0) {
                whereClause.append("AND ");
            }
            whereClause.append("c.Color IN (");
            for (int i = 0; i < colors.length; i++) {
                whereClause.append("?");
                if (i < colors.length - 1) {
                    whereClause.append(",");
                }
                params.add(colors[i]);
            }
            whereClause.append(") ");
        }
        if (minPrice != null) {
            if (whereClause.length() > 0) {
                whereClause.append("AND ");
            }
            whereClause.append("c.Price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            if (whereClause.length() > 0) {
                whereClause.append("AND ");
            }
            whereClause.append("c.Price <= ? ");
            params.add(maxPrice);
        }

        if (whereClause.length() > 0) {
            sql.append("WHERE ").append(whereClause);
        }
        sql.append("ORDER BY b.BrandName");

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Double) {
                    ps.setDouble(i + 1, (Double) param);
                } else {
                    ps.setObject(i + 1, param);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(rs.getString("BrandName"));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy available brands", e);
        }
        return result;
    }

    // Lấy các color CÒN TỒN TẠI sau khi lọc
    public List<String> getAvailableColors(String keyword, String[] brands,
            Double minPrice, Double maxPrice) {
        List<String> result = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT DISTINCT c.Color "
                + "FROM car c "
                + "JOIN brand b ON c.BrandID = b.BrandID "
        );
        StringBuilder whereClause = new StringBuilder();

        // Lọc theo Keyword, Brand, Price (NHƯNG BỎ QUA COLOR)
        if (keyword != null && !keyword.trim().isEmpty()) {
            whereClause.append("c.CarName LIKE ? ");
            params.add("%" + keyword + "%");
        }
        if (brands != null && brands.length > 0) {
            if (whereClause.length() > 0) {
                whereClause.append("AND ");
            }
            whereClause.append("b.BrandName IN (");
            for (int i = 0; i < brands.length; i++) {
                whereClause.append("?");
                if (i < brands.length - 1) {
                    whereClause.append(",");
                }
                params.add(brands[i]);
            }
            whereClause.append(") ");
        }
        if (minPrice != null) {
            if (whereClause.length() > 0) {
                whereClause.append("AND ");
            }
            whereClause.append("c.Price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            if (whereClause.length() > 0) {
                whereClause.append("AND ");
            }
            whereClause.append("c.Price <= ? ");
            params.add(maxPrice);
        }

        if (whereClause.length() > 0) {
            sql.append("WHERE ").append(whereClause);
        }
        sql.append("ORDER BY c.Color");

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Double) {
                    ps.setDouble(i + 1, (Double) param);
                } else {
                    ps.setObject(i + 1, param);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(rs.getString("Color"));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy available colors", e);
        }
        return result;
    }

    // Lấy giá cao nhất trong hệ thống
    public double getMaxPrice() {
        String sql = "SELECT MAX(Price) FROM car";
        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy max price", e);
        }
        return 0; // Trả về 0 nếu có lỗi
    }
}
