package dao;

import java.sql.*;
import java.util.*;
import java.util.logging.*;
import java.util.stream.Collectors;
import model.PurchaseInvoiceDetail;

public class PurchaseInvoiceDetailDAO {

    private static final Logger LOGGER = Logger.getLogger(PurchaseInvoiceDetailDAO.class.getName());

    public List<PurchaseInvoiceDetail> getAllInvoiceDetails() {
        List<PurchaseInvoiceDetail> list = new ArrayList<>();
        String query = "SELECT * FROM purchaseinvoicedetail ORDER BY DetailID DESC";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                PurchaseInvoiceDetail detail = new PurchaseInvoiceDetail();
                detail.setDetailID(rs.getInt("DetailID"));
                detail.setInvoiceID(rs.getInt("InvoiceID"));
                detail.setCarID(rs.getInt("CarID"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setImportPrice(rs.getBigDecimal("ImportPrice"));
                detail.setSubtotal(rs.getBigDecimal("Subtotal"));

                list.add(detail);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách chi tiết phiếu nhập", e);
        }
        return list;
    }

    public PurchaseInvoiceDetail getInvoiceDetailById(int detailId) {
        String query = "SELECT * FROM purchaseinvoicedetail WHERE DetailID = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, detailId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PurchaseInvoiceDetail detail = new PurchaseInvoiceDetail();
                    detail.setDetailID(rs.getInt("DetailID"));
                    detail.setInvoiceID(rs.getInt("InvoiceID"));
                    detail.setCarID(rs.getInt("CarID"));
                    detail.setQuantity(rs.getInt("Quantity"));
                    detail.setImportPrice(rs.getBigDecimal("ImportPrice"));
                    detail.setSubtotal(rs.getBigDecimal("Subtotal"));
                    return detail;
                }
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy chi tiết phiếu nhập theo ID: " + detailId, e);
        }
        return null;
    }

    public boolean deleteInvoiceDetail(int detailId) {
        String query = "DELETE FROM purchaseinvoicedetail WHERE DetailID = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, detailId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa chi tiết phiếu nhập: " + detailId, e);
            return false;
        }
    }

    public boolean addInvoiceDetail(PurchaseInvoiceDetail detail) {
        String query = "INSERT INTO purchaseinvoicedetail (InvoiceID, CarID, Quantity, ImportPrice, Subtotal) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, detail.getInvoiceID());
            ps.setInt(2, detail.getCarID());
            ps.setInt(3, detail.getQuantity());
            ps.setBigDecimal(4, detail.getImportPrice());
            ps.setBigDecimal(5, detail.getSubtotal());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm chi tiết phiếu nhập", e);
            return false;
        }
    }

    public boolean updateInvoiceDetail(PurchaseInvoiceDetail detail) {
        String query = "UPDATE purchaseinvoicedetail SET InvoiceID = ?, CarID = ?, Quantity = ?, ImportPrice = ?, Subtotal = ? WHERE DetailID = ?";

        try (Connection con = Connect.getCon(); PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, detail.getInvoiceID());
            ps.setInt(2, detail.getCarID());
            ps.setInt(3, detail.getQuantity());
            ps.setBigDecimal(4, detail.getImportPrice());
            ps.setBigDecimal(5, detail.getSubtotal());
            ps.setInt(6, detail.getDetailID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật chi tiết phiếu nhập: " + detail.getDetailID(), e);
            return false;
        }
    }
    // Thêm vào class PurchaseInvoiceDetailDAO

    public boolean deleteMultipleDetails(List<Integer> detailIds) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = Connect.getCon();

            if (detailIds == null || detailIds.isEmpty()) {
                return false;
            }

            // Tạo câu query với nhiều placeholders
            String placeholders = detailIds.stream()
                    .map(id -> "?")
                    .collect(Collectors.joining(","));

            String sql = "DELETE FROM PurchaseInvoiceDetail WHERE DetailID IN (" + placeholders + ")";

            stmt = conn.prepareStatement(sql);

            // Set parameters
            for (int i = 0; i < detailIds.size(); i++) {
                stmt.setInt(i + 1, detailIds.get(i));
            }

            int rowsAffected = stmt.executeUpdate();

            System.out.println("DEBUG: Đã xóa " + rowsAffected + " chi tiết phiếu nhập.");

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi xóa nhiều chi tiết phiếu nhập: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            // Đóng resources
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("Lỗi khi đóng kết nối: " + e.getMessage());
            }
        }
    }
}
