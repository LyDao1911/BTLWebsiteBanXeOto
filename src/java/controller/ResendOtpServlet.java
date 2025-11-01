/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Random;

/**
 *
 * @author Hong Ly
 */
@WebServlet(name = "ResendOtpServlet", urlPatterns = {"/ResendOtpServlet"})
public class ResendOtpServlet extends HttpServlet {

     private String generateRandomOtp() {
        // Sử dụng String.format để đảm bảo luôn có 6 chữ số (giống DatHangServlet)
        return String.format("%06d", (int) (Math.random() * 1000000));
    }
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
        HttpSession session = request.getSession();
        String orderIdStr = request.getParameter("orderId");
        String amountStr = request.getParameter("amount");
        
        // 1. Kiểm tra tính hợp lệ cơ bản
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect("HomeServlet?message=Lỗi: Không tìm thấy mã đơn hàng.");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            
            // 2. Đồng bộ ID đơn hàng đang chờ xử lý (Rất Quan Trọng)
            // Đảm bảo ID đơn hàng đang chờ (trong session) khớp với ID gửi từ request.
            Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");
            
            // Nếu không khớp hoặc ID session đã bị xóa (hết hạn), không cho phép resend
            if (pendingOrderId == null || pendingOrderId.intValue() != orderId) {
                request.setAttribute("error", "Đơn hàng đã hết hạn hoặc không hợp lệ. Vui lòng đặt lại.");
                request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
                return;
            }

            // 3. TẠO OTP MỚI
            String newOtp = generateRandomOtp();
            
            // 4. LƯU OTP MỚI VÀO SESSION (GHI ĐÈ TÊN ATTRIBUTE CŨ)
            // Phải sử dụng tên "generatedOtp" để OrderProcessingServlet có thể so sánh.
            session.setAttribute("generatedOtp", newOtp); 
            
            // 5. CHUYỂN HƯỚNG VỀ TRANG NHẬP OTP
            // Truyền lại orderId, amount, và generatedOtp MỚI qua request attribute
            request.setAttribute("orderId", orderIdStr);
            request.setAttribute("amount", amountStr); 
            request.setAttribute("generatedOtp", newOtp); // Dùng để kích hoạt alert()
            
            // Thêm thông báo thông tin nếu cần
            request.setAttribute("info", "✅ Mã OTP mới đã được gửi thành công!"); 

            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);

        } catch (NumberFormatException e) {
             response.sendRedirect("HomeServlet?message=Lỗi: Mã đơn hàng không hợp lệ.");
        }
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
        doGet(request, response); 
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
