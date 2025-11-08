/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import dao.Connect;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import model.SupportRequest;
import model.UserAccount;

/**
 *
 * @author Admin
 */
@WebServlet(name = "MySupportServlet", urlPatterns = {"/MySupportServlet"})
public class MySupportServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MySupportServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MySupportServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserAccount user = (session != null) ? (UserAccount) session.getAttribute("userAccount") : null;

        System.out.println("=== DEBUG MYSUPPORTSERVLET ===");
        System.out.println("UserID: " + (user != null ? user.getUserID() : "null"));
        System.out.println("Username: " + (user != null ? user.getUsername() : "null"));
        System.out.println("FullName: " + (user != null ? user.getFullName() : "null"));

        if (user == null) {
            response.sendRedirect("dangnhap.jsp?error=Vui lòng đăng nhập để xem yêu cầu hỗ trợ.");
            return;
        }

        List<SupportRequest> requests = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = Connect.getCon();

            // CÁCH 1: Tìm CustomerID dựa trên username (vì bảng customer có userName)
            String findCustomerSql = "SELECT customerID FROM customer WHERE userName = ?";
            pstmt = conn.prepareStatement(findCustomerSql);
            pstmt.setString(1, user.getUsername());
            rs = pstmt.executeQuery();

            Integer customerId = null;
            if (rs.next()) {
                customerId = rs.getInt("customerID");
                System.out.println("Found CustomerID: " + customerId);
            } else {
                System.out.println("No customer found for username: " + user.getUsername());
            }
            rs.close();
            pstmt.close();

            // CÁCH 2: Nếu không tìm thấy CustomerID, tìm bằng email hoặc tên
            if (customerId == null) {
                String findCustomerAltSql = "SELECT customerID FROM customer WHERE email = ? OR fullName LIKE ?";
                pstmt = conn.prepareStatement(findCustomerAltSql);
                pstmt.setString(1, user.getUsername()); // Giả sử username là email
                pstmt.setString(2, "%" + user.getFullName() + "%");
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    customerId = rs.getInt("customerID");
                    System.out.println("Found CustomerID (alt): " + customerId);
                }
                rs.close();
                pstmt.close();
            }

            // CÁCH 3: Nếu vẫn không tìm thấy, tìm supportrequest trực tiếp bằng thông tin user
            if (customerId != null) {
                // Tìm bằng CustomerID
                String sql = "SELECT * FROM supportrequest WHERE CustomerID = ? ORDER BY CreatedAt DESC";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, customerId);
                System.out.println("Searching by CustomerID: " + customerId);
            } else {
                // Tìm bằng thông tin user (email, tên)
                String sql = "SELECT * FROM supportrequest WHERE Email = ? OR FullName LIKE ? ORDER BY CreatedAt DESC";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, user.getUsername()); // Giả sử username là email
                pstmt.setString(2, "%" + user.getFullName() + "%");
                System.out.println("Searching by Email/Name: " + user.getUsername() + ", " + user.getFullName());
            }

            rs = pstmt.executeQuery();

            int count = 0;
            while (rs.next()) {
                count++;
                SupportRequest req = new SupportRequest();
                req.setSupportID(rs.getInt("SupportID"));
                req.setCustomerID(rs.getInt("CustomerID"));
                req.setSubject(rs.getString("Subject"));

                Timestamp createdTimestamp = rs.getTimestamp("CreatedAt");
                if (createdTimestamp != null) {
                    req.setCreatedAt(createdTimestamp.toLocalDateTime());
                }

                req.setStatus(rs.getString("Status"));
                req.setMessage(rs.getString("Message"));
                req.setResponse(rs.getString("Response"));
                req.setFullName(rs.getString("FullName"));
                req.setEmail(rs.getString("Email"));
                req.setPhoneNumber(rs.getString("PhoneNumber"));
                req.setAddress(rs.getString("Address"));

                requests.add(req);

                System.out.println("Record " + count + ": SupportID=" + req.getSupportID()
                        + ", CustomerID=" + req.getCustomerID()
                        + ", Subject=" + req.getSubject());
            }

            System.out.println("Total requests found: " + requests.size());

        } catch (Exception e) {
            System.err.println("Database Error in MySupportServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi truy vấn dữ liệu: " + e.getMessage());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        request.setAttribute("supportRequests", requests);
        request.getRequestDispatcher("mySupport.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
