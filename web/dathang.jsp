<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Customer" %>
<%
    Customer customer = (Customer) request.getAttribute("customer");
%>
<!DOCTYPE html>
<style>
    /* ==========================
    ĐẶT HÀNG (giohang.jsp)
    ========================== */
    .order-container {
        width: 80%;
        max-width: 1000px;
        margin: 0 auto;
        background: #fff;
        padding: 30px 40px;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    }

    .section-title {
        font-size: 22px;
        color: #b30000;
        font-weight: bold;
        margin-bottom: 20px;
        text-transform: uppercase;
    }

    .customer-info .field {
        margin-bottom: 18px;
    }

    .customer-info label {
        display: block;
        font-weight: bold;
        color: #333;
        margin-bottom: 6px;
    }

    .customer-info input {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 15px;
        background-color: #f7f5f5;
        outline: none;
    }

    .customer-info input:focus {
        border-color: #b30000;
    }

    .product-order {
        margin-top: 25px;
    }

    .product-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background-color: #fafafa;
        padding: 15px;
        border-radius: 8px;
        gap: 20px;
    }

    .product-item img {
        width: 120px;
        height: auto;
        border-radius: 6px;
        object-fit: cover;
    }

    .prod-info {
        flex: 1;
    }

    .prod-name {
        font-size: 16px;
        font-weight: bold;
        color: #222;
    }

    .prod-qty {
        font-size: 14px;
        color: #666;
    }

    .prod-price {
        font-size: 16px;
        font-weight: bold;
        color: #222;
    }

    .payment-summary {
        margin-top: 30px;
        padding: 20px;
        background: #f7f7f7;
        border-radius: 8px;
    }

    .payment-summary .row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 10px;
    }

    .payment-summary .label,
    .payment-summary .value {
        font-size: 15px;
        color: #444;
    }

    .order-footer {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        margin-top: 35px;
        gap: 20px;
    }

    .total-label {
        font-size: 18px;
        font-weight: bold;
        color: #222;
    }

    .total-value {
        font-size: 20px;
        font-weight: bold;
        color: #b30000;
    }

    .btn-order {
        background-color: #b30000;
        color: #fff;
        border: none;
        font-size: 16px;
        padding: 12px 30px;
        border-radius: 6px;
        cursor: pointer;
        transition: background 0.3s;
    }

    .btn-order:hover {
        background-color: #8b0000;
    }

    /* CSS mới cho phần Phụ phí */
    .extra-fees-section {
        margin-top: 25px;
    }

    .extra-fees-note {
        font-size: 13px;
        color: #666;
        font-style: italic;
        margin-bottom: 15px;
        padding: 8px 12px;
        background: #f0f0f0;
        border-radius: 6px;
    }

    .fee-option {
        margin-bottom: 12px;
        padding: 12px 15px;
        background: #fafafa;
        border-radius: 8px;
        border: 1px solid #e0e0e0;
    }

    .fee-checkbox {
        display: flex;
        align-items: center;
        cursor: pointer;
    }

    .fee-checkbox input[type="checkbox"] {
        margin-right: 10px;
        transform: scale(1.2);
    }

    .fee-details {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
    }

    .fee-text {
        font-size: 14px;
        color: #333;
    }

    .fee-amount {
        font-size: 14px;
        font-weight: bold;
        color: #b30000;
    }

    .fee-description {
        font-size: 12px;
        color: #666;
        margin-top: 4px;
    }

    .fixed-fee {
        background: #f8f8f8;
        border-left: 4px solid #b30000;
    }
</style>
<script>
// Hàm tính toán tổng tiền tự động
function calculateTotal() {
    // Lấy giá trị từ HTML element
    const subtotalElement = document.querySelector('[data-subtotal]');
    let subtotalPrice = 0;
    
    if (subtotalElement) {
        // Lấy giá trị từ data attribute
        const subtotalValue = subtotalElement.getAttribute('data-subtotal');
        subtotalPrice = parseFloat(subtotalValue) || 0;
    }
    
    console.log("Subtotal:", subtotalPrice); // Debug
    
    const taxRate = 0.10; // Thuế 10%
    const fixedFee = 12000000; // Phí cố định 12 triệu
    
    // Tính thuế
    const taxAmount = subtotalPrice * taxRate;
    
    // Tính phụ phí
    let extra = fixedFee; // Luôn có phí cố định
    
    // Kiểm tra bảo hiểm vật chất có được chọn không
    const insuranceCheckbox = document.getElementById('insuranceFee');
    let insuranceAmount = 0;
    
    if (insuranceCheckbox && insuranceCheckbox.checked) {
        const insuranceRate = 0.035; // 3.5%
        insuranceAmount = subtotalPrice * insuranceRate;
        extra += insuranceAmount;
    }
    
    // Tính tổng
    const totalAmount = subtotalPrice + taxAmount + extra;
    
    console.log("Insurance:", insuranceAmount, "Total:", totalAmount); // Debug
    
    // Cập nhật hiển thị
    updateDisplay('fixed', fixedFee);
    updateDisplay('insurance', insuranceAmount);
    updateDisplay('extra', extra);
    updateDisplay('total', totalAmount);
    
    // Cập nhật các phần trong payment summary
    updatePaymentSummary(subtotalPrice, taxAmount, fixedFee, insuranceAmount, totalAmount);
    
    // Cập nhật hidden field để gửi lên server
    document.querySelector('input[name="totalAmount"]').value = Math.round(totalAmount);
}

