<%-- 
    Document   : mota
    Created on : Oct 19, 2025, 2:39:14 PM
    Author     : Admin
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Car" %>
<%@ page import="dao.CarDAO" %>
<%
    Car car = (Car) request.getAttribute("car");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mô tả sản phẩm - Velyra Aero</title>
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
                        <li><a href="ThemSanPhamServlet">Quản lý Xe / Thêm</a></li>
                        <li><a href="BrandServlet">Quản lý Hãng xe</a></li>
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


        <% if (car != null) {%>
        <div class="product-container">
            <div class="product-images">
                <div class="product-images">
                    <div class="main-image">
                        <img src="${pageContext.request.contextPath}/uploads/${car.mainImageURL}" alt="Ảnh chính" style="width:100%; height:auto;">
                    </div>

                    <!-- ẢNH MÔ TẢ / ẢNH PHỤ -->
                    <div class="thumbs">
                        <c:forEach var="thumb" items="${car.thumbs}">
                            <img 
                                src="${pageContext.request.contextPath}/uploads/${thumb}" 
                                alt="Ảnh mô tả" 
                                class="thumb-image"
                                style="width:100px; height:auto; margin:5px; cursor:pointer; transition: transform .15s;"
                                onclick="swapImage(this)">
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="product-details">
                <h1><%= car.getCarName()%></h1>

                <div class="price">
                    Giá: <%= String.format("%,.0f", car.getPrice())%>đ
                </div>

                <div class="color-options">
                    <span class="color-label">MÀU SẮC:</span>
                    <div class="color-swatch"
                         style="background-color:<%= car.getColor() != null ? car.getColor() : "#ccc"%>;
                         width:20px;height:20px;border-radius:50%;display:inline-block;">
                    </div>
                </div>

                <div class="quantity-selector">
                    <span class="quantity-label">SỐ LƯỢNG:</span>
                    <input type="number" id="quantity" value="1" min="1" max="<%= car.getQuantity()%>">
                    <span>(Còn <%= car.getQuantity()%> sản phẩm)</span>
                </div>

                <div class="action-buttons">
                    <button class="buy-now">MUA NGAY</button>
                    <button class="add-to-cart">THÊM VÀO GIỎ HÀNG</button>
                </div>
            </div>
        </div>

        <div class="product-description">
            <h2>MÔ TẢ SẢN PHẨM</h2>
            <p><%= car.getDescription()%></p>
        </div>
        <% } else { %>
        <h2 style="text-align:center; color:red;">Không tìm thấy sản phẩm!</h2>
        <% }%>

        <script>
            function getQuantityInput() {
                return document.getElementById('quantity');
            }

            function incrementQuantity() {
                let input = getQuantityInput();
                let currentValue = parseInt(input.value);
                let maxValue = parseInt(input.max);
                if (currentValue < maxValue) {
                    input.value = currentValue + 1;
                }
            }

            function decrementQuantity() {
                let input = getQuantityInput();
                let currentValue = parseInt(input.value);
                let minValue = parseInt(input.min);
                if (currentValue > minValue) {
                    input.value = currentValue - 1;
                }
            }

            function swapImage(thumbEl) {
                const mainImg = document.querySelector('.main-image img');
                if (!mainImg || !thumbEl)
                    return;

                // swap src
                const tmp = mainImg.src;
                mainImg.src = thumbEl.src;
                thumbEl.src = tmp;

                // (tùy) thêm hiệu ứng ngắn khi đổi ảnh
                mainImg.style.opacity = 0;
                setTimeout(() => mainImg.style.opacity = 1, 60);
            }
        </script>


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
