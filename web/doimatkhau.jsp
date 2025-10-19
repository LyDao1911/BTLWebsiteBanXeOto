<%-- 
    Document   : hoso
    Created on : Oct 19, 2025, 12:09:13 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đổi mật khẩu- Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <!-- Font Awesome --> 
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>

        <!-- 🧭 HEADER -->

        <header class="navbar">
            <div class="logo">
                <a href="trangchu.jsp" style="text-decoration: none; color: inherit;">
                    <img src="image/logo.png" alt="Velyra Aero Logo" />
                    <span>VELYRA AERO</span>
                </a>
            </div>

            <% String username = (String) session.getAttribute("username"); %>

            <nav class="menu">
                <% if (username != null) {%>
                <div class="account-menu">
                    <span class="account-name">
                        👋 <%= username%> <i class="fa-solid fa-caret-down"></i>
                    </span>
                    <ul class="dropdown">
                        <li><a href="thongtin.jsp">Thông tin cá nhân</a></li>
                        <li><a href="giohang.jsp">Giỏ hàng</a></li>
                        <li><a href="donmua.jsp">Đơn mua</a></li>
                            <% if ("admin".equals(username)) { %>
                        <li><a href="themsanpham.jsp">Thêm sản phẩm</a></li>
                            <% } %>
                        <li><a href="dangxuat.jsp">Đăng xuất</a></li>
                    </ul>
                </div>
                <% } else { %>
                <a href="dangnhap.jsp">Đăng nhập</a>
                <a href="dangky.jsp">Đăng ký</a>
                <% }%>
            </nav>
        </header>   
        <!-- 🔧 MAIN CONTENT -->
        <div class="main-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <!-- Ảnh đại diện + tên -->
                <div class="profile-header">
                    <img src="image/avatar.png" alt="Avatar" />
                    
                </div>


                <!-- Menu điều hướng -->
                <a href="hoso.jsp" class="active">HỒ SƠ</a>
                <a href="doimatkhau.jsp" class="active">ĐỔI MẬT KHẨU</a>
                <a href="donmua.jsp">ĐƠN MUA</a>
                <a href="giohang.jsp">GIỎ HÀNG</a>
            </div>

            <!-- Form hồ sơ -->
            <div class="form-section">
                <h2>Đổi mật khẩu</h2>
                <form action="saveProfile.jsp" method="post">
                    <div class="form-group">
                        <label>Tên đăng nhập</label>
                        <input type="text" name="username" value="CHAE BY">
                    </div>
                    <div>
                        <label for="password">Mật khẩu mới:</label> 
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required /> 
                    </div>
                    <div>  
                        <label for="repassword">Nhập lại mật khẩu:</label>
                        <input type="password" id="repassword" name="repassword" placeholder="Xác nhận mật khẩu" required />
                    </div>
                    <button type="submit" class="save-btn">Lưu</button>
                </form>
            </div>
        </div>

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
