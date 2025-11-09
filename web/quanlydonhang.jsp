<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%-- ⭐ THÊM DÒNG NÀY --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản Lý Đơn Hàng</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            /* (Giữ nguyên CSS của cậu) */
            .status {
                padding: 5px 10px;
                border-radius: 15px;
                font-weight: bold;
                font-size: 0.9em;
                color: white;
            }
            .status-pending {
                background-color: #f39c12;
            }
            .status-completed {
                background-color: #2ecc71;
            }
            .status-cancelled {
                background-color: #e74c3c;
            }

            .container {
                max-width: 1200px;
                margin: 100px auto 60px;
                padding: 30px;
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 5px 25px rgba(0, 0, 0, 0.1);
            }

            .title {
                text-align: center;
                margin-bottom: 40px;
                color: #333;
                font-size: 32px;
                font-weight: 700;
                letter-spacing: 1px;
            }

            /* Bảng đơn hàng */
            .table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
                background: #fff;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 3px 15px rgba(0, 0, 0, 0.08);
            }

            .table th {
                background: linear-gradient(135deg, #2c3e50, #34495e);
                color: white;
                padding: 18px 15px;
                font-weight: 600;
                font-size: 15px;
                text-align: center;
                border: none;
            }

            .table td {
                padding: 16px 15px;
                text-align: center;
                border-bottom: 1px solid #ecf0f1;
                font-size: 14px;
                color: #555;
            }

            .table tr:hover {
                background-color: #f8f9fa;
                transition: all 0.3s ease;
            }

            /* Status badges */
            .status {
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-pending {
                background: linear-gradient(135deg, #f39c12, #e67e22);
                color: white;
                box-shadow: 0 2px 8px rgba(243, 156, 18, 0.3);
            }

            .status-completed {
                background: linear-gradient(135deg, #27ae60, #2ecc71);
                color: white;
                box-shadow: 0 2px 8px rgba(46, 204, 113, 0.3);
            }

            .status-cancelled {
                background: linear-gradient(135deg, #e74c3c, #c0392b);
                color: white;
                box-shadow: 0 2px 8px rgba(231, 76, 60, 0.3);
            }

            /* Nút hành động */
            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                font-size: 13px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
                text-align: center;
            }

            .btn-success {
                background: linear-gradient(135deg, #27ae60, #2ecc71);
                color: white;
                box-shadow: 0 3px 10px rgba(46, 204, 113, 0.3);
            }

            .btn-success:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(46, 204, 113, 0.4);
                background: linear-gradient(135deg, #229954, #27ae60);
            }

            .btn-sm {
                padding: 8px 16px;
                font-size: 12px;
            }

            /* Thông báo */
            .alert {
                padding: 15px 20px;
                border-radius: 10px;
                margin-bottom: 25px;
                text-align: center;
                font-weight: 500;
            }

            .alert-success {
                background: linear-gradient(135deg, #d4edda, #c3e6cb);
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .alert-error {
                background: linear-gradient(135deg, #f8d7da, #f5c6cb);
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .container {
                    margin: 80px 15px 40px;
                    padding: 20px;
                }

                .title {
                    font-size: 24px;
                    margin-bottom: 25px;
                }

                .table {
                    font-size: 12px;
                }

                .table th,
                .table td {
                    padding: 12px 8px;
                }

                .status {
                    padding: 6px 12px;
                    font-size: 10px;
                }

                .btn {
                    padding: 8px 14px;
                    font-size: 11px;
                }
            }

            /* Hiệu ứng loading */
            .table tr {
                transition: all 0.3s ease;
            }

            .table tr.updating {
                background-color: #fff3cd;
                opacity: 0.7;
            }

            /* Icon trong nút */
            .btn i {
                margin-right: 5px;
            }

        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="container">
            <h2 class="title">Quản Lý Đơn Hàng</h2>

            <c:if test="${not empty sessionScope.successMessage}">
                <p style="color: green; text-align: center; margin-bottom: 15px;">${sessionScope.successMessage}</p>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <p style="color: red; text-align: center; margin-bottom: 15px;">${sessionScope.errorMessage}</p>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <table class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID Đơn</th>
                        <th>Tên Khách Hàng</th>
                        <th>Ngày Đặt</th>
                        <th>Tổng Tiền (VNĐ)</th>
                        <th>Thanh Toán</th>
                        <th>Trạng Thái Giao Hàng</th>
                        <th>Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orderList}">
                        <tr>
                            <td>#${order.orderID}</td>
                            <td>${order.customerName}</td>

                         
                            <td>${fn:replace(order.orderDate, 'T', ' ')}</td>

                            <td><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'Paid'}">
                                        <span class="status status-completed">Đã Thanh Toán</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status status-pending">${order.paymentStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.deliveryStatus == 'Hoàn thành'}">
                                        <span class="status status-completed">Hoàn thành</span>
                                    </c:when>
                                    <c:when test="${order.deliveryStatus == 'Đã hủy'}">
                                        <span class="status status-cancelled">Đã hủy</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status status-pending">${order.deliveryStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${order.deliveryStatus == 'Chờ xử lý'}">
                                    <form action="AdminOrderServlet" method="POST" style="margin:0;">
                                        <input type="hidden" name="orderId" value="${order.orderID}">
                                        <input type="hidden" name="newStatus" value="Hoàn thành">
                                        <button type="submit" class="btn btn-success btn-sm">
                                            <i class="fas fa-check"></i> Hoàn thành
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>