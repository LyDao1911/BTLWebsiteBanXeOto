package dao;

import java.sql.*;
import java.util.*;
import java.util.logging.*;
import model.PurchaseInvoiceDetail;

public class PurchaseInvoiceDetailDAO {
    private static final Logger LOGGER = Logger.getLogger(PurchaseInvoiceDetailDAO.class.getName());
    
    public List<PurchaseInvoiceDetail> getAllInvoiceDetails() {
        List<PurchaseInvoiceDetail> list = new ArrayList<>();
        String query = "SELECT * FROM purchaseinvoicedetail ORDER BY DetailID DESC";
        
        try (Connection con = Connect.getCon(); 
             PreparedStatement ps = con.prepareStatement(query); 
             ResultSet rs = ps.executeQuery()) {
            
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
        
        try (Connection con = Connect.getCon(); 
             PreparedStatement ps = con.prepareStatement(query)) {
            
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
        
        try (Connection con = Connect.getCon(); 
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, detailId);
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa chi tiết phiếu nhập: " + detailId, e);
            return false;
        }
    }
    
    public boolean addInvoiceDetail(PurchaseInvoiceDetail detail) {
        String query = "INSERT INTO purchaseinvoicedetail (InvoiceID, CarID, Quantity, ImportPrice, Subtotal) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection con = Connect.getCon(); 
             PreparedStatement ps = con.prepareStatement(query)) {
            
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
        
        try (Connection con = Connect.getCon(); 
             PreparedStatement ps = con.prepareStatement(query)) {
            
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
}