// Hàm cập nhật hiển thị
function updateDisplay(type, amount) {
    const elements = document.querySelectorAll(`[data-fee="${type}"]`);
    elements.forEach(element => {
        element.textContent = formatCurrency(amount);
    });
}

// Hàm cập nhật payment summary
function updatePaymentSummary(subtotal, tax, fixed, insurance, total) {
    // Cập nhật các dòng trong payment summary
    const subtotalElement = document.querySelector('.payment-summary .row:nth-child(1) .value');
    const taxElement = document.querySelector('.payment-summary .row:nth-child(2) .value');
    const fixedFeeElement = document.querySelector('.payment-summary .row:nth-child(3) .value');
    const insuranceElement = document.querySelector('.payment-summary .row:nth-child(4) .value');
    const totalElement = document.querySelector('.payment-summary .row:nth-child(5) .value');
    
    if (subtotalElement) subtotalElement.textContent = formatCurrency(subtotal);
    if (taxElement) taxElement.textContent = formatCurrency(tax);
    if (fixedFeeElement) fixedFeeElement.textContent = formatCurrency(fixed);
    if (insuranceElement) insuranceElement.textContent = formatCurrency(insurance);
    if (totalElement) totalElement.textContent = formatCurrency(total);
    
    // Cập nhật tổng thanh toán ở footer
    const footerTotalElement = document.querySelector('.order-footer .total-value');
    if (footerTotalElement) {
        footerTotalElement.textContent = formatCurrency(total);
    }
}

// Hàm định dạng tiền tệ
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', { 
        maximumFractionDigits: 0
    }).format(amount) + 'đ';
}

