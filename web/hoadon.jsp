<%-- 
    Document   : hoadon
    Created on : Oct 22, 2025, 10:09:24 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chưa thanh toán  - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <!-- Font Awesome --> 
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>

      <jsp:include page="header.jsp" />
        <div class="invoice-container">
            <div class="invoice-header">
                <h1>HÓA ĐƠN</h1>
            </div>

            <div class="info-section">
                <p><b>Mã hóa đơn:</b> 1</p>
                <p><b>Thông tin khách hàng</b> --------------</p>
                <p><b>Họ và tên:</b> Nam Yejun</p>
                <p><b>Địa chỉ:</b> Seul</p>
                <p><b>Số điện thoại:</b> 0481294723</p>
                <p><b>Hình thức thanh toán:</b> Thanh toán khi nhận hàng</p>
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
                    <tr>
                        <td>1</td>
                        <td><b>VinFast Lux A2.0</b></td>
                        <td>1</td>
                        <td>981.695.000đ</td>
                        <td>981.695.000đ</td>
                    </tr>
                </tbody>
            </table>

            <div class="tax">Thuế suất: 15%</div>
            <div class="total">Tổng tiền thanh toán: 1.128.949.250đ</div>

            <div class="thanks">
                CẢM ƠN BẠN ĐÃ MUA HÀNG.
            </div>
        </div>
      <jsp:include page="footer.jsp" />
    </body>
</html>
