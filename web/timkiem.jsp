<%-- 
    Document   : timkiem
    Created on : Oct 16, 2025, 10:15:22 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tìm kiếm - Velyra Aero</title>
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

            <nav class="menu">
                <a href="hotro.jsp">Hỗ trợ</a>
                <% String username = (String) session.getAttribute("username"); %>

                <% if (username != null) { %>

                <%-- ✅ Nếu là ADMIN --%>
                <% if ("admin".equals(username)) {%>
                <!-- MENU QUẢN TRỊ -->
                <div class="admin-menu account-menu">
                    <span class="admin-name account-name">
                        Quản trị <i class="fa-solid fa-caret-down"></i>
                    </span>
                    <ul class="dropdown">
                        <li><a href="themsanpham.jsp">Quản lý Xe / Thêm</a></li>
                        <li><a href="danhmuc.jsp">Quản lý Hãng xe</a></li>
                        <li><a href="quanlykho.jsp">Quản lý Kho</a></li>
                    </ul>
                </div>

                <!-- MENU TÀI KHOẢN ADMIN -->
                <div class="account-menu">
                    <span class="account-name">
                        👋 <%= username%> <i class="fa-solid fa-caret-down"></i>
                    </span>
                    <ul class="dropdown">
                        <li><a href="ChangePasswordServlet">Đổi mật khẩu</a></li>
                        <li><a href="dangxuat.jsp">Đăng xuất</a></li>
                    </ul>
                </div>

                <% } else {%>
                <%-- ✅ Nếu là NGƯỜI DÙNG THƯỜNG --%>
                <div class="account-menu">
                    <span class="account-name">
                        👋 <%= username%> <i class="fa-solid fa-caret-down"></i>
                    </span>
                    <ul class="dropdown">
                        <li><a href="hoso.jsp">Thông tin cá nhân</a></li>
                        <li><a href="giohang.jsp">Giỏ hàng</a></li>
                        <li><a href="donmua.jsp">Đơn mua</a></li>
                        <li><a href="dangxuat.jsp">Đăng xuất</a></li>
                    </ul>
                </div>
                <% } %>

                <% } else { %>
                <%-- ✅ Nếu chưa đăng nhập --%>
                <a href="dangnhap.jsp">Đăng nhập</a>
                <a href="dangky.jsp">Đăng ký</a>
                <% }%>
            </nav>

        </header>
        <!-- ========== NỘI DUNG ========== -->
        <!-- Khu vực nội dung chính -->
        <main class="search-page">
            <!-- CỘT TRÁI: Bộ lọc -->
            <aside class="filter-box">
                <h3>▼ BỘ LỌC TÌM KIẾM</h3>
                <p>Thương hiệu</p>
                <div>
                    <label><input type="checkbox"> VinFast</label><br>
                    <label><input type="checkbox"> Lamborghini</label><br>
                    <label><input type="checkbox"> Porsche</label><br>
                    <label><input type="checkbox"> Ferrari</label><br>
                    <label><input type="checkbox"> Rolls-Royce</label><br>
                    <label><input type="checkbox"> Mercedes-Benz</label>
                </div>

                <p>Màu sắc</p>
                <div>
                    <label><input type="checkbox"> Đen</label><br>
                    <label><input type="checkbox"> Vàng</label><br>
                    <label><input type="checkbox"> Đỏ</label><br>
                    <label><input type="checkbox"> Trắng</label><br>
                    <label><input type="checkbox"> Nâu</label>
                </div>

                <p>Khoảng giá</p>
                <div class="price-range">
                    <input type="text" placeholder="Từ">
                    <input type="text" placeholder="Đến">
                </div>

                <button class="btn-filter">ÁP DỤNG</button>
            </aside>

            <!-- CỘT PHẢI: Danh sách xe -->
            <section class="result-box">
                <div class="sort-bar">
                    <span>Sắp xếp theo</span>
                    <button>Mới nhất</button>
                    <button>Giá</button>
                </div>

                <div class="car-list">
                    <div class="car-item">
                        <img src="image/vinfast.png" alt="">
                        <h4>VinFast Lux A2.0</h4>
                        <p class="price">981.695.000 đồng</p>
                        <p>Đã bán 15</p>
                    </div>

                    <div class="car-item">
                        <img src="image/lamborghini.png" alt="">
                        <h4>Lamborghini Aventador</h4>
                        <p class="price">21.000.000.000 đồng</p>
                        <p>Đã bán 15</p>
                    </div>
                </div>
            </section>
        </main>
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
