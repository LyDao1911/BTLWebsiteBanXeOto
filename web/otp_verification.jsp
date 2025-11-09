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
            .otp-wrapper {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: calc(100vh - 200px);
            }
            .otp-container {
                width: 35%;
                min-width: 380px;
                max-width: 600px;
                background: #fff;
                color: #222;
                border-radius: 18px;
                padding: 40px 35px;
                box-shadow: 0 0 30px rgba(255, 0, 0, 0.3);
                border-top: 6px solid #c40000;
                text-align: center;
                transition: all 0.3s ease;
            }

            .otp-container:hover {
                transform: translateY(-3px);
                box-shadow: 0 0 40px rgba(255, 0, 0, 0.4);
            }

            .otp-container h2 {
                color: #c40000;
                font-weight: 700;
                margin-bottom: 25px;
                text-transform: uppercase;
            }

            .otp-info {
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 10px;
                color: #000;
                font-size: 26px;
                margin-bottom: 25px;
                line-height: 1.6;
            }

            .otp-code {
                font-size: 30px;
                font-weight: bold;
                color: #c40000;
                letter-spacing: 3px;
                margin-bottom: 20px;
            }

            .otp-input {
                width: 100%;
                height: 48px;
                border-radius: 10px;
                border: 2px solid #c40000;
                padding: 0 12px;
                font-size: 20px;
                text-align: center;
                color: #000;
                font-weight: 500;
                outline: none;
                transition: all 0.2s ease-in-out;
            }

            .otp-input:focus {
                border-color: #000;
                box-shadow: 0 0 6px rgba(196, 0, 0, 0.5);
            }

            .btn-confirm {
                width: 100%;
                margin-top: 20px;
                background-color: #c40000;
                color: white;
                border: none;
                border-radius: 10px;
                height: 48px;
                font-size: 20px;
                font-weight: 600;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                transition: all 0.25s;
            }

            .btn-confirm:hover {
                background-color: #000;
                color: #fff;
            }

            .resend {
                margin-top: 18px;
                font-size: 20px;
                color: #333;
            }

            .resend a {
                color: #c40000;
                font-weight: bold;
                text-decoration: none;
            }

            .resend a:hover {
                text-decoration: underline;
            }

            #otp-timer {
                color: #c40000;
                font-weight: 600;
            }

            /* Responsive */
            @media (max-width: 1024px) {
                .otp-container {
                    width: 50%;
                }
            }

            @media (max-width: 768px) {
                .otp-container {
                    width: 80%;
                    padding: 30px 25px;
                }
            }

            @media (max-width: 480px) {
                .otp-container {
                    width: 90%;
                    padding: 25px 20px;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <!-- ✅ THÊM BIẾN isPayment -->
        <c:set var="isPayment" value="${not empty sessionScope.amount and sessionScope.amount != '0'}" />

        <jsp:include page="header.jsp" />

        <!-- ✅ XÁC ĐỊNH LOẠI GIAO DỊCH -->
        <c:set var="isNewOrder" value="${sessionScope.isNewOrder != null && sessionScope.isNewOrder}" />
        <c:set var="isPayment" value="${not empty sessionScope.amount and sessionScope.amount != '0'}" />

        <script>
            // Xác định loại giao dịch
            function getTransactionType() {
                let isNewOrder = "${isNewOrder}";
                return isNewOrder === "true" ? "new_order" : "payment";
            }

            // Gửi lại OTP - PHÂN BIỆT 2 LOẠI
            function resendOtp() {
                let orderId = "${sessionScope.pendingOrderId}";
                let amount = "${sessionScope.amount}";
                let isNewOrder = "${isNewOrder}";

                console.log("Resend OTP - OrderId:", orderId, "Amount:", amount, "IsNewOrder:", isNewOrder);

                if (!orderId || orderId === "null") {
                    alert("Không tìm thấy mã đơn hàng để gửi lại OTP.");
                    return;
                }

                if (confirm("Bạn có chắc chắn muốn gửi lại mã OTP? Mã cũ sẽ không còn hiệu lực.")) {
                    let url = "";

                    if (isNewOrder === "true") {
                        // Luồng MUA NGAY/MUA TRONG GIỎ
                        url = "${pageContext.request.contextPath}/OrderProcessingServlet?resend=true";
                    } else {
                        // Luồng THANH TOÁN ĐƠN MUA
                        url = "${pageContext.request.contextPath}/PaymentProcessingServlet?resend=true";
                    }

                    console.log("Redirecting to:", url);
                    window.location.href = url;
                }
            }

            // Đếm ngược thời gian OTP
            function startOtpTimer() {
                let timerElement = document.getElementById('otp-timer');
                if (!timerElement)
                    return;

                let timeLeft = 300; // 5 phút = 300 giây
                let timer = setInterval(function () {
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

            // Validate OTP
            function validateOtp() {
                let otpInput = document.querySelector('input[name="otp_verification"]');
                let otpValue = otpInput.value.trim();

                console.log("Form validation - OTP:", otpValue);

                if (otpValue.length !== 6) {
                    alert('Vui lòng nhập đủ 6 chữ số cho mã OTP.');
                    otpInput.focus();
                    return false;
                }
                if (!/^\d+$/.test(otpValue)) {
                    alert('Mã OTP chỉ được chứa số.');
                    otpInput.focus();
                    return false;
                }
                return true;
            }

            window.onload = function () {
                document.querySelector('input[name="otp_verification"]').focus();
                startOtpTimer();

            };
        </script>

        <!-- Giao diện OTP -->
        <div class="otp-wrapper">
            <div class="otp-container">
                <h2>XÁC NHẬN OTP</h2>

                <!-- THÔNG BÁO LỖI/THÀNH CÔNG -->
                <c:if test="${not empty error}">
                    <div style="color: red; background: #ffe6e6; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
                        ❌ ${error}
                    </div>
                </c:if>

                <c:if test="${not empty info}">
                    <div style="color: green; background: #e6ffe6; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
                        ✅ ${info}
                    </div>
                </c:if>

                <div class="otp-info">
                    <c:if test="${not empty sessionScope.amount}">
                        Số tiền: <fmt:formatNumber value="${sessionScope.amount}" type="currency" currencySymbol="₫" /> <br>
                    </c:if>
                    Mã đơn hàng: #${sessionScope.pendingOrderId} <br>
                    Thời gian còn lại: <span id="otp-timer">5:00</span>
                </div>

                <p>Mã OTP của bạn:</p>
                <div class="otp-code">${sessionScope.generatedOtp}</div>

                <!-- ✅ FORM ACTION PHÂN BIỆT 2 LOẠI -->
                <c:choose>
                    <c:when test="${isNewOrder}">
                        <!-- FORM CHO MUA NGAY/MUA TRONG GIỎ -->
                        <form action="${pageContext.request.contextPath}/OrderProcessingServlet"
                              method="post" onsubmit="return validateOtp()">
                            <input type="text"
                                   name="otp_verification"
                                   class="otp-input"
                                   placeholder="Nhập mã OTP gồm 6 chữ số"
                                   required
                                   maxlength="6"
                                   oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                   autocomplete="off">

                            <input type="hidden" name="orderId" value="${sessionScope.pendingOrderId}">
                            <input type="hidden" name="amount" value="${sessionScope.amount}">

                            <button type="submit" class="btn-confirm">
                                <i class="fas fa-check-circle"></i>
                                XÁC NHẬN ĐẶT HÀNG
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <!-- FORM CHO THANH TOÁN ĐƠN MUA -->
                        <form action="${pageContext.request.contextPath}/PaymentProcessingServlet"
                              method="post" onsubmit="return validateOtp()">
                            <input type="text"
                                   name="otp_verification"
                                   class="otp-input"
                                   placeholder="Nhập mã OTP gồm 6 chữ số"
                                   required
                                   maxlength="6"
                                   oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                   autocomplete="off">

                            <input type="hidden" name="orderId" value="${sessionScope.pendingOrderId}">
                            <input type="hidden" name="amount" value="${sessionScope.amount}">

                            <button type="submit" class="btn-confirm">
                                <i class="fas fa-check-circle"></i>
                                XÁC NHẬN THANH TOÁN
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>

                <div class="resend">
                    <p>Chưa nhận được mã?
                        <a href="#" onclick="resendOtp(); return false;">Gửi lại mã OTP</a>
                    </p>
                </div>

            </div>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>