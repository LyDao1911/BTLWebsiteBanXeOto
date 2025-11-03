<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Customer" %>
<%
    Customer customer = (Customer) request.getAttribute("customer");
%>
<!DOCTYPE html>
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

                <c:set var="taxRate" value="${0.10}" />
                <c:set var="taxAmount" value="${subtotalPrice * taxRate}" />
                <c:set var="extra" value="${0}" />
                <c:set var="totalAmount" value="${subtotalPrice + taxAmount + extra}" />

                <div class="payment-summary">
                    <div class="row">
                        <div class="label">Giá sản phẩm (Tạm tính):</div>
                        <div class="value"><fmt:formatNumber value="${subtotalPrice}" pattern="#,##0" />đ</div>
                    </div>
                    <div class="row">
                        <div class="label">Thuế (<fmt:formatNumber value="${taxRate*100}" pattern="#0" />%):</div>
                        <div class="value"><fmt:formatNumber value="${taxAmount}" pattern="#,##0" />đ</div>
                    </div>
                    <div class="row">
                        <div class="label">Phụ phí:</div>
                        <div class="value"><fmt:formatNumber value="${extra}" pattern="#,##0" />đ</div>
                    </div>
                </div>

                <fmt:formatNumber value="${totalAmount}" pattern="#0" var="rawTotalAmount"/>
                <input type="hidden" name="totalAmount" value="${rawTotalAmount}">

                <div class="order-footer">
                    <div class="total-label">Tổng thanh toán:</div>
                    <div class="total-value">
                        <fmt:formatNumber value="${totalAmount}" pattern="#,##0" />đ
                    </div>
                    <button type="submit" class="btn-order">Đặt hàng</button>
                </div>

            </form>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>
