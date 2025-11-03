<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Xác nhận OTP - VELYRA AERO</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <style>
            .otp-container {
                max-width: 450px;
                margin: 50px auto;
                padding: 30px;
                border: 1px solid #ddd;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                text-align: center;
                background: white;
            }
            .otp-input {
                width: 100%;
                padding: 12px;
                margin: 15px 0;
                box-sizing: border-box;
                border: 2px solid #ddd;
                border-radius: 6px;
                text-align: center;
                font-size: 1.3em;
                letter-spacing: 8px;
                font-weight: bold;
                font-family: monospace;
            }
            .otp-input:focus {
                border-color: #007bff;
                outline: none;
                box-shadow: 0 0 5px rgba(0,123,255,0.3);
            }
            .submit-btn {
                background: linear-gradient(135deg, #007bff, #0056b3);
                color: white;
                padding: 12px 20px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 1.1em;
                margin-top: 15px;
                width: 100%;
                transition: all 0.3s ease;
            }
            .submit-btn:hover {
                background: linear-gradient(135deg, #0056b3, #004085);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,123,255,0.3);
            }
            .action-badge {
                color: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 0.9em;
                margin-bottom: 15px;
                display: inline-block;
                font-weight: bold;
            }
            .payment-badge {
                background: linear-gradient(135deg, #dc3545, #c82333);
            }
            .order-badge {
                background: linear-gradient(135deg, #28a745, #20c997);
            }
            .error-message {
                color: #721c24;
                background: #f8d7da;
                padding: 12px;
                border-radius: 6px;
                margin-bottom: 15px;
                border: 1px solid #f5c6cb;
            }
            .info-message {
                color: #155724;
                background: #d4edda;
                padding: 12px;
                border-radius: 6px;
                margin-bottom: 15px;
                border: 1px solid #c3e6cb;
            }
            .resend-link {
                color: #007bff;
                text-decoration: none;
                cursor: pointer;
                font-weight: 500;
                transition: color 0.2s ease;
            }
            .resend-link:hover {
                color: #0056b3;
                text-decoration: underline;
            }
            .timer {
                color: #dc3545;
                font-weight: bold;
                font-size: 0.9em;
            }
            .order-info {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 6px;
                margin: 15px 0;
                text-align: left;
                border-left: 4px solid #007bff;
            }
            .otp-display {
                background: #e7f3ff;
                border: 2px dashed #007bff;
                padding: 15px;
                border-radius: 8px;
                margin: 15px 0;
            }
            .otp-code {
                font-size: 2em;
                font-weight: bold;
                color: #dc3545;
                letter-spacing: 8px;
                text-align: center;
                margin: 10px 0;
            }
        </style>
    </head>
    <body>
        <!-- DEBUG INFO (có thể ẩn đi sau khi test xong) -->
        <div style="display: none;">
            Debug Info:<br>
            Session pendingOrderId: ${sessionScope.pendingOrderId}<br>
            Session generatedOtp: ${sessionScope.generatedOtp}<br>
            Session amount: ${sessionScope.amount}<br>
            Request amount: ${requestScope.amount}
        </div>

        <jsp:include page="header.jsp" />
           
        <script>
            // Xác định loại giao dịch
            function isPaymentFlow() {
                let amount = "${sessionScope.amount}";
                return amount && amount !== "null" && amount !== "" && amount !== "0";
            }

            // Gửi lại OTP
            function resendOtp() {
                let orderId = "${sessionScope.pendingOrderId}";
                let amount = "${sessionScope.amount}";
                
                console.log("Resend OTP - orderId:", orderId, "amount:", amount);
                
                if (!orderId || orderId.trim() === "") {
                    alert("Không tìm thấy mã đơn hàng để gửi lại OTP.");
                    return;
                }

                let confirmationMessage = "Bạn có chắc chắn muốn gửi lại mã OTP? Mã cũ sẽ không còn hiệu lực.";
                
                if (confirm(confirmationMessage)) {
                    let url = "ResendOtpServlet?orderId=" + encodeURIComponent(orderId);
                    
                    // Luôn truyền amount, ngay cả khi rỗng
                    if (amount !== undefined && amount !== null) {
                        url += "&amount=" + encodeURIComponent(amount);
                    }
                    
                    console.log("Redirecting to:", url);
                    window.location.href = url;
                }
            }

            // Đếm ngược thời gian OTP
            function startOtpTimer() {
                let timerElement = document.getElementById('otp-timer');
                if (!timerElement) return;
                
                let timeLeft = 300; // 5 phút
                
                let timer = setInterval(function() {
                    let minutes = Math.floor(timeLeft / 60);
                    let seconds = timeLeft % 60;
                    
                    timerElement.innerHTML = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                    
                    if (timeLeft <= 0) {
                        clearInterval(timer);
                        timerElement.innerHTML = "Hết hạn";
                        timerElement.style.color = "#dc3545";
                    }
                    timeLeft--;
                }, 1000);
            }

            // Tự động focus vào input OTP
            window.onload = function() {
                document.querySelector('input[name="otp_verification"]').focus();
                startOtpTimer();
                
                // Hiển thị OTP trong console
                <c:if test="${not empty sessionScope.generatedOtp}">
                    console.log("=== VELYRA AERO - MÃ OTP ===");
                    console.log("📧 Mã OTP: ${sessionScope.generatedOtp}");
                    console.log("📦 Order ID: ${sessionScope.pendingOrderId}");
                    <c:if test="${not empty sessionScope.amount}">
                        console.log("💰 Số tiền: ${sessionScope.amount}đ");
                    </c:if>
                    console.log("⏰ Thời gian: 5 phút");
                </c:if>
            };

            // Validate OTP trước khi submit
            function validateOtp() {
                let otpInput = document.querySelector('input[name="otp_verification"]');
                let otpValue = otpInput.value.trim();
                
                if (otpValue.length !== 6) {
                    alert('Vui lòng nhập đủ 6 chữ số cho mã OTP.');
                    otpInput.focus();
                    return false;
                }
                
                if (!/^\d+$/.test(otpValue)) {
                    alert('Mã OTP chỉ được chứa số. Vui lòng kiểm tra lại.');
                    otpInput.focus();
                    return false;
                }
                
                return true;
            }
        </script>

        <div class="otp-container">
            <!-- Hiển thị loại hành động - PHÂN BIỆT 2 LUỒNG -->
            <c:set var="isPayment" value="${not empty sessionScope.amount}" />
            
            <!-- HIỂN THỊ SỐ TIỀN Ở ĐẦU TRANG -->
            <c:if test="${not empty sessionScope.amount}">
                <div style="background: linear-gradient(135deg, #007bff, #0056b3); color: white; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                    <h3 style="margin: 0 0 10px 0; font-size: 1.2em;">
                        <i class="fas fa-money-bill-wave"></i> Số tiền
                    </h3>
                    <p style="margin: 0; font-size: 1.5em; font-weight: bold;">
                        <fmt:formatNumber value="${sessionScope.amount}" pattern="#,##0"/>đ
                    </p>
                </div>
            </c:if>
            
            <div class="action-badge ${isPayment ? 'payment-badge' : 'order-badge'}">
                <i class="fas ${isPayment ? 'fa-credit-card' : 'fa-shopping-cart'}"></i> 
                <c:choose>
                    <c:when test="${isPayment}">
                        XÁC NHẬN THANH TOÁN
                    </c:when>
                    <c:otherwise>
                        XÁC NHẬN ĐẶT HÀNG
                    </c:otherwise>
                </c:choose>
            </div>
            
            <h2><i class="fas fa-shield-alt"></i> Xác nhận OTP</h2>
            
            <p style="color: #666; margin-bottom: 20px;">
                <c:choose>
                    <c:when test="${isPayment}">
                        Vui lòng nhập mã OTP để hoàn tất thanh toán đơn hàng
                    </c:when>
                    <c:otherwise>
                        Vui lòng nhập mã OTP để xác nhận đặt hàng
                    </c:otherwise>
                </c:choose>
            </p>
            
            <!-- Hiển thị thông báo lỗi -->
            <c:if test="${not empty requestScope.error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i> ${requestScope.error}
                </div>
            </c:if>
            
            <!-- Hiển thị thông báo info -->
            <c:if test="${not empty requestScope.info}">
                <div class="info-message">
                    <i class="fas fa-info-circle"></i> ${requestScope.info}
                </div>
            </c:if>
            
            <!-- Hiển thị thông tin đơn hàng -->
            <div class="order-info">
                <c:choose>
                    <c:when test="${not empty sessionScope.pendingOrderId}">
                        <p><strong><i class="fas fa-receipt"></i> Mã đơn hàng:</strong> #${sessionScope.pendingOrderId}</p>
                    </c:when>
                    <c:otherwise>
                        <p><strong><i class="fas fa-receipt"></i> Mã đơn hàng:</strong> Đang tải...</p>
                    </c:otherwise>
                </c:choose>
                
                <p style="margin-top: 10px; margin-bottom: 0;">
                    <i class="fas fa-clock"></i> 
                    <strong>Thời gian còn lại: </strong>
                    <span id="otp-timer" class="timer">5:00</span>
                </p>
            </div>

            <!-- HIỂN THỊ OTP TRỰC TIẾP TRÊN MÀN HÌNH -->
            <c:if test="${not empty sessionScope.generatedOtp}">
                <div class="otp-display">
                    <h4 style="color: #007bff; margin: 0 0 10px 0;">
                        <i class="fas fa-key"></i> Mã OTP của bạn:
                    </h4>
                    <div class="otp-code">${sessionScope.generatedOtp}</div>
                    <p style="font-size: 0.9em; color: #666; margin: 0;">
                        <i class="fas fa-info-circle"></i> 
                        Nhập mã OTP này vào ô bên dưới để xác nhận
                    </p>
                </div>
            </c:if>
            
            <!-- FORM OTP -->
            <form action="${isPayment ? 'PaymentProcessingServlet' : 'OrderProcessingServlet'}" method="POST" id="otpForm" onsubmit="return validateOtp()">
                <input type="text" 
                       name="otp_verification" 
                       placeholder="Nhập 6 số OTP" 
                       class="otp-input"
                       required 
                       maxlength="6" 
                       pattern="\d{6}"
                       title="Vui lòng nhập đúng 6 chữ số"
                       oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                
                <input type="hidden" name="orderId" value="${sessionScope.pendingOrderId}">
                <input type="hidden" name="amount" value="${sessionScope.amount}">
                
                <button type="submit" class="submit-btn">
                    <i class="fas fa-check-circle"></i>
                    <c:choose>
                        <c:when test="${isPayment}">
                            XÁC NHẬN THANH TOÁN
                        </c:when>
                        <c:otherwise>
                            XÁC NHẬN ĐẶT HÀNG
                        </c:otherwise>
                    </c:choose>
                </button>
            </form>
            
            <div style="margin-top: 25px; font-size: 0.9em;">
                <p style="margin-bottom: 10px;">
                    <i class="fas fa-question-circle"></i> 
                    Chưa nhận được mã? 
                </p>
                <a href="#" class="resend-link" onclick="resendOtp(); return false;">
                    <i class="fas fa-paper-plane"></i> Gửi lại mã OTP
                </a>
            </div>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>