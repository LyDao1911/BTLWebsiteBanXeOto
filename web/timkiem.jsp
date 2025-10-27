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
                <a href="HomeServlet" style="text-decoration: none; color: inherit;">
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
        <main class="search-page clean-style">
            <aside class="filter-box">
                <h3><i class="fas fa-filter"></i> BỘ LỌC TÌM KIẾM</h3>

                <div class="filter-group brand-filter">
                    <label>Thương hiệu</label>
                    <div class="checkbox-list">
                        <label><input type="checkbox" name="brand" value="VinFast"> VinFast</label>
                        <label><input type="checkbox" name="brand" value="Lamborghini"> Lamborghini</label>
                        <label><input type="checkbox" name="brand" value="Porsche"> Porsche</label>
                        <label><input type="checkbox" name="brand" value="Ferrari"> Ferrari</label>
                        <label><input type="checkbox" name="brand" value="Rolls-Royce"> Rolls-Royce</label>
                    </div>
                </div>

                <div class="filter-group color-filter">
                    <label>Màu sắc</label>
                    <div class="checkbox-list">
                        <label><input type="checkbox" name="color" value="Red"> Đỏ</label>
                        <label><input type="checkbox" name="color" value="Yellow"> Vàng</label>
                        <label><input type="checkbox" name="color" value="Black"> Đen</label>
                        <label><input type="checkbox" name="color" value="Blue"> Xanh</label>
                    </div>
                </div>

                <div class="filter-group price-range-filter">
                    <label>Khoảng giá</label>
                    <div class="price-input-group">
                        <input type="text" placeholder="Từ" class="price-input">
                        <div class="price-divider">-</div>
                        <input type="text" placeholder="Đến" class="price-input">
                    </div>
                    <button class="btn-filter-apply">ÁP DỤNG</button>
                </div>
                <button class="btn-clear-filters">XÓA BỘ LỌC</button>
            </aside>

            <section class="result-box">

                <div class="sort-bar clean-sort-bar">
                    <span>Sắp xếp theo:</span>
                    <button class="sort-option active">Mới Nhất</button>

                    <div class="sort-option-dropdown">
                        <button class="sort-option dropdown-toggle">Giá <i class="fas fa-sort"></i></button>
                        <div class="dropdown-content">
                            <span class="sort-action" data-sort-order="asc">Tăng dần</span>
                            <span class="sort-action" data-sort-order="desc">Giảm dần</span>
                        </div>
                    </div>
                </div>

                <div class="car-list simple-product-grid">

                    <div class="car-item simple-product-item">
                        <div class="car-image-container">
                            <img src="image/vinfast.png" alt="VinFast Lux A2.0">
                        </div>
                        <h4 class="product-name">VinFast Lux A2.0</h4>
                        <p class="product-price">981.695.000 ₫</p>
                        <span class="product-sales-badge">Đã bán 15</span>
                    </div>

                    <div class="car-item simple-product-item">
                        <div class="car-image-container">
                            <img src="image/lamborghini.png" alt="Lamborghini Aventador SVJ Roadster">
                        </div>
                        <h4 class="product-name">Lamborghini Aventador SVJ Roadster</h4>
                        <p class="product-price">21.000.000.000 ₫</p>
                        <span class="product-sales-badge">Đã bán 15</span>
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
