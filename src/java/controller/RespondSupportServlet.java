package controller;

import dao.SupportRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserAccount;

import java.io.IOException;

@WebServlet(name = "RespondSupportServlet", urlPatterns = {"/RespondSupportServlet"})
public class RespondSupportServlet extends HttpServlet {

    private static final String ADMIN_SUPPORT_LIST = "AdminSupportServlet";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();

        String supportIDStr = request.getParameter("supportID");
        String responseText = request.getParameter("response");
        String newStatus = request.getParameter("status");

        // ⭐ KIỂM TRA DỮ LIỆU ĐẦU VÀO
        if (supportIDStr == null || supportIDStr.trim().isEmpty() ||
            responseText == null || responseText.trim().isEmpty() ||
            newStatus == null || newStatus.trim().isEmpty()) {
            
            session.setAttribute("errorMessage", "❌ Thiếu thông tin bắt buộc. Vui lòng kiểm tra lại.");
            response.sendRedirect(ADMIN_SUPPORT_LIST);
            return;
        }

        // 1. LẤY ADMIN ID TỪ SESSION - XỬ LÝ LINH HOẠT HƠN
        int adminID = 0;
        UserAccount adminUser = (UserAccount) session.getAttribute("admin");
        
        // ⭐ THÊM KIỂM TRA CHO USER THƯỜNG HOẶC ADMIN
        if (adminUser == null) {
            // Thử lấy từ attribute user thường (nếu có)
            adminUser = (UserAccount) session.getAttribute("user");
        }

        if (adminUser != null) {
            adminID = adminUser.getUserID();
            System.out.println("🔍 DEBUG - Admin/User ID: " + adminID);
        } else {
            // ⭐ FALLBACK: Sử dụng admin mặc định nếu không có session
            adminID = 1; // Hoặc giá trị mặc định của admin
            System.out.println("⚠️ WARNING - Sử dụng Admin ID mặc định: " + adminID);
        }

        int supportID = -1;

        try {
            supportID = Integer.parseInt(supportIDStr.trim());
            
            // ⭐ KIỂM TRA GIÁ TRỊ HỢP LỆ
            if (supportID <= 0) {
                throw new NumberFormatException("ID yêu cầu không hợp lệ");
            }

            SupportRequestDAO dao = new SupportRequestDAO();
            
            // ⭐ KIỂM TRA YÊU CẦU CÓ TỒN TẠI TRƯỚC KHI CẬP NHẬT
            if (dao.getSupportRequestById(supportID) == null) {
                session.setAttribute("errorMessage", "❌ Yêu cầu hỗ trợ #" + supportID + " không tồn tại.");
                response.sendRedirect(ADMIN_SUPPORT_LIST);
                return;
            }

            System.out.println("🔍 DEBUG - Cập nhật SupportRequest:");
            System.out.println("  - SupportID: " + supportID);
            System.out.println("  - Response: " + responseText.substring(0, Math.min(50, responseText.length())) + "...");
            System.out.println("  - Status: " + newStatus);
            System.out.println("  - AdminID: " + adminID);

            boolean updated = dao.respondToSupportRequest(supportID, responseText, newStatus, adminID);

            if (updated) {
                String successMsg = "✅ Yêu cầu #" + supportID + " đã được phản hồi và cập nhật trạng thái thành: " + getStatusVietnamese(newStatus);
                session.setAttribute("successMessage", successMsg);
                System.out.println("✅ SUCCESS - " + successMsg);
            } else {
                String errorMsg = "❌ Không thể cập nhật yêu cầu #" + supportID + ". Có thể do lỗi CSDL.";
                session.setAttribute("errorMessage", errorMsg);
                System.out.println("❌ ERROR - " + errorMsg);
            }

        } catch (NumberFormatException e) {
            String errorMsg = "❌ ID yêu cầu không hợp lệ: " + supportIDStr;
            session.setAttribute("errorMessage", errorMsg);
            System.out.println("❌ ERROR - " + errorMsg);
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = "❌ Lỗi hệ thống: " + e.getMessage();
            session.setAttribute("errorMessage", errorMsg);
            System.out.println("❌ ERROR - " + errorMsg);
        }

        // ⭐ SỬ DỤNG REDIRECT TƯƠNG ĐỐI ĐỂ TRÁNH LỖI CONTEXT PATH
        response.sendRedirect(ADMIN_SUPPORT_LIST);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ⭐ CHUYỂN HƯỚNG GET VỀ TRANG PHẢN HỒI VỚI THAM SỐ
        String supportID = request.getParameter("supportID");
        if (supportID != null && !supportID.trim().isEmpty()) {
            response.sendRedirect("admin-respond.jsp?supportID=" + supportID);
        } else {
            response.sendRedirect(ADMIN_SUPPORT_LIST);
        }
    }

    /**
     * ⭐ PHƯƠNG THỨC HIỆN THỊ TRẠNG THÁI TIẾNG VIỆT
     */
    private String getStatusVietnamese(String status) {
        switch (status) {
            case "Pending": return "Chờ xử lý";
            case "Responded": return "Đã phản hồi";
            case "Resolved": return "Đã giải quyết";
            case "Closed": return "Đã đóng";
            default: return status;
        }
    }

    @Override
    public String getServletInfo() {
        return "Xử lý phản hồi yêu cầu hỗ trợ từ Admin";
    }
}