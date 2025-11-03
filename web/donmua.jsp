<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Tất cả đơn mua - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <style>
            /* ✅ THÊM STYLE CHO THÔNG BÁO THÀNH CÔNG */
            .success-notification {
                background: #d4edda;
                color: #155724;
                padding: 15px;
                border-radius: 5px;
                margin: 15px 0;
                border: 1px solid #c3e6cb;
                text-align: center;
                font-weight: bold;
            }
        </style>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Đơn giản: cho phép chuyển trang bình thường
                document.querySelectorAll('.tabs .tab').forEach(tab => {
                    tab.addEventListener('click', function (e) {
                        // Không cần e.preventDefault(), để nó chuyển trang bình thường
                        // URL sẽ có dạng: DonMuaServlet?tab=paid
                    });
                });

                // Xử lý nút thanh toán
                document.querySelectorAll('.btn-primary').forEach(button => {
                    button.addEventListener('click', function (e) {
                        e.preventDefault();
                        if (confirm("Bạn có chắc muốn thanh toán đơn hàng này?")) {
                            window.location.href = this.getAttribute('href');
                        }
                    });
                });
            });
        </script>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="order-page">
            <!-- ✅ THÊM THÔNG BÁO THÀNH CÔNG Ở ĐÂY -->
            <c:if test="${not empty successMessage}">
                <div class="success-notification">
                    <i class="fas fa-check-circle"></i> ${successMessage}
                </div>
            </c:if>

            <div class="tabs">
                <c:set var="currentTab" value="${param.tab != null ? param.tab : 'all'}" />
                <a href="DonMuaServlet?tab=all" class="tab <c:if test="${currentTab == 'all'}">active</c:if>">TẤT CẢ</a>
                <a href="DonMuaServlet?tab=paid" class="tab <c:if test="${currentTab == 'paid'}">active</c:if>">ĐÃ THANH TOÁN</a>
                <a href="DonMuaServlet?tab=unpaid" class="tab <c:if test="${currentTab == 'unpaid'}">active</c:if>">CHƯA THANH TOÁN</a>
                <a href="DonMuaServlet?tab=completed" class="tab <c:if test="${currentTab == 'completed'}">active</c:if>">HOÀN THÀNH</a>
            </div>

            <c:choose>
                <c:when test="${not empty requestScope.ordersAll}">
                    <c:forEach var="order" items="${requestScope.ordersAll}" varStatus="status">
                        <div class="brand-section">
                            <div class="brand-name">
                                Đơn hàng #${order.orderID} - 
                                <c:choose>
                                    <%-- SỬA LỖI CHÍNH TẢ Ở ĐÂY --%>
                                    <c:when test="${order.paymentStatus == 'Đã thanh toán'}"> 
                                        <span class="status-paid">ĐÃ THANH TOÁN</span>
                                    </c:when>
                                    <c:when test="${order.paymentStatus == 'Chưa thanh toán'}">
                                        <span class="status-unpaid">CHƯA THANH TOÁN</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-processing">${order.paymentStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                                <span style="font-size:0.9em; color:#6c757d; margin-left: 10px;">
                                    | Trạng thái giao hàng: 
                                    <c:choose>
                                        <c:when test="${order.deliveryStatus == 'Hoàn thành'}">
                                            <span class="status-paid">${order.deliveryStatus}</span>
                                        </c:when>
                                        <c:when test="${order.deliveryStatus == 'Chờ xử lý'}"> 
                                            <span class="status-unpaid">CHỜ XỬ LÝ</span>
                                        </c:when>
                                        <c:when test="${order.deliveryStatus == 'Đang xử lý'}"> 
                                            <span class="status-processing">ĐANG XỬ LÝ</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-processing">${order.deliveryStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <div class="product-list">
                                <c:forEach var="detail" items="${order.orderDetails}">
                                    <div class="product-item">
                                        <c:choose>
                                            <c:when test="${not empty detail.carImage}">
                                                <img src="${pageContext.request.contextPath}/uploads/${detail.carImage}" alt="${detail.carName}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/images/xe1.png" alt="${detail.carName}">
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="prod-info">
                                            <div class="prod-name">${detail.carName}</div>
                                            <div class="prod-qty">x ${detail.quantity}</div> 
                                        </div>
                                        <div class="prod-price">
                                            <fmt:formatNumber value="${detail.price}" pattern="#,##0"/>đ
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <div class="brand-footer">
                                <div class="brand-total">
                                    Thành tiền: <span style="color:#e74c3c;"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/>đ</span>
                                </div>

                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'Chưa thanh toán'}">
                                        <a href="PaymentProcessingServlet?orderId=${order.orderID}&amount=${order.totalAmount}" class="btn-primary">THANH TOÁN NGAY</a>
                                    </c:when>
                                    <c:when test="${order.deliveryStatus == 'Hoàn thành'}">
                                        <button class="btn-success">GIAO DỊCH THÀNH CÔNG</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn-secondary" disabled>ĐANG XỬ LÝ</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <div class="empty-order">
                        <i class="fa-solid fa-file-invoice-dollar" style="font-size:40px; margin-bottom:10px;"></i>
                        <p>Bạn chưa có đơn hàng nào.</p>
                        <a href="HomeServlet" style="text-decoration:none; color:#007bff; font-weight:bold;">Tiếp tục mua sắm</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>