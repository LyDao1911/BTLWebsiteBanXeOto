<%-- 
    Document   : orderSuccess
    Created on : Nov 2, 2025, 2:29:17 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thanh toán thành công</title>
        <style>
            .success-container {
                text-align: center;
                margin: 50px auto;
                max-width: 600px;
                padding: 30px;
                border: 2px solid #28a745;
                border-radius: 10px;
                background-color: #f8fff9;
            }
            .success-icon {
                font-size: 48px;
                color: #28a745;
                margin-bottom: 20px;
            }
            .btn {
                display: inline-block;
                padding: 10px 20px;
                margin: 10px;
                background-color: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 5px;
            }
            .btn:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <div class="success-container">
            <div class="success-icon">✅</div>
            <h2>Thanh toán thành công!</h2>
            
            <%
                String orderId = request.getParameter("orderId");
                if (orderId != null) {
            %>
                <p><strong>Mã đơn hàng: #<%= orderId %></strong></p>
            <%
                }
            %>
            
            <p>Cảm ơn bạn đã đặt hàng tại <strong>Velyra Aero</strong>.</p>
            <p>Đơn hàng của bạn đã được xác nhận và sẽ được xử lý trong thời gian sớm nhất.</p>
            
            <div>
                <a href="trangchu.jsp" class="btn">🏠 Về trang chủ</a>
                <a href="DonMuaServlet?tab=paid" class="btn">📦 Xem đơn đã thanh toán</a>
            </div>
        </div>
    </body>
</html>