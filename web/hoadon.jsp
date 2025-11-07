<%-- 
    Document   : hoadon
    Created on : Oct 22, 2025, 10:09:24 PM
    Author     : Admin
--%>

<%@page import="model.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.OrderDAO, model.Order, model.OrderDetail, java.util.List, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hóa đơn - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <!-- Font Awesome --> 
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            .tax-details {
                text-align: right;
                margin-bottom: 20px;
            }

            .tax-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 5px;
                padding: 0 10px;
            }

            .total {
                display: flex;
                justify-content: space-between;
                margin-top: 10px;
                padding-top: 10px;
                border-top: 1px solid #ddd;
                font-weight: bold;
                font-size: 1.1em;
            }
            .invoice-container {
                max-width: 800px;
                margin: 20px auto;
                padding: 20px;
                border: 1px solid #ddd;
                font-family: Arial, sans-serif;
            }

            .invoice-header {
                text-align: center;
                margin-bottom: 20px;
            }

            .info-section {
                margin-bottom: 20px;
                line-height: 1.6;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }

            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }

            th {
                background-color: #f2f2f2;
            }

            .tax, .total {
                text-align: right;
                margin-bottom: 10px;
                font-weight: bold;
            }

            .thanks {
                text-align: center;
                margin-top: 20px;
                font-weight: bold;
            }

            .error {
                color: red;
                text-align: center;
                padding: 20px;
            }
        </style>
    </head>
    <body>

        <jsp:include page="header.jsp" />

        <%
            // Xử lý trực tiếp trong JSP
            String orderIdParam = request.getParameter("orderId");
            OrderDAO orderDAO = new OrderDAO();
            Order order = null;
            Customer customer = null;
            String paymentMethod = null;
            List<OrderDetail> chiTietHoaDonList = null;

            if (orderIdParam != null && !orderIdParam.isEmpty()) {
                try {
                    int orderId = Integer.parseInt(orderIdParam);
                    order = orderDAO.getOrderById(orderId);
                    if (order != null) {
                        customer = orderDAO.getCustomerByOrderId(orderId);
                        paymentMethod = orderDAO.getPaymentMethodByOrderId(orderId);
                        chiTietHoaDonList = order.getOrderDetails();
                    }
                } catch (NumberFormatException e) {
                    // Xử lý lỗi
                }
            }

            DecimalFormat formatter = new DecimalFormat("###,###,###");

            // Tính toán tổng tiền
            double tongTien = 0;
            double thue = 0;
            double tongTienThanhToan = 0;

            if (chiTietHoaDonList != null && !chiTietHoaDonList.isEmpty()) {
                for (OrderDetail chiTiet : chiTietHoaDonList) {
                    if (chiTiet.getSubtotal() != null) {
                        tongTien += chiTiet.getSubtotal().doubleValue();
                    }
                }
                thue = tongTien * 0.10;
                tongTienThanhToan = tongTien + thue;
            }
        %>

        <div class="invoice-container">
            <div class="invoice-header">
                <h1>HÓA ĐƠN</h1>
            </div>

            <div class="info-section">
                <p><b>Mã hóa đơn:</b> <%= order != null ? order.getOrderID() : "N/A"%></p>
                <p><b>Thông tin khách hàng</b> --------------</p>
                <p><b>Họ và tên:</b> <%= customer != null ? customer.getFullName() : "N/A"%></p>
                <p><b>Địa chỉ:</b> <%= customer != null ? customer.getAddress() : "N/A"%></p>
                <p><b>Số điện thoại:</b> <%= customer != null ? customer.getPhoneNumber() : "N/A"%></p>
                <p><b>Hình thức thanh toán:</b> <%= paymentMethod != null ? paymentMethod : "Thanh toán khi nhận hàng"%></p>
                <p><b>Ngày đặt hàng:</b> <%= order != null && order.getOrderDate() != null ? order.getOrderDate().toString() : "N/A"%></p>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>TÊN Ô TÔ</th>
                        <th>SỐ LƯỢNG</th>
                        <th>ĐƠN GIÁ</th>
                        <th>THÀNH TIỀN</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (chiTietHoaDonList != null && !chiTietHoaDonList.isEmpty()) {
                            int stt = 1;
                            for (OrderDetail chiTiet : chiTietHoaDonList) {
                    %>
                    <tr>
                        <td><%= stt%></td>
                        <td><b><%= chiTiet.getCarName() != null ? chiTiet.getCarName() : "Sản phẩm"%></b></td>
                        <td><%= chiTiet.getQuantity()%></td>
                        <td><%= chiTiet.getPrice() != null ? formatter.format(chiTiet.getPrice()) + "đ" : "0đ"%></td>
                        <td><%= chiTiet.getSubtotal() != null ? formatter.format(chiTiet.getSubtotal()) + "đ" : "0đ"%></td>
                    </tr>
                    <%
                            stt++;
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="5" style="text-align: center;">Không có sản phẩm nào</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>

            <div class="tax-details">
                <div class="tax-row">
                    <span>Tổng tiền hàng:</span>
                    <span><%= formatter.format(tongTien)%>đ</span>
                </div>
                <div class="tax-row">
                    <span>Thuế (10%):</span>
                    <span><%= formatter.format(thue)%>đ</span>
                </div>
                <div class="total">
                    <span>Tổng tiền thanh toán:</span>
                    <span><%= formatter.format(tongTienThanhToan)%>đ</span>
                </div>
            </div>
            <div class="thanks">
                CẢM ƠN BẠN ĐÃ MUA HÀNG.
            </div>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>