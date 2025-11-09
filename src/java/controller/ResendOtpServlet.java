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
        HttpSession session = request.getSession();

        // LẤY THÔNG TIN TỪ SESSION
        Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");
        String amount = (String) session.getAttribute("amount");

        System.out.println("=== RESEND OTP ===");
        System.out.println("PendingOrderId: " + pendingOrderId);
        System.out.println("Amount: " + amount);

        if (pendingOrderId == null) {
            System.out.println("ERROR: No pending order in session");
            response.sendRedirect(request.getContextPath() + "/DonMuaServlet");
            return;
        }

        // TẠO OTP MỚI
        String newOtp = String.format("%06d", new Random().nextInt(999999));
        long newExpireTime = System.currentTimeMillis() + (5 * 60 * 1000);

        // CẬP NHẬT SESSION
        session.setAttribute("generatedOtp", newOtp);
        session.setAttribute("otp_verificationExpireTime", newExpireTime);

        System.out.println("New OTP generated: " + newOtp);

        // CHUYỂN VỀ TRANG OTP
        request.setAttribute("info", "Mã OTP mới đã được gửi!");
        request.setAttribute("generatedOtp", newOtp);
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
