<%-- 
    Document   : chuathanhtoan
    Created on : Oct 22, 2025, 9:58:49 PM
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

        <!-- 🧭 HEADER -->

        <header class="navbar">
            <div class="logo">
                <a href="HomeServlet" style="text-decoration: none; color: inherit;">
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
                        <li><a href="sanpham.jsp">Quản lý Xe</a></li>
                    </ul>
                </div>

                <!-- MENU TÀI KHOẢN ADMIN -->
                <div class="account-menu">
                    <span class="account-name">
                        👋 <%= username%> <i class="fa-solid fa-caret-down"></i>
                    </span>
                    <ul class="dropdown">
                        <li><a href="hoso.jsp">Thông tin cá nhân</a></li>
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
        <div class="order-page">
            <!-- Tabs -->
            <div class="tabs">
                <a href="donmua.jsp" class="tab">TẤT CẢ</a>
                <a href="dathanhtoan.jsp" class="tab">ĐÃ THANH TOÁN</a>
                <a href="chuathanhtoan.jsp" class="tab active">CHƯA THANH TOÁN</a>
                <a href="hoanthanh.jsp" class="tab">HOÀN THÀNH</a>
            </div>

            <!-- Brand block -->
            <div class="brand-section">
                <div class="brand-name">FERRARI</div>
                <div class="product-list">
                    <div class="product-item">
                        <img src="images/vinfast.png" alt="VinFast">
                        <div class="prod-info">
                            <div class="prod-name">VinFast Lux A2.0</div>
                            <div class="prod-qty">× 1</div>
                        </div>
                        <div class="prod-price">981.695.000đ</div>
                    </div>

                    <div class="product-item">
                        <img src="images/vinfast.png" alt="VinFast">
                        <div class="prod-info">
                            <div class="prod-name">VinFast Lux A2.0</div>
                            <div class="prod-qty">× 1</div>
                        </div>
                        <div class="prod-price">981.695.000đ</div>
                    </div>
                </div>

                <div class="brand-footer">
                    <div class="brand-total">Thành tiền: <span>981.695.000đ</span></div>
                    <form action="ThanhToanServlet" method="post">
                        <input type="hidden" name="orderId" value="123">
                        <button type="submit" class="btn-pay">THANH TOÁN</button>
                    </form>
                </div>
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
