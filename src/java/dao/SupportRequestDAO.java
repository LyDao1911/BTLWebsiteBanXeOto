package dao;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.SupportRequest;

public class SupportRequestDAO {

    // === PHƯƠNG THỨC HIỆN CÓ (GIỮ NGUYÊN) ===
    public boolean insertSupportRequest(SupportRequest sr) {
        String sql = "INSERT INTO supportrequest (CustomerID, FullName, Email, PhoneNumber, Address, Subject, Message, CreatedAt, Status, Response, RespondentID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        System.out.println("🔍 DEBUG - Thực hiện INSERT SupportRequest:");

        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SupportRequest sr = mapResultSetToSupportRequest(rs);
                list.add(sr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // === 3. LẤY YÊU CẦU THEO ID ===
    public SupportRequest getSupportRequestById(int supportID) {
        String sql = "SELECT * FROM supportrequest WHERE SupportID = ?";

        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, supportID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSupportRequest(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // === 4. Lấy yêu cầu theo CustomerID ===
    public List<SupportRequest> getSupportRequestsByCustomer(int customerID) {
        List<SupportRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM supportrequest WHERE CustomerID = ? ORDER BY CreatedAt DESC";

        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SupportRequest sr = mapResultSetToSupportRequest(rs);
                    list.add(sr);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // === 5. PHƯƠNG THỨC CẬP NHẬT PHẢN HỒI - PHIÊN BẢN DUY NHẤT (ĐÃ GỘP DEBUG) ===
    public boolean respondToSupportRequest(int supportID, String responseText, String newStatus, int adminID) {
        System.out.println("🔍 DEBUG DAO - respondToSupportRequest:");
        System.out.println("  - SupportID: " + supportID);
        System.out.println("  - Status: " + newStatus);
        System.out.println("  - AdminID: " + adminID);
        System.out.println("  - Response length: " + (responseText != null ? responseText.length() : "null"));

        // SQL cập nhật
        String sql = "UPDATE supportrequest SET Response = ?, Status = ?, RespondentID = ? WHERE SupportID = ?";

        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, responseText);
            ps.setString(2, newStatus);
            ps.setInt(3, adminID);
            ps.setInt(4, supportID);

            int rowsAffected = ps.executeUpdate();
            System.out.println("✅ DAO RESULT - Rows affected: " + rowsAffected);

            if (rowsAffected > 0) {
                System.out.println("✅ Cập nhật SupportRequest #" + supportID + " thành công!");
            } else {
                System.out.println("⚠️ Cảnh báo: Không có dòng nào được cập nhật cho SupportRequest #" + supportID);
            }

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("❌ DAO ERROR - SQLException: " + e.getMessage());
            System.out.println("❌ DAO ERROR - SQLState: " + e.getSQLState());
            System.out.println("❌ DAO ERROR - VendorError: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.out.println("❌ DAO ERROR - General exception: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // === 6. PHƯƠNG THỨC MỚI: Cập nhật trạng thái ===
    public boolean updateSupportStatus(int supportID, String newStatus) {
        String sql = "UPDATE supportrequest SET Status = ? WHERE SupportID = ?";

        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, supportID);

            int rowsAffected = ps.executeUpdate();
            System.out.println("✅ Cập nhật trạng thái SupportRequest #" + supportID + " thành: " + newStatus);
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi cập nhật trạng thái: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // === 7. PHƯƠNG THỨC MỚI: Xóa yêu cầu hỗ trợ ===
    public boolean deleteSupportRequest(int supportID) {
        String sql = "DELETE FROM supportrequest WHERE SupportID = ?";

        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, supportID);
            int rowsAffected = ps.executeUpdate();
            System.out.println("✅ Đã xóa SupportRequest #" + supportID + ": " + rowsAffected + " dòng bị ảnh hưởng");
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi xóa SupportRequest: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // === 8. PHƯƠNG THỨC MỚI: Đếm số yêu cầu theo trạng thái ===
    public int countSupportRequestsByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM supportrequest WHERE Status = ?";

        try (Connection conn = Connect.getCon(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi đếm yêu cầu theo trạng thái: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
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

        // Xử lý CreatedAt
        Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
        if (createdAtTimestamp != null) {
            sr.setCreatedAt(createdAtTimestamp.toLocalDateTime());
        }

        sr.setStatus(rs.getString("Status"));
        sr.setResponse(rs.getString("Response"));

        // Xử lý RespondentID
        int respondentID = rs.getInt("RespondentID");
        if (!rs.wasNull()) {
            sr.setRespondentID(respondentID);
        }

        return sr;
    }
}
