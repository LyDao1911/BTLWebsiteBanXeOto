package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Random;

@WebServlet(name = "ResendOtpServlet", urlPatterns = {"/ResendOtpServlet"})
public class ResendOtpServlet extends HttpServlet {

    private String generateOtp() {
        return String.format("%06d", new Random().nextInt(999999));
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        
        // ✅ Lấy orderId từ parameter HOẶC từ session
        String orderId = request.getParameter("orderId");
        String amount = request.getParameter("amount");
        
        // Nếu không có orderId từ parameter, thử lấy từ session
        if (orderId == null || orderId.isEmpty()) {
            orderId = (String) session.getAttribute("currentOrderId");
        }
        if (amount == null || amount.isEmpty() || "null".equals(amount)) {
            Object amountObj = session.getAttribute("currentAmount");
            amount = (amountObj != null) ? amountObj.toString() : "";
        }

        // Debug
        System.out.println("ResendOtpServlet - orderId: " + orderId);
        System.out.println("ResendOtpServlet - amount: " + amount);

        if (orderId == null || orderId.isEmpty()) {
            request.setAttribute("error", "Không tìm thấy mã đơn hàng để gửi lại OTP!");
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            return;
        }

        String newOtp = generateOtp();

        // ✅ XÁC ĐỊNH LOẠI GIAO DỊCH
        boolean isPayment = (amount != null && !amount.isEmpty() && !amount.equals("null"));
        
        // ✅ CẬP NHẬT SESSION VỚI OTP MỚI
        session.setAttribute("generatedOtp", newOtp);
        session.setAttribute("otp_verificationExpireTime", System.currentTimeMillis() + 5 * 60 * 1000); // 5 phút

        // ✅ THÔNG BÁO OTP
        String message = "✅ Mã OTP mới đã được tạo thành công.";

        // Đặt thông tin để hiển thị trên JSP
        request.setAttribute("generatedOtp", newOtp);
        request.setAttribute("orderId", orderId);
        request.setAttribute("amount", amount);
        request.setAttribute("info", message);
        request.setAttribute("isPayment", isPayment);

        request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý yêu cầu gửi lại mã OTP cho cả đặt hàng và thanh toán.";
    }
}