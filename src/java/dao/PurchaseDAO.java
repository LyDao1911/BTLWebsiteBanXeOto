package dao;

import model.PurchaseInvoice;
import model.PurchaseInvoiceDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Car;

public class PurchaseDAO {

    private static final Logger LOGGER = Logger.getLogger(PurchaseDAO.class.getName());

    /**
     * BƯỚC 1: Lưu hóa đơn & chi tiết (transaction)
     * Trả về InvoiceID nếu thành công, hoặc -1 nếu thất bại.
     */
    public int addInvoiceAndDetails(PurchaseInvoice invoice, List<PurchaseInvoiceDetail> details) {
        Connection con = null;
        String invoiceSQL = "INSERT INTO purchaseinvoice (SupplierID, InvoiceDate, TotalAmount) VALUES (?, ?, ?)";
        String detailSQL = "INSERT INTO purchaseinvoicedetail (InvoiceID, CarID, Quantity, ImportPrice, Subtotal) VALUES (?, ?, ?, ?, ?)";
        int invoiceID = -1;

        try {
            con = Connect.getCon();
            con.setAutoCommit(false); // Bắt đầu transaction

            // 1️⃣ Thêm hóa đơn
            try (PreparedStatement psInvoice = con.prepareStatement(invoiceSQL, Statement.RETURN_GENERATED_KEYS)) {
                psInvoice.setInt(1, invoice.getSupplierID());
                psInvoice.setTimestamp(2, Timestamp.valueOf(invoice.getInvoiceDate()));
                psInvoice.setBigDecimal(3, invoice.getTotalAmount());
                psInvoice.executeUpdate();

                try (ResultSet rs = psInvoice.getGeneratedKeys()) {
                    if (rs.next()) {
                        invoiceID = rs.getInt(1);
                    }
                }
            }

            if (invoiceID == -1) {
                throw new SQLException("Không thể tạo InvoiceID mới.");
            }

            // 2️⃣ Thêm chi tiết hóa đơn
            try (PreparedStatement psDetail = con.prepareStatement(detailSQL)) {
                for (PurchaseInvoiceDetail detail : details) {
                    psDetail.setInt(1, invoiceID);
                    psDetail.setInt(2, detail.getCarID());
                    psDetail.setInt(3, detail.getQuantity());
                    psDetail.setBigDecimal(4, detail.getImportPrice());
                    psDetail.setBigDecimal(5, detail.getSubtotal());
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }

            con.commit();
            return invoiceID;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "❌ Lỗi SQL khi lưu hóa đơn hoặc chi tiết", e);
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "❌ Lỗi rollback transaction", ex);
                }
            }
            return -1;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Lỗi không xác định khi lưu hóa đơn", e);
            return -1;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.WARNING, "⚠️ Không thể đóng kết nối", ex);
                }
            }
        }
    }

    /**
     * BƯỚC 2: Cập nhật kho an toàn (UPSERT)
     * Sử dụng cú pháp MySQL: INSERT ... ON DUPLICATE KEY UPDATE
     * => Tránh race condition, tự động cộng dồn Quantity nếu đã tồn tại.
     */
    public boolean updateStock(Car car, int quantityToAdd) {
        String upsertSQL = """
            INSERT INTO carstock (BrandID, CarID, Quantity, LastUpdated)
            VALUES (?, ?, ?, NOW())
            ON DUPLICATE KEY UPDATE
                Quantity = Quantity + VALUES(Quantity),
                LastUpdated = NOW()
        """;

        try (Connection con = Connect.getCon();
             PreparedStatement ps = con.prepareStatement(upsertSQL)) {

            ps.setInt(1, car.getBrandID());
            ps.setInt(2, car.getCarID());
            ps.setInt(3, quantityToAdd);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                System.out.println("✅ [DAO] Cập nhật kho thành công cho CarID=" + car.getCarID() +
                                   " (+ " + quantityToAdd + " sản phẩm)");
                return true;
            } else {
                System.out.println("⚠️ [DAO] Không có thay đổi nào trong tồn kho CarID=" + car.getCarID());
                return false;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "❌ Lỗi SQL khi cập nhật tồn kho cho CarID=" + car.getCarID(), e);
            return false;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Lỗi không xác định khi cập nhật tồn kho", e);
            return false;
        }
    }
}
