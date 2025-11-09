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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== PAYMENT PROCESSING GET (THANH TOÁN ĐƠN MUA) ===");

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String orderId = request.getParameter("orderId");
        String amountStr = request.getParameter("amount");
        String resend = request.getParameter("resend");

        HttpSession session = request.getSession();

        System.out.println("OrderId: " + orderId);
        System.out.println("Amount: " + amountStr);
        System.out.println("Resend: " + resend);

        // ✅ ĐÁNH DẤU ĐÂY LÀ LUỒNG THANH TOÁN ĐƠN MUA
        session.setAttribute("isNewOrder", false);

        if (orderId == null || orderId.trim().isEmpty()) {
            System.out.println("ERROR: OrderId is null");
            session.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/DonMuaServlet");
            return;
        }

        try {
            int orderIdInt = Integer.parseInt(orderId);

            // Lấy amount từ database nếu không có
            if (amountStr == null || amountStr.trim().isEmpty()) {
                BigDecimal totalAmount = orderDAO.getOrderTotalAmount(orderIdInt);
                if (totalAmount != null) {
                    amountStr = totalAmount.toString();
                    System.out.println("Lấy amount từ DB: " + amountStr);
                } else {
                    session.setAttribute("errorMessage", "Không thể lấy thông tin số tiền thanh toán.");
                    response.sendRedirect(request.getContextPath() + "/DonMuaServlet");
                    return;
                }
            }

            // Tạo OTP mới (trừ khi là resend)
            String newOtp;
            if (!"true".equals(resend)) {
                newOtp = generateNewOtp();
                long newExpireTime = System.currentTimeMillis() + (5 * 60 * 1000);

                session.setAttribute("generatedOtp", newOtp);
                session.setAttribute("otp_verificationExpireTime", newExpireTime);
                session.setAttribute("pendingOrderId", orderIdInt);
                session.setAttribute("amount", amountStr);

                System.out.println("Tạo OTP mới: " + newOtp);
            } else {
                newOtp = (String) session.getAttribute("generatedOtp");
                System.out.println("Giữ OTP cũ: " + newOtp);
            }

            // Chuyển đến trang OTP
            request.setAttribute("orderId", orderId);
            request.setAttribute("amount", amountStr);
            request.setAttribute("generatedOtp", newOtp);
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/DonMuaServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== PAYMENT PROCESSING POST (THANH TOÁN ĐƠN MUA) ===");

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Nhận dữ liệu từ form OTP
        String orderId = request.getParameter("orderId");
        String otpInput = request.getParameter("otp_verification");
        String amountStr = request.getParameter("amount");

        System.out.println("Form data - OrderId: " + orderId + ", OTP: " + otpInput + ", Amount: " + amountStr);

        // Lấy dữ liệu từ session
        HttpSession session = request.getSession();
        String generatedOtp = (String) session.getAttribute("generatedOtp");
        Long otpExpireTime = (Long) session.getAttribute("otp_verificationExpireTime");
        Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");

        System.out.println("Session data - PendingOrderId: " + pendingOrderId + ", GeneratedOTP: " + generatedOtp);

        // 🛑 VALIDATION
        if (orderId == null || orderId.trim().isEmpty()) {
            System.out.println("ERROR: OrderId is null");
            setErrorAndForward(request, response, orderId, amountStr, "Mã đơn hàng không hợp lệ.");
            return;
        }

        if (otpInput == null || otpInput.trim().isEmpty()) {
            System.out.println("ERROR: OTP input is empty");
            setErrorAndForward(request, response, orderId, amountStr, "Vui lòng nhập mã OTP.");
            return;
        }

        if (pendingOrderId == null) {
            System.out.println("ERROR: Session expired - pendingOrderId is null");
            setErrorAndForward(request, response, orderId, amountStr, "Phiên giao dịch đã hết hạn. Vui lòng thử lại.");
            return;
        }

        // 🛑 Kiểm tra OTP hết hạn
        long now = System.currentTimeMillis();
        if (otpExpireTime == null || now > otpExpireTime) {
            System.out.println("ERROR: OTP expired");
            setErrorAndForward(request, response, orderId, amountStr, "Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã mới.");
            return;
        }

        if (generatedOtp == null) {
            System.out.println("ERROR: Generated OTP is null");
            setErrorAndForward(request, response, orderId, amountStr, "Mã OTP không tồn tại. Vui lòng yêu cầu gửi lại mã mới.");
            return;
        }

        // 🛑 Kiểm tra OTP khớp
        if (!otpInput.equals(generatedOtp)) {
            System.out.println("ERROR: OTP mismatch - Input: " + otpInput + ", Expected: " + generatedOtp);
            setErrorAndForward(request, response, orderId, amountStr, "Mã OTP không chính xác. Vui lòng thử lại.");
            return;
        }

        // 🛑 Kiểm tra orderId có khớp với session không
        try {
            int orderIdInt = Integer.parseInt(orderId);
            if (orderIdInt != pendingOrderId) {
                System.out.println("ERROR: OrderId mismatch - Form: " + orderIdInt + ", Session: " + pendingOrderId);
                setErrorAndForward(request, response, orderId, amountStr, "Thông tin đơn hàng không khớp. Vui lòng thử lại.");
                return;
            }
        } catch (NumberFormatException e) {
            System.out.println("ERROR: OrderId format invalid");
            setErrorAndForward(request, response, orderId, amountStr, "Mã đơn hàng không hợp lệ.");
            return;
        }

        System.out.println("✅ OTP VALIDATION SUCCESS - Proceeding with payment...");

        // ✅ OTP HỢP LỆ - XỬ LÝ THANH TOÁN
        try {
            int orderIdInt = Integer.parseInt(orderId);
            BigDecimal paymentAmount = new BigDecimal(amountStr);

            System.out.println("Updating payment status for order: " + orderIdInt);

            // 1. CẬP NHẬT PaymentStatus
            boolean orderUpdated = orderDAO.updatePaymentStatus(orderIdInt, "Đã thanh toán");
            System.out.println("Order update status: " + orderUpdated);

            if (!orderUpdated) {
                setErrorAndForward(request, response, orderId, amountStr, "Không thể cập nhật trạng thái thanh toán.");
                return;
            }

            // 2. TẠO BẢN GHI PAYMENT
            Payment payment = new Payment();
            payment.setOrderID(orderIdInt);
            payment.setPaymentDate(LocalDateTime.now());
            payment.setPaymentMethod("Thanh toán khi nhận hàng (OTP)");
            payment.setAmount(paymentAmount);
            payment.setStatus("Đã thanh toán");

            boolean paymentRecorded = paymentDAO.createPayment(payment);
            System.out.println("Payment record status: " + paymentRecorded);

            if (paymentRecorded) {
                // ✅ XÓA SESSION
                clearOtpSession(session);
                System.out.println("✅ PAYMENT SUCCESS - Clearing session and redirecting...");

                // ✅ CHUYỂN HƯỚNG THÀNH CÔNG
                session.setAttribute("successMessage", "Thanh toán thành công cho đơn hàng #" + orderIdInt);
                response.sendRedirect(request.getContextPath() + "/DonMuaServlet?tab=paid");

            } else {
                // Rollback
                System.out.println("ERROR: Payment record failed - rolling back");
                orderDAO.updatePaymentStatus(orderIdInt, "Chưa thanh toán");
                setErrorAndForward(request, response, orderId, amountStr,
                        "Xác nhận thành công nhưng ghi nhận thanh toán thất bại. Vui lòng liên hệ hỗ trợ.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ERROR: Exception during payment processing: " + e.getMessage());
            setErrorAndForward(request, response, orderId, amountStr,
                    "Lỗi hệ thống: " + e.getMessage());
        }
    }

    // 🎯 PHƯƠNG THỨC HỖ TRỢ
    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response,
            String orderId, String amount, String error)
            throws ServletException, IOException {
        request.setAttribute("orderId", orderId != null ? orderId : "");
        request.setAttribute("amount", amount != null ? amount : "");
        request.setAttribute("error", error);
        request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
    }

    private void clearOtpSession(HttpSession session) {
        session.removeAttribute("generatedOtp");
        session.removeAttribute("otp_verificationExpireTime");
        session.removeAttribute("pendingOrderId");
        session.removeAttribute("amount");
        session.removeAttribute("isNewOrder");
        System.out.println("Session cleared for OTP");
    }

    private String generateNewOtp() {
        return String.format("%06d", (int) (Math.random() * 1000000));
    }

    @Override
    public String getServletInfo() {
        return "Xử lý thanh toán cho đơn hàng có sẵn trong Đơn mua";
    }
}
