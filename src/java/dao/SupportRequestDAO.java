package dao;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.SupportRequest;

public class SupportRequestDAO {

    private Connection conn;

    public SupportRequestDAO() {
        conn = Connect.getCon();
    }

    // === 1. Thêm yêu cầu hỗ trợ ===
    public boolean insertSupportRequest(SupportRequest sr) {
        String sql = "INSERT INTO supportrequest (CustomerID, FullName, Email, PhoneNumber, Address, Subject, Message, CreatedAt, Status, Response, RespondentID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        System.out.println("🔍 DEBUG - Thực hiện INSERT SupportRequest:");
        System.out.println("CustomerID: " + sr.getCustomerID());
        System.out.println("FullName: " + sr.getFullName());
        System.out.println("Email: " + sr.getEmail());
        System.out.println("Subject: " + sr.getSubject());
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, sr.getCustomerID());
            ps.setString(2, sr.getFullName());
            ps.setString(3, sr.getEmail());
            ps.setString(4, sr.getPhoneNumber());
            ps.setString(5, sr.getAddress());
            ps.setString(6, sr.getSubject());
            ps.setString(7, sr.getMessage());
            ps.setTimestamp(8, Timestamp.valueOf(sr.getCreatedAt()));
            ps.setString(9, sr.getStatus());
            ps.setString(10, sr.getResponse());
            
            if (sr.getRespondentID() > 0) {
                ps.setInt(11, sr.getRespondentID());
            } else {
                ps.setNull(11, java.sql.Types.INTEGER);
            }
            
            int result = ps.executeUpdate();
            System.out.println("✅ INSERT SupportRequest result: " + result + " rows affected");
            
            return result > 0;
        } catch (SQLException e) {
            System.out.println("❌ Lỗi SQL khi insert SupportRequest: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // === 2. Lấy toàn bộ yêu cầu hỗ trợ ===
    public List<SupportRequest> getAllSupportRequests() {
        List<SupportRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM supportrequest ORDER BY CreatedAt DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SupportRequest sr = mapResultSetToSupportRequest(rs);
                list.add(sr);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // === 3. Cập nhật phản hồi ===
    public boolean updateResponse(int supportID, String responseText) {
        String sql = "UPDATE supportrequest SET Response = ?, Status = 'Resolved' WHERE SupportID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, responseText);
            ps.setInt(2, supportID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // === 4. Lấy yêu cầu theo ID ===
    public SupportRequest getSupportRequestById(int supportID) {
        String sql = "SELECT * FROM supportrequest WHERE SupportID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, supportID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToSupportRequest(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // === 5. Lấy yêu cầu theo CustomerID ===
    public List<SupportRequest> getSupportRequestsByCustomer(int customerID) {
        List<SupportRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM supportrequest WHERE CustomerID = ? ORDER BY CreatedAt DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SupportRequest sr = mapResultSetToSupportRequest(rs);
                list.add(sr);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // === Helper method để map ResultSet ===
    private SupportRequest mapResultSetToSupportRequest(ResultSet rs) throws SQLException {
        SupportRequest sr = new SupportRequest();
        sr.setSupportID(rs.getInt("SupportID"));
        sr.setCustomerID(rs.getInt("CustomerID"));
        sr.setFullName(rs.getString("FullName"));
        sr.setEmail(rs.getString("Email"));
        sr.setPhoneNumber(rs.getString("PhoneNumber"));
        sr.setAddress(rs.getString("Address"));
        sr.setSubject(rs.getString("Subject"));
        sr.setMessage(rs.getString("Message"));
        sr.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        sr.setStatus(rs.getString("Status"));
        sr.setResponse(rs.getString("Response"));
        
        int respondentID = rs.getInt("RespondentID");
        if (!rs.wasNull()) {
            sr.setRespondentID(respondentID);
        }
        
        return sr;
    }
}