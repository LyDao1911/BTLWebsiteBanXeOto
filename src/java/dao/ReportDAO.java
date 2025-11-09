/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.ReportDTO;
import model.ProductReportDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Hong Ly
 */
public class ReportDAO {

    private static final Logger LOGGER = Logger.getLogger(ReportDAO.class.getName());

    /**
     * Báo cáo 1 & 2: Lấy Doanh Thu và Lời/Lỗ (dùng Giá Vốn Trung Bình)
     */
    public List<ReportDTO> getProfitLossReport(Date startDate, Date endDate) {
        List<ReportDTO> reportList = new ArrayList<>();

        // Dùng WITH để tạo bảng tạm AvgCostPerCar (tính giá vốn TB)
        String sql = "WITH AvgCostPerCar AS ( "
                + "    SELECT CarID, AVG(ImportPrice) AS AvgCost "
                + "    FROM purchaseinvoicedetail "
                + "    GROUP BY CarID "
                + ") "
                + // Truy vấn chính
                "SELECT "
                + "    DATE(o.OrderDate) AS ReportDate, "
                + "    SUM(od.Subtotal) AS TotalRevenue, "
                + // Tổng doanh thu
                "    SUM(ac.AvgCost * od.Quantity) AS TotalCost "
                + // Tổng giá vốn (Giá TB * SL Bán)
                "FROM `order` o "
                + "JOIN orderdetail od ON o.OrderID = od.OrderID "
                + "LEFT JOIN AvgCostPerCar ac ON od.CarID = ac.CarID "
                + "WHERE o.OrderDate >= ? AND o.OrderDate <= ? "
                + // Lọc theo ngày
                "GROUP BY DATE(o.OrderDate) "
                + "ORDER BY ReportDate ASC";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, new java.sql.Timestamp(startDate.getTime()));
            ps.setTimestamp(2, new java.sql.Timestamp(endDate.getTime()));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReportDTO report = new ReportDTO();
                    report.setReportDate(rs.getDate("ReportDate"));
                    report.setTotalRevenue(rs.getBigDecimal("TotalRevenue"));
                    report.setTotalCost(rs.getBigDecimal("TotalCost") != null ? rs.getBigDecimal("TotalCost") : java.math.BigDecimal.ZERO);
                    reportList.add(report);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi ReportDAO.getProfitLossReport", e);
        }
        return reportList;
    }

    /**
     * Báo cáo 3: Lấy Top sản phẩm bán CHẠY
     */
    public List<ProductReportDTO> getBestSellingProducts(Date startDate, Date endDate, int limit) {
        List<ProductReportDTO> list = new ArrayList<>();
        String sql = "SELECT c.CarName, SUM(od.Quantity) AS TotalSold "
                + "FROM orderdetail od "
                + "JOIN car c ON od.CarID = c.CarID "
                + "JOIN `order` o ON od.OrderID = o.OrderID "
                + "WHERE o.OrderDate >= ? AND o.OrderDate <= ? "
                + "GROUP BY od.CarID "
                + "ORDER BY TotalSold DESC "
                + "LIMIT ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, new java.sql.Timestamp(startDate.getTime()));
            ps.setTimestamp(2, new java.sql.Timestamp(endDate.getTime()));
            ps.setInt(3, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductReportDTO item = new ProductReportDTO();
                    item.setCarName(rs.getString("CarName"));
                    item.setTotalSold(rs.getInt("TotalSold"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi ReportDAO.getBestSellingProducts", e);
        }
        return list;
    }

    /**
     * Báo cáo 4: Lấy Top sản phẩm bán CHẬM (hoặc không bán được)
     */
    public List<ProductReportDTO> getWorstSellingProducts(Date startDate, Date endDate, int limit) {
        List<ProductReportDTO> list = new ArrayList<>();
        // Lấy tất cả xe, LEFT JOIN với đơn hàng TRONG KHOẢNG THỜI GIAN
        String sql = "SELECT c.CarName, IFNULL(SUM(filtered_od.Quantity), 0) AS TotalSold "
                + "FROM car c "
                + "LEFT JOIN ( "
                + "    SELECT od.CarID, od.Quantity "
                + "    FROM orderdetail od "
                + "    JOIN `order` o ON od.OrderID = o.OrderID "
                + "    WHERE o.OrderDate >= ? AND o.OrderDate <= ? "
                + ") AS filtered_od ON c.CarID = filtered_od.CarID "
                + "GROUP BY c.CarID "
                + "ORDER BY TotalSold ASC "
                + "LIMIT ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, new java.sql.Timestamp(startDate.getTime()));
            ps.setTimestamp(2, new java.sql.Timestamp(endDate.getTime()));
            ps.setInt(3, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductReportDTO item = new ProductReportDTO();
                    item.setCarName(rs.getString("CarName"));
                    item.setTotalSold(rs.getInt("TotalSold"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi ReportDAO.getWorstSellingProducts", e);
        }
        return list;
    }
}
