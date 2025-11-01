<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Xác nhận OTP</title>
        <style>
            /* Thêm CSS cơ bản cho dễ nhìn */
            body { font-family: Arial, sans-serif; padding: 20px; }
            .error { color: red; font-weight: bold; }
            .info { color: green; }
            strong.amount { color: #007bff; }
        </style>
    </head>
    <body>
        <h1>Xác nhận thanh toán</h1>

        <%
            // --- Nhận dữ liệu từ request (Giữ nguyên phần này) ---
            String orderId = (String) request.getAttribute("orderId");
            String amountStr = (String) request.getAttribute("amount");
            String error = (String) request.getAttribute("error");
            String info = (String) request.getAttribute("info");
            
            // Lấy OTP chỉ để ALERT ra, KHÔNG để trong hidden field
            String generatedOtp = (String) request.getAttribute("generatedOtp");
            
            // Xử lý khi user reload hoặc quay lại form, lấy từ param
            if (orderId == null) orderId = request.getParameter("orderId");
            if (amountStr == null) amountStr = request.getParameter("amount");
            
        %>
        
        <p>Mã đơn hàng: <strong><%= orderId != null ? orderId : "..."%></strong></p>
        
        <p>Số tiền cần thanh toán:
            <strong class="amount">
                <fmt:formatNumber 
                    value="${requestScope.amount != null ? requestScope.amount : param.amount}"
                    pattern="#,##0" />đ
            </strong>
        </p>

        <% if (error != null) {%>
        <p class="error">🛑 <%= error%></p>
        <% } %>
        <% if (info != null) {%>
        <p class="info">✅ <%= info%></p>
        <% }%>

        <form method="POST" action="OrderProcessingServlet">
            <input type="hidden" name="orderId" value="<%= orderId != null ? orderId : ""%>">
            <input type="hidden" name="amount" value="<%= amountStr != null ? amountStr : ""%>">
            
            <label for="otp">Nhập Mã **OTP** (Đã được gửi qua thông báo):</label><br>
            <input type="text" id="otp" name="otp" required maxlength="6" pattern="[0-9]{6}"><br><br>

            <button type="button"
                    onclick="resendOtp('<%= orderId%>', '<%= amountStr != null ? amountStr : ""%>')"
                    style="padding: 5px 10px; margin-right: 10px;">
                Gửi lại Mã OTP
            </button>
            <button type="submit">Xác nhận Thanh toán</button>
        </form>

        <script>
            // Gửi lại OTP (chuyển hướng đến servlet resend)
            function resendOtp(orderId, amount) {
                if (orderId === "" || orderId === "...") {
                     alert("Không tìm thấy mã đơn hàng để gửi lại OTP.");
                     return;
                }
                if (confirm("Bạn có chắc chắn muốn tạo lại mã OTP? Mã cũ sẽ không còn hiệu lực.")) {
                    // Chuyển hướng đến ResendOtpServlet (bạn cần xây dựng Servlet này)
                    window.location.href = "ResendOtpServlet?orderId=" + orderId + "&amount=" + amount;
                }
            }

            // Thông báo OTP khi mới sinh ra (Chỉ chạy 1 lần khi DatHangServlet forward tới)
            <% if (generatedOtp != null) {%>
                alert("Mã OTP của bạn là: <%= generatedOtp%>\n\nVui lòng nhập mã này vào ô bên dưới.");
                // Xóa attribute để alert không xuất hiện khi user quay lại trang (back/reload)
                request.removeAttribute("generatedOtp");
            <% }%>
        </script>
    </body>
</html>