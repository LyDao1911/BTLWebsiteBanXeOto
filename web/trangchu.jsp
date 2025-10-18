<%-- 
    Document   : trangchu
    Created on : Oct 15, 2025, 4:56:23 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>
         <!-- 🔹 THANH TÁC VỤ -->
        <header class="navbar">
            <div class="logo">
                <img src="image/logo.png" alt="Velyra Aero Logo" />
                <span>VELYRA AERO</span>
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

        <!-- 🔹 HERO VIDEO -->
        <section class="hero">
            <video autoplay muted loop playsinline class="hero-video">
                <source src="video/video_home.mp4" type="video/mp4" />
            </video>

            <div class="overlay"></div>

            <div class="hero-content">
                <h1>Khám phá thế giới xe tương lai</h1>
                <p>Trải nghiệm sức mạnh & công nghệ vượt trội cùng Velyra Aero</p>
            </div>
        </section>



        <!-- HÃNG XE -->
        <section class="brands">
            <div><img src="images/mercedes.png"><p>MERCEDES-BENZ</p></div>
            <div><img src="images/tesla.png"><p>TESLA</p></div>
            <div><img src="images/porsche.png"><p>PORSCHE</p></div>
            <div><img src="images/ferrari.png"><p>FERRARI</p></div>
            <div><img src="images/rolls.png"><p>ROLLS-ROYCE</p></div>
            <div><img src="images/mazda.png"><p>MAZDA</p></div>
        </section>

        <!-- FERRARI -->
        <section class="car-section">
            <h2>Ferrari</h2>
            <div class="car-list">
                <div class="car-card">
                    <img src="images/ferrari1.png" alt="Ferrari 296 GTS">
                    <p>Ferrari 296 GTS</p>
                </div>
                <div class="car-card">
                    <img src="images/ferrari2.png" alt="Ferrari 849 Testarossa">
                    <p>Ferrari 849 Testarossa</p>
                </div>
            </div>
        </section>

        <!-- MERCEDES -->
        <section class="car-section">
            <h2>Mercedes</h2>
            <div class="car-list">
                <div class="car-card">
                    <img src="images/mercedes1.png" alt="GLS 480">
                    <p>Mercedes-Maybach GLS 480 4MATIC</p>
                </div>
                <div class="car-card">
                    <img src="images/mercedes2.png" alt="S680">
                    <p>Mercedes-Maybach S680 4MATIC</p>
                </div>
            </div>
        </section>

        <!-- LEXUS -->
        <section class="car-section">
            <h2>Lexus</h2>
            <div class="car-list">
                <div class="car-card">
                    <img src="images/lexus1.png" alt="Lexus LX 570">
                    <p>Lexus LX 570 2010</p>
                </div>
                <div class="car-card">
                    <img src="images/lexus2.png" alt="Lexus NX 300h">
                    <p>Lexus NX 300h / NX 200t</p>
                </div>
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
