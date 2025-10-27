<%-- 
    Document   : dathang
    Created on : Oct 21, 2025, 9:48:41 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đặt hàng - Velyra Aero</title>
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
                        <li><a href="SanPhamServlet">Quản lý Xe</a></li>
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
        <div class="order-container">
            <h2 class="section-title">Thông tin khách hàng</h2>
            <div class="customer-info">
                <div class="field">
                    <label>Họ tên</label>
                    <input type="text" placeholder="Nhập họ tên">
                </div>
                <div class="field">
                    <label>Địa chỉ</label>
                    <input type="text" placeholder="Nhập địa chỉ">
                </div>
                <div class="field">
                    <label>Số điện thoại</label>
                    <input type="text" placeholder="Nhập số điện thoại">
                </div>
            </div>

            <h2 class="section-title">Mercedes</h2>
            <div class="product-order">
                <div class="product-item">
                    <img src="images/vinfast-lux.png" alt="VinFast Lux A2.0">
                    <div class="prod-info">
                        <div class="prod-name">VinFast Lux A2.0</div>
                        <div class="prod-qty">x1</div>
                    </div>
                    <div class="prod-price">981.695.000đ</div>
                </div>
            </div>

            <div class="payment-summary">
                <div class="row">
                    <div class="label">Giá sản phẩm:</div>
                    <div class="value">981.695.000đ</div>
                </div>
                <div class="row">
                    <div class="label">Thuế:</div>
                    <div class="value">0đ</div>
                </div>
                <div class="row">
                    <div class="label">Phụ phí:</div>
                    <div class="value">0đ</div>
                </div>
            </div>

            <div class="order-footer">
                <div class="total-label">Tổng thanh toán:</div>
                <div class="total-value" id="totalPay">981.695.000đ</div>
                <button class="btn-order">Đặt hàng</button>
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
