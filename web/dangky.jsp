<%-- 
    Document   : dangky
    Created on : Oct 15, 2025, 4:38:21 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String repassword = request.getParameter("repassword");

    if (username != null && password != null && repassword != null) {
        if (password.equals(repassword)) {
            // TODO: Lưu thông tin vào database nếu cần
            session.setAttribute("username", username);
            response.sendRedirect("trangchu.jsp");
            return;
        } else {
%>
            <script>alert("Mật khẩu xác nhận không khớp!");</script>
<%
        }
    }
%>

<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng ký - Velyra Aero</title>
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

        <!-- 🔸 FORM ĐĂNG KÝ --> 
        <section class="register-section"> 
            <h1>ĐĂNG KÝ TÀI KHOẢN</h1> <br><br>
            <form class="register-form" action="dangky.jsp" method="post"> 
                <label for="fullname">Họ và tên:</label> 
                <input type="text" id="fullname" name="fullname" placeholder="Nhập họ và tên" required />

                <label for="username">Tên đăng nhập:</label>
                <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập" required />

                <label for="email">Mail:</label> 
                <input type="email" id="email" name="email" placeholder="Nhập email" required />

                <label for="dob">Ngày sinh:</label>
                <input type="date" id="dob" name="dob" required />

                <label for="address">Địa chỉ:</label> 
                <input type="text" id="address" name="address" placeholder="Nhập địa chỉ" required />

                <label for="phone">SĐT:</label> 
                <input type="tel" id="phone" name="phone" placeholder="Nhập số điện thoại" required /> 

                <label for="password">Mật khẩu:</label> 
                <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required /> 

                <label for="repassword">Nhập lại mật khẩu:</label>
                <input type="password" id="repassword" name="repassword" placeholder="Xác nhận mật khẩu" required />

                <button type="submit" class="btn-register">ĐĂNG KÝ</button> 
            </form>

            <p class="login-link"> Bạn đã có tài khoản? 
                <a href="dangnhap.jsp">Đăng nhập</a>
            </p> 
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
