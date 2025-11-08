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
        <title>Hóa đơn | VELYRA AERO</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
            }

            .invoice-container {
                max-width: 1000px;
                margin: 120px auto 60px;
                padding: 40px;
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(229, 43, 43, 0.1);
            }

            .invoice-header {
                text-align: center;
                margin-bottom: 40px;
                position: relative;
                padding-bottom: 20px;
                border-bottom: 3px solid #e52b2b;
            }

            .invoice-header h1 {
                font-size: 2.5rem;
                font-weight: 300;
                color: #1a1a1a;
                letter-spacing: 3px;
                text-transform: uppercase;
                margin: 0;
            }

            .info-section {
                background: linear-gradient(135deg, #fafafa 0%, #f5f5f5 100%);
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
                border: 1px solid rgba(0, 0, 0, 0.05);
            }

            .info-section p {
                margin: 8px 0;
                font-size: 1rem;
                color: #555;
                line-height: 1.6;
            }

            .info-section b {
                color: #333;
                font-weight: 600;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
                background: #fff;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            }

            th {
                background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
                color: #fff;
                padding: 20px 15px;
                font-weight: 500;
                font-size: 0.9rem;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                border-bottom: 3px solid #e52b2b;
            }

            td {
                padding: 18px 15px;
                color: #555;
                font-size: 0.95rem;
                line-height: 1.6;
                border-bottom: 1px solid rgba(0, 0, 0, 0.03);
            }

            tbody tr {
                transition: all 0.3s ease;
                position: relative;
            }

            tbody tr:hover {
                background: linear-gradient(90deg, #fff 0%, #fafafa 50%, #fff 100%);
            }

            tbody tr::after {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                height: 100%;
                width: 4px;
                background: #e52b2b;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            tbody tr:hover::after {
                opacity: 1;
            }

            .fee-section {
                background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
                padding: 25px;
                border-radius: 15px;
                margin: 25px 0;
                border: 1px solid #ffb74d;
            }

            .fee-section h3 {
                color: #e52b2b;
                margin-bottom: 20px;
                font-size: 1.3rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                border-bottom: 2px solid #e52b2b;
                padding-bottom: 10px;
            }

            .fee-details {
                background: rgba(255, 255, 255, 0.7);
                padding: 20px;
                border-radius: 10px;
            }

            .fee-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                padding: 8px 0;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            }

            .fee-title {
                font-weight: 600;
                color: #333;
            }

            .tax-details {
                background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                padding: 30px;
                border-radius: 15px;
                margin: 30px 0;
                border: 1px solid #81c784;
            }

            .tax-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 15px;
                padding: 10px 0;
                font-size: 1rem;
                color: #555;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            }

            .total {
                display: flex;
                justify-content: space-between;
                margin-top: 20px;
                padding-top: 20px;
                border-top: 2px solid #e52b2b;
                font-weight: bold;
                font-size: 1.3rem;
                color: #e52b2b;
            }

            .thanks {
                text-align: center;
                margin-top: 40px;
                padding: 25px;
                background: linear-gradient(135deg, #e52b2b 0%, #b30000 100%);
                color: white;
                border-radius: 15px;
                font-weight: 600;
                font-size: 1.2rem;
                letter-spacing: 2px;
                text-transform: uppercase;
            }

            .error {
                color: #dc3545;
                text-align: center;
                padding: 30px;
                background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
                border-radius: 15px;
                margin: 20px 0;
                border: 1px solid #dc3545;
            }

            /* Animation */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .invoice-container {
                animation: fadeInUp 0.6s ease;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .invoice-container {
                    margin: 100px auto 40px;
                    padding: 25px;
                    border-radius: 15px;
                }
                
                .invoice-header h1 {
                    font-size: 2rem;
                }
                
                .info-section {
                    padding: 20px;
                }
                
                th, td {
                    padding: 12px 8px;
                    font-size: 0.9rem;
                }
                
                .fee-row,
                .tax-row {
                    flex-direction: column;
                    gap: 5px;
                }
                
                .total {
                    font-size: 1.1rem;
                }
            }

            /* Note section */
            .note-section {
                background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
                padding: 20px;
                border-radius: 12px;
                margin-top: 25px;
                border: 1px solid #2196f3;
            }

            .note-section strong {
                color: #1976d2;
                font-size: 1rem;
            }

            .note-section span {
                color: #555;
                font-size: 0.95rem;
                line-height: 1.5;
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

            // Tính toán tổng tiền và phụ phí
            double tongTien = 0;
            double thue = 0;
            double phiTruocBa = 12000000; // Phí cố định 12 triệu
            double baoHiem = 0;
            double tongPhuPhi = 0;
            double tongTienThanhToan = 0;

            // Phân tích ghi chú để lấy thông tin phụ phí
            boolean coBaoHiem = false;
            if (order != null && order.getNote() != null) {
                String note = order.getNote();
                if (note.contains("Bảo hiểm:")) {
                    coBaoHiem = !note.contains("Bảo hiểm: Không");
                    // Trích xuất số tiền bảo hiểm từ ghi chú nếu có
                    if (coBaoHiem && note.contains("Bảo hiểm: ")) {
                        try {
                            String[] parts = note.split("\\|");
                            for (String part : parts) {
                                if (part.trim().startsWith("Bảo hiểm:")) {
                                    String bhPart = part.trim().replace("Bảo hiểm:", "").trim();
                                    if (!bhPart.equals("Không")) {
                                        bhPart = bhPart.replaceAll("[^\\d]", "");
                                        baoHiem = Double.parseDouble(bhPart);
                                    }
                                }
                            }
                        } catch (Exception e) {
                            // Nếu không trích xuất được, tính toán dựa trên tổng tiền
                        }
                    }
                }
            }

            if (chiTietHoaDonList != null && !chiTietHoaDonList.isEmpty()) {
                for (OrderDetail chiTiet : chiTietHoaDonList) {
                    if (chiTiet.getSubtotal() != null) {
                        tongTien += chiTiet.getSubtotal().doubleValue();
                    }
                }

                // Nếu không trích xuất được từ ghi chú, tính bảo hiểm dựa trên tổng tiền (3.5%)
                if (coBaoHiem && baoHiem == 0) {
                    baoHiem = tongTien * 0.035;
                }

                thue = tongTien * 0.10;
                tongPhuPhi = phiTruocBa + baoHiem;
                tongTienThanhToan = tongTien + thue + tongPhuPhi;
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

            <!-- PHẦN MỚI: HIỂN THỊ PHỤ PHÍ -->
            <div class="fee-section">
                <h3>CHI TIẾT PHỤ PHÍ</h3>
                <div class="fee-details">
                    <div class="fee-row">
                        <span class="fee-title">Phí trước bạ & đăng ký biển số:</span>
                        <span><%= formatter.format(phiTruocBa)%>đ</span>
                    </div>
                    <div class="fee-row">
                        <span class="fee-title">Bảo hiểm vật chất xe (<%= coBaoHiem ? "3.5%" : "Không áp dụng"%>):</span>
                        <span><%= coBaoHiem ? formatter.format(baoHiem) + "đ" : "0đ"%></span>
                    </div>
                    <div class="fee-row" style="border-top: 1px solid #ccc; padding-top: 8px; font-weight: bold;">
                        <span class="fee-title">Tổng phụ phí:</span>
                        <span><%= formatter.format(tongPhuPhi)%>đ</span>
                    </div>
                </div>
            </div>

            <div class="tax-details">
                <div class="tax-row">
                    <span>Tổng tiền hàng:</span>
                    <span><%= formatter.format(tongTien)%>đ</span>
                </div>
                <div class="tax-row">
                    <span>Thuế VAT (10%):</span>
                    <span><%= formatter.format(thue)%>đ</span>
                </div>
                <div class="tax-row">
                    <span>Phụ phí:</span>
                    <span><%= formatter.format(tongPhuPhi)%>đ</span>
                </div>
                <div class="total">
                    <span>Tổng tiền thanh toán:</span>
                    <span><%= formatter.format(tongTienThanhToan)%>đ</span>
                </div>
            </div>

            <div class="thanks">
                CẢM ƠN BẠN ĐÃ MUA HÀNG
            </div>

            <!-- Hiển thị ghi chú từ đơn hàng nếu có -->
            <% if (order != null && order.getNote() != null && !order.getNote().isEmpty()) {%>
            <div class="note-section">
                <strong>Ghi chú đơn hàng:</strong> 
                <span><%= order.getNote()%></span>
            </div>
            <% }%>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>