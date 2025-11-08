package controller;

import dao.Connect;
import dao.CustomerDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserAccount;
import model.Customer;

@WebServlet(name = "HotroServlet", urlPatterns = {"/HotroServlet"})
public class HotroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // === DEBUG CHI TIẾT SESSION ===
        HttpSession session = request.getSession(false);
        System.out.println("=== DEBUG SESSION IN HOTROSERVLET ===");
        System.out.println("Session object: " + session);
        
        if (session != null) {
            System.out.println("Session ID: " + session.getId());
            System.out.println("All session attributes:");
            
            java.util.Enumeration<String> attributeNames = session.getAttributeNames();
            while (attributeNames.hasMoreElements()) {
                String name = attributeNames.nextElement();
                Object value = session.getAttribute(name);
                System.out.println(" - " + name + " = " + value);
            }
        } else {
            System.out.println("No session found!");
        }

        // === KIỂM TRA ĐĂNG NHẬP - SỬA LẠI ===
        // Kiểm tra userAccount từ session đăng nhập
        UserAccount userAccount = (session != null) ? (UserAccount) session.getAttribute("userAccount") : null;
        
        if (userAccount == null) {
            System.out.println("ACCESS DENIED: User is not logged in. Redirecting to login page.");
            response.sendRedirect("dangnhap.jsp?error=Vui lòng đăng nhập để gửi yêu cầu hỗ trợ."); 
            return; 
        }

        // Lấy thông tin Customer từ database dựa trên username
        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerByUsername(userAccount.getUsername());
        
        if (customer == null) {
            System.out.println("ERROR: Customer not found for username: " + userAccount.getUsername());
            response.sendRedirect("hotro.jsp?message=error&detail=Không tìm thấy thông tin khách hàng");
            return;
        }

        System.out.println("Found customer: " + customer);

        // Lấy thông tin từ form
        String fullName = request.getParameter("hoten");
        String email = request.getParameter("email");
        String phone = request.getParameter("sdt");
        String address = request.getParameter("diachi");
        String subject = request.getParameter("subject");
        String messageContent = request.getParameter("noidung");

        System.out.println("=== DEBUG SUPPORT REQUEST ===");
        System.out.println("CustomerID: " + customer.getCustomerID());
        System.out.println("Username: " + userAccount.getUsername());
        System.out.println("FullName: " + fullName);
        System.out.println("Email: " + email);
        System.out.println("Phone: " + phone);
        System.out.println("Subject: " + subject);

        // Validation cơ bản
        if (fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || subject == null || subject.trim().isEmpty()
                || messageContent == null || messageContent.trim().isEmpty()) {

            System.out.println("VALIDATION FAILED: Missing required fields");
            response.sendRedirect("hotro.jsp?message=validation_error");
            return;
        }

        // Clean data
        fullName = fullName.trim();
        email = email.trim();
        phone = phone.trim();
        subject = subject.trim();
        messageContent = messageContent.trim();
        address = address != null ? address.trim() : "";

        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        String errorMessage = "";

        try {
            conn = Connect.getCon();
            if (conn == null) {
                System.out.println("DATABASE CONNECTION FAILED");
                errorMessage = "Database connection failed";
                throw new Exception("Cannot connect to database");
            }
            System.out.println("Database connected successfully");

            // SQL sử dụng CustomerID từ bảng Customer
            String sql = "INSERT INTO supportrequest (CustomerID, FullName, Email, PhoneNumber, Address, Subject, Message, CreatedAt, Status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending')";

            System.out.println("SQL: " + sql);

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, customer.getCustomerID()); // Sử dụng CustomerID từ bảng Customer
            pstmt.setString(2, fullName);
            pstmt.setString(3, email);
            pstmt.setString(4, phone);
            pstmt.setString(5, address);
            pstmt.setString(6, subject);
            pstmt.setString(7, messageContent);
            pstmt.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));

            System.out.println("Executing update...");
            int rows = pstmt.executeUpdate();
            success = rows > 0;
            System.out.println("Rows affected: " + rows);

        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            success = false;
            errorMessage = e.getMessage().contains("Duplicate entry") 
                ? "Lỗi hệ thống: Yêu cầu hỗ trợ đã được gửi gần đây. Vui lòng thử lại sau." 
                : "Lỗi hệ thống: " + e.getMessage();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        if (success) {
            System.out.println("SUCCESS - Redirecting to success page");
            response.sendRedirect("hotro.jsp?message=success");
        } else {
            System.out.println("FAILED - Redirecting to error page");
            response.sendRedirect("hotro.jsp?message=error&detail=" + java.net.URLEncoder.encode(errorMessage, "UTF-8"));
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý yêu cầu hỗ trợ khách hàng";
    }
}