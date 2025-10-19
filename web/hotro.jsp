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
      <!-- 🔹 THANH TÁC VỤ -->
        <header class="navbar">
            <div class="logo">
                <a href="trangchu.jsp" style="text-decoration: none; color: inherit;">
                    <img src="image/logo.png" alt="Velyra Aero Logo" />
                    <span>VELYRA AERO</span>
                </a>
            </div>


            <div class="search-box">
                <input type="text" placeholder="Tìm kiếm xe..." />
                <button><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>

            <nav class="menu">
                <a href="hotro.jsp">Hỗ trợ</a>
                <a href="dangnhap.jsp">Đăng nhập</a>
                <a href="dangky.jsp">Đăng ký</a>
            </nav>
        </header>
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
      
     <!-- FOOTER -->
        <footer class="footer">
            <h3>THÔNG TIN LIÊN HỆ</h3>
            <div class="footer-container">
                <!-- Cột 1 -->
                <div class="footer-column">
                    <p class="name">Đào Thị Hồng Lý</p>
                    <p><i class="fa-solid fa-calendar"></i> 2356778</p>
                    <p><i class="fa-solid fa-phone"></i> 0937298465</p>
                    <p><i class="fa-solid fa-location-dot"></i> hn</p>
                    <p><i class="fa-solid fa-envelope"></i> abc@gmail.com</p>
                </div>
                <!-- Cột 2 -->
                <div class="footer-column">
                    <p class="name">Đào Thị Hồng Lý</p>
                    <p><i class="fa-solid fa-calendar"></i> 2356778</p>
                    <p><i class="fa-solid fa-phone"></i> 0937298465</p>
                    <p><i class="fa-solid fa-location-dot"></i> hn</p>
                    <p><i class="fa-solid fa-envelope"></i> abc@gmail.com</p>
                </div>
                <!-- Cột 3 -->
                <div class="footer-column">
                    <p class="name">Đào Thị Hồng Lý</p>
                    <p><i class="fa-solid fa-calendar"></i> 2356778</p>
                    <p><i class="fa-solid fa-phone"></i> 0937298465</p>
                    <p><i class="fa-solid fa-location-dot"></i> hn</p>
                    <p><i class="fa-solid fa-envelope"></i> abc@gmail.com</p>
                </div>
            </div>
            <div class="footer-note">
                Điểm đến tin cậy cho những ai tìm kiếm sự hoàn hảo trong từng chi tiết, 
                từ lựa chọn xe đến dịch vụ hậu mãi tận tâm.
            </div>
        </footer>
 
    </body>
</html>
