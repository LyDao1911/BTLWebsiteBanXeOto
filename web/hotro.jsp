<%-- 
    Document   : hotro
    Created on : Oct 15, 2025, 10:14:14 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hỗ trợ-Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <!-- Font Awesome --> 
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>
       <jsp:include page="header.jsp" />
        <section class="contact-section">
            <div class="contact-left">
                <h2>LIÊN HỆ</h2>
                <p>Hỗ trợ khách hàng mua online</p>
                <p>Tổng đài: <strong>1800 6061</strong></p>
                <p>Từ 9h - 11h, 13h - 17h các ngày từ thứ 2 đến thứ 6</p>
                <p>Email: saleonline@canifa.com</p>
                <p>Bạn vui lòng mô tả chi tiết các vấn đề cần hỗ trợ để chúng tôi hỗ trợ bạn nhanh chóng và hiệu quả nhất.</p>
            </div>

            <div class="contact-form">
                <form action="HotroServlet" method="post">
                    <label for="hoten">Họ tên</label>
                    <input type="text" name="hoten" id="hoten" required><br><br>

                    <label for="email">Email</label>
                    <input type="email" name="email" id="email" required><br><br>


                    <label for="sdt">Số điện thoại</label>
                    <input type="text" name="sdt" id="sdt" required><br><br>


                    <label for="diachi">Địa chỉ</label>
                    <input type="text" name="diachi" id="diachi"><br><br>


                    <label for="noidung">Nội dung cần hỗ trợ</label>
                    <textarea name="noidung" id="noidung" required></textarea><br><br>


                    <button type="submit">GỬI YÊU CẦU</button>
                </form>
            </div>
        </section>

       <jsp:include page="footer.jsp" />

    </body>
</html>
