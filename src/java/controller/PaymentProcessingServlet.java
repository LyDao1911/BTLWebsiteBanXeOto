package controller;

import dao.OrderDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import model.Payment;

@WebServlet(name = "PaymentProcessingServlet", urlPatterns = {"/PaymentProcessingServlet"})
public class PaymentProcessingServlet extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Nhận dữ liệu từ form OTP
        String orderId = request.getParameter("orderId");
        String otp_verificationInput = request.getParameter("otp_verification");
        String amountStr = request.getParameter("amount");

        // Lấy dữ liệu từ session
        HttpSession session = request.getSession();
        String generatedOtp = (String) session.getAttribute("generatedOtp");
        Long otp_verificationExpireTime = (Long) session.getAttribute("otp_verificationExpireTime");
        Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");

        // Kiểm tra thông tin phiên giao dịch
        if (orderId == null || otp_verificationInput == null || amountStr == null
                || pendingOrderId == null) {

            request.setAttribute("orderId", orderId);
            request.setAttribute("amount", amountStr);
            request.setAttribute("error", "Thiếu thông tin phiên giao dịch hoặc mã OTP không hợp lệ.");
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            return;
        }

        // Validation OTP
        long now = System.currentTimeMillis();
        if (otp_verificationExpireTime == null || now > otp_verificationExpireTime || generatedOtp == null) {
            request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã mới.");
            request.setAttribute("orderId", orderId);
            request.setAttribute("amount", amountStr);
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            return;
        }

        if (!otp_verificationInput.equals(generatedOtp)) {
            request.setAttribute("error", "Mã OTP không chính xác. Vui lòng thử lại.");
            request.setAttribute("orderId", orderId);
            request.setAttribute("amount", amountStr);
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            return;
        }

        // ✅ OTP HỢP LỆ: XỬ LÝ THANH TOÁN
        try {
            int orderIdInt = Integer.parseInt(orderId);
            BigDecimal paymentAmount = new BigDecimal(amountStr);

            // 1. CẬP NHẬT PaymentStatus trong bảng 'order' thành "Đã thanh toán"
            boolean orderUpdated = orderDAO.updatePaymentStatus(orderIdInt, "Đã thanh toán");

            // 2. TẠO BẢN GHI TRONG BẢNG 'payment'
            Payment payment = new Payment();
            payment.setOrderID(orderIdInt);
            payment.setPaymentDate(LocalDateTime.now());
            payment.setPaymentMethod("Thanh toán khi nhận hàng (Xác minh qua OTP)");
            payment.setAmount(paymentAmount);
            payment.setStatus("Đã thanh toán");

            boolean paymentRecorded = paymentDAO.createPayment(payment);

            if (orderUpdated && paymentRecorded) {
                // Xóa session OTP
                clearOtpSession(session);
                
                        // CHUYỂN HƯỚNG ĐẾN TRANG ĐƠN MUA - TAB ĐÃ THANH TOÁN
                        String redirectURL = request.getContextPath() + "/DonMuaServlet?tab=paid&paymentSuccess=true&orderId=" + orderIdInt;
                response.sendRedirect(redirectURL);
                return;
            } else {
                // Rollback nếu có lỗi
                if (orderUpdated) {
                    orderDAO.updatePaymentStatus(orderIdInt, "Chưa thanh toán");
                }
                request.setAttribute("error", "Xác nhận thành công nhưng ghi nhận thanh toán thất bại. Vui lòng liên hệ hỗ trợ.");
                request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String orderId = request.getParameter("orderId");
        String amountStr = request.getParameter("amount");
        String resend = request.getParameter("resend");

        HttpSession session = request.getSession();

        // 🆕 XỬ LÝ CHUẨN BỊ THANH TOÁN LẦN ĐẦU
        if (orderId != null && resend == null) {
            try {
                int orderIdInt = Integer.parseInt(orderId);

                // Lấy amount từ database nếu không có trong parameter
                if (amountStr == null) {
                    BigDecimal totalAmount = orderDAO.getOrderTotalAmount(orderIdInt);
                    if (totalAmount != null) {
                        amountStr = totalAmount.toString();
                    }
                }

                // Tạo OTP mới
                String newGeneratedOtp = String.format("%06d", (int) (Math.random() * 1000000));
                long newExpireTime = System.currentTimeMillis() + (5 * 60 * 1000);

                // Lưu session
                session.setAttribute("generatedOtp", newGeneratedOtp);
                session.setAttribute("otp_verificationExpireTime", newExpireTime);
                session.setAttribute("pendingOrderId", orderIdInt);

                // Chuyển đến trang OTP
                request.setAttribute("orderId", orderId);
                request.setAttribute("amount", amountStr);
                request.setAttribute("generatedOtp", newGeneratedOtp);
                request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
                return;

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Mã đơn hàng không hợp lệ.");
                request.getRequestDispatcher("donmua.jsp").forward(request, response);
                return;
            }
        }

        // 🔄 XỬ LÝ RESEND OTP (giữ nguyên)
        Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");

        if (pendingOrderId != null) {
            request.setAttribute("orderId", pendingOrderId);
            request.setAttribute("amount", amountStr);

            if ("true".equals(resend)) {
                String newGeneratedOtp = String.format("%06d", (int) (Math.random() * 1000000));
                long newExpireTime = System.currentTimeMillis() + (5 * 60 * 1000);

                session.setAttribute("generatedOtp", newGeneratedOtp);
                session.setAttribute("otp_verificationExpireTime", newExpireTime);

                request.setAttribute("generatedOtp", newGeneratedOtp);
                request.setAttribute("info", "Mã OTP mới đã được gửi lại.");
            }

            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/DonMuaServlet");
        }
    }

    private void clearOtpSession(HttpSession session) {
        session.removeAttribute("generatedOtp");
        session.removeAttribute("otp_verificationExpireTime");
        session.removeAttribute("pendingOrderId");
    }

    @Override
    public String getServletInfo() {
        return "Xử lý xác nhận OTP và thanh toán đơn hàng.";
    }
}