// Gọi hàm tính toán khi trang được tải
document.addEventListener('DOMContentLoaded', function() {
    calculateTotal();
    
    // Thêm sự kiện cho checkbox bảo hiểm
    const insuranceCheckbox = document.getElementById('insuranceFee');
    if (insuranceCheckbox) {
        insuranceCheckbox.addEventListener('change', calculateTotal);
    }
});
</script>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đặt hàng - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>

        <jsp:include page="header.jsp" />

        <c:if test="${not empty sessionScope.toastMessage}">
            <script>
                alert("<c:out value='${sessionScope.toastMessage}' escapeXml='true'/>");
            </script>
            <c:remove var="toastMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="error-box" style="color: red; text-align: center; margin-bottom: 15px;">
                ${errorMessage}
            </div>
        </c:if>

        <div class="order-container">
            <form action="DatHangServlet" method="POST">

                <h2 class="section-title">Thông tin khách hàng</h2>
                <div class="customer-info">
                    <div class="field">
                        <label>Họ tên</label>
                        <input type="text" name="fullname" placeholder="Nhập họ tên"
                               value="${customer.fullName}" required>
                    </div>

                    <div class="field">
                        <label>Địa chỉ</label>
                        <input type="text" name="address" placeholder="Nhập địa chỉ"
                               value="${customer.address}" required>
                    </div>

                    <div class="field">
                        <label>Số điện thoại</label>
                        <input type="text" name="phone" placeholder="Nhập số điện thoại"
                               value="${customer.phoneNumber}" required>
                    </div>

                    <div class="field">
                        <label>Email</label>
                        <input type="email" name="email" placeholder="Nhập email"
                               value="${customer.email}" required readonly>
                    </div>
                </div>

                <!-- PHẦN MỚI: PHỤ PHÍ -->
                <h2 class="section-title">Phụ phí đăng ký xe</h2>
                <div class="extra-fees-section">
                    <div class="extra-fees-note">
                        <i class="fa-solid fa-info-circle"></i> 
                        Đây là các khoản phí bắt buộc và tùy chọn để xe có thể lăn bánh hợp pháp.
                    </div>
                    
                    <!-- Phí cố định (bắt buộc) -->
                    <div class="fee-option fixed-fee">
                        <div class="fee-checkbox">
                            <input type="checkbox" checked disabled>
                            <div class="fee-details">
                                <div>
                                    <div class="fee-text">Phí trước bạ & đăng ký biển số</div>
                                    <div class="fee-description">Phí bắt buộc theo quy định nhà nước</div>
                                </div>
                                <div class="fee-amount" data-fee="fixed">
                                    <fmt:formatNumber value="12000000" pattern="#,##0" />đ
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Bảo hiểm vật chất (tùy chọn) -->
                    <div class="fee-option">
                        <label class="fee-checkbox">
                            <input type="checkbox" id="insuranceFee" name="insuranceFee" value="true">
                            <div class="fee-details">
                                <div>
                                    <div class="fee-text">Bảo hiểm vật chất xe (1 năm)</div>
                                    <div class="fee-description">Bảo hiểm toàn diện cho thân vỏ và động cơ</div>
                                </div>
                                <div class="fee-amount" data-fee="insurance">
                                    <fmt:formatNumber value="${subtotalPrice * 0.035}" pattern="#,##0" />đ
                                </div>
                            </div>
                        </label>
                    </div>
                </div>

                <h2 class="section-title">Phương thức thanh toán</h2>
                <div class="payment-method-selection">
                    <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="Chuyển khoản/Thẻ" checked>
                        <div class="custom-radio-box">
                            <span class="payment-icon"><i class="fa-solid fa-credit-card"></i></span>
                            <span class="payment-text">Chuyển khoản ngân hàng / Thẻ tín dụng</span>
                        </div>
                    </label>
                </div>

                <h2 class="section-title">Sản phẩm đặt mua</h2>
                <div class="product-order">
                    <c:set var="subtotalPrice" value="${0}" />
                    <c:forEach var="item" items="${itemsToCheckout}">
                        <div class="product-item">
                            <img src="${pageContext.request.contextPath}/uploads/${item.mainImageURL}" alt="${item.carName}">
                            <div class="prod-info">
                                <div class="prod-name">${item.carName}</div>
                                <div class="prod-qty">x ${item.quantity}</div>
                            </div>

                            <c:set var="itemTotal" value="${item.price * item.quantity}" />
                            <c:set var="subtotalPrice" value="${subtotalPrice + itemTotal}" />

                            <div class="prod-price">
                                <fmt:formatNumber value="${item.price}" pattern="#,##0" />đ
                            </div>
                        </div>

                        <input type="hidden" name="carID" value="${item.carID}">
                        <input type="hidden" name="quantity" value="${item.quantity}">
                    </c:forEach>
                </div>

                <!-- Thêm hidden field để JavaScript có thể đọc được subtotalPrice -->
                <input type="hidden" id="subtotalPrice" value="${subtotalPrice}" data-subtotal="${subtotalPrice}">

                <c:set var="taxRate" value="${0.10}" />
                <c:set var="taxAmount" value="${subtotalPrice * taxRate}" />
                <c:set var="fixedFee" value="${12000000}" />
                <c:set var="insuranceRate" value="${0.035}" />
                <c:set var="insuranceAmount" value="${subtotalPrice * insuranceRate}" />
                <c:set var="extra" value="${fixedFee}" />
                <c:set var="totalAmount" value="${subtotalPrice + taxAmount + extra}" />

                <div class="payment-summary">
                    <div class="row">
                        <div class="label">Giá sản phẩm (Tạm tính):</div>
                        <div class="value" data-subtotal="${subtotalPrice}"><fmt:formatNumber value="${subtotalPrice}" pattern="#,##0" />đ</div>
                    </div>
                    <div class="row">
                        <div class="label">Thuế (<fmt:formatNumber value="${taxRate*100}" pattern="#0" />%):</div>
                        <div class="value" id="taxAmount"><fmt:formatNumber value="${taxAmount}" pattern="#,##0" />đ</div>
                    </div>
                    <div class="row">
                        <div class="label">Phí trước bạ & đăng ký:</div>
                        <div class="value" data-fee="fixed"><fmt:formatNumber value="${fixedFee}" pattern="#,##0" />đ</div>
                    </div>
                    <div class="row">
                        <div class="label">Bảo hiểm vật chất (3.5%):</div>
                        <div class="value" data-fee="insurance"><fmt:formatNumber value="0" pattern="#,##0" />đ</div>
                    </div>
                    <div class="row" style="border-top: 1px solid #ddd; padding-top: 10px; font-weight: bold;">
                        <div class="label">Tổng thanh toán:</div>
                        <div class="value" data-fee="total"><fmt:formatNumber value="${totalAmount}" pattern="#,##0" />đ</div>
                    </div>
                </div>

                <input type="hidden" name="totalAmount" value="${totalAmount}">
                <input type="hidden" name="fixedFee" value="${fixedFee}">

                <div class="order-footer">
                    <div class="total-label">Tổng thanh toán:</div>
                    <div class="total-value" data-fee="total">
                        <fmt:formatNumber value="${totalAmount}" pattern="#,##0" />đ
                    </div>
                    <button type="submit" class="btn-order">Đặt hàng</button>
                </div>

            </form>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>
