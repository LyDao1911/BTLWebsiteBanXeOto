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

@WebServlet(name = "OrderProcessingServlet", urlPatterns = {"/OrderProcessingServlet"})
public class OrderProcessingServlet extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8"); // ✅ THÊM DÒNG NÀY

        // Nhận dữ liệu từ form
        String orderId = request.getParameter("orderId");
        String otp_verificationInput = request.getParameter("otp_verification");
        String amountStr = request.getParameter("amount");

        // Lấy dữ liệu từ session
        HttpSession session = request.getSession();
        String generatedOtp = (String) session.getAttribute("generatedOtp");
        Long otp_verificationExpireTime = (Long) session.getAttribute("otp_verificationExpireTime");
        Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");

        // 🛑 Kiểm tra thông tin phiên giao dịch
        if (orderId == null || orderId.trim().isEmpty() || 
            otp_verificationInput == null || otp_verificationInput.trim().isEmpty() || 
            amountStr == null || amountStr.trim().isEmpty() ||
            pendingOrderId == null) {

            setErrorAttributes(request, orderId, amountStr, "Thiếu thông tin phiên giao dịch hoặc mã OTP không hợp lệ.");
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            return;
        }

        // 🛑 Kiểm tra OTP có tồn tại và còn hiệu lực
        long now = System.currentTimeMillis();
        if (otp_verificationExpireTime == null || now > otp_verificationExpireTime || generatedOtp == null) {
            setErrorAttributes(request, orderId, amountStr, "Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã mới.");
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            return;
        }

        // 🛑 Kiểm tra OTP có khớp không
        if (!otp_verificationInput.equals(generatedOtp)) {
            setErrorAttributes(request, orderId, amountStr, "Mã OTP không chính xác. Vui lòng thử lại.");
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            return;
        }

        // 🛑 Kiểm tra orderId từ form có khớp với session không
        try {
            int orderIdInt = Integer.parseInt(orderId);
            if (orderIdInt != pendingOrderId) {
                setErrorAttributes(request, orderId, amountStr, "Thông tin đơn hàng không khớp. Vui lòng thử lại.");
                request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            setErrorAttributes(request, orderId, amountStr, "Mã đơn hàng không hợp lệ.");
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            return;
        }

        // ✅ OTP HỢP LỆ: XỬ LÝ THANH TOÁN
        try {
            int orderIdInt = Integer.parseInt(orderId);
            BigDecimal paymentAmount = new BigDecimal(amountStr);

            // 1. CẬP NHẬT PaymentStatus
            boolean orderUpdated = orderDAO.updatePaymentStatus(orderIdInt, "Đã thanh toán");

            // 2. TẠO BẢN GHI PAYMENT
            Payment payment = new Payment();
            payment.setOrderID(orderIdInt);
            payment.setPaymentDate(LocalDateTime.now());
            payment.setPaymentMethod("Thanh toán khi nhận hàng (OTP)");
            payment.setAmount(paymentAmount);
            payment.setStatus("Đã thanh toán");

            boolean paymentRecorded = paymentDAO.createPayment(payment);

            if (orderUpdated && paymentRecorded) {
                // Xóa session OTP
                session.removeAttribute("generatedOtp");
                session.removeAttribute("otp_verificationExpireTime");
                session.removeAttribute("pendingOrderId");

                // ✅ CHUYỂN HƯỚNG THÀNH CÔNG
                String redirectURL = request.getContextPath() + "/DonMuaServlet?tab=paid&orderSuccess=true&orderId=" + orderIdInt;
                response.sendRedirect(redirectURL);
                return;
            } else {
                // Rollback trong trường hợp thất bại
                if (orderUpdated) {
                    orderDAO.updatePaymentStatus(orderIdInt, "Chưa thanh toán");
                }
                setErrorAttributes(request, orderId, amountStr, "Xác nhận thành công nhưng ghi nhận vào CSDL thất bại.");
                request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            
            // ✅ XỬ LÝ LỖI CỤ THỂ
            String specificError = "Lỗi: " + e.getClass().getSimpleName();
            if (e instanceof NumberFormatException) {
                specificError = "Lỗi định dạng số (orderId hoặc amount không phải số)";
            } else if (e instanceof NullPointerException) {
                specificError = "Lỗi null pointer";
            } else if (e instanceof IllegalArgumentException) {
                specificError = "Lỗi tham số không hợp lệ";
            }
            
            setErrorAttributes(request, orderId, amountStr, specificError + ": " + e.getMessage());
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
        }
    }

   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    response.setContentType("text/html;charset=UTF-8");
    request.setCharacterEncoding("UTF-8");

    HttpSession session = request.getSession();
    Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");
    // Lấy amount từ session thay vì request parameter
    String amountStr = (String) session.getAttribute("pendingAmount"); // CẦN ĐẢM BẢO ĐÃ LƯU
    
    // Nếu amount không có trong session, cố gắng lấy từ request (cho trường hợp resend)
    if (amountStr == null || amountStr.trim().isEmpty()) {
         amountStr = request.getParameter("amount");
    }

    if (pendingOrderId != null) {
        request.setAttribute("orderId", pendingOrderId.toString());
        request.setAttribute("amount", amountStr != null ? amountStr : "");

        // Logic Resend OTP
        if ("true".equals(request.getParameter("resend"))) {
            String newOtp = generateNewOtp();
            long newExpireTime = System.currentTimeMillis() + (5 * 60 * 1000); // 5 phút

            session.setAttribute("generatedOtp", newOtp);
            session.setAttribute("otp_verificationExpireTime", newExpireTime);

            // Gửi lại OTP cần giữ lại amount và orderId
            request.setAttribute("info", "Mã OTP mới đã được gửi lại.");
            request.setAttribute("generatedOtp", newOtp); // Gửi OTP mới lên request để alert (chế độ test)
        }

        request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
    } else {
        response.sendRedirect(request.getContextPath() + "/trangchu.jsp?error=Phiên giao dịch đã hết hạn");
    }
}
    // 🎯 PHƯƠNG THỨC HỖ TRỢ
    private void setErrorAttributes(HttpServletRequest request, String orderId, String amount, String error) {
        request.setAttribute("orderId", orderId != null ? orderId : "");
        request.setAttribute("amount", amount != null ? amount : "");
        request.setAttribute("error", error);
    }

    private String generateNewOtp() {
        return String.format("%06d", (int) (Math.random() * 1000000));
    }

    @Override
    public String getServletInfo() {
        return "Xử lý xác nhận OTP và cập nhật trạng thái đơn hàng.";
    }
}