<%-- 
    Document   : mota
    Created on : Oct 19, 2025, 2:39:14 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm sản phẩm - Velyra Aero</title>
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


        <!-- 🔍 MÔ TẢ SẢN PHẨM -->
        <div class="product-container">
            <div class="product-images">
                <div class="main-image">
                    <img src="path/to/image_579e02_main.png" alt="VinFast Lux A2.0 Main Image">
                </div>
                <div class="thumbnail-images">
                    <img src="path/to/image_579e02_thumb1.png" alt="Thumbnail 1">
                    <img src="path/to/image_579e02_thumb2.png" alt="Thumbnail 2">
                    <img src="path/to/image_579e02_thumb3.png" alt="Thumbnail 3">
                </div>
            </div>

            <div class="product-details">
                <h1>VinFast Lux A2.0</h1>
                <div class="price">
                    Giá: 981.695.000đ
                </div>

                <div class="color-options">
                    <span class="color-label">MÀU SẮC:</span>
                    <div class="color-swatch swatch-red" title="Đỏ"></div>

                </div>

                <div class="quantity-selector">
                    <span class="quantity-label">SỐ LƯỢNG:</span>
                    <div style="display: flex; align-items: center;"> <div class="quantity-control">
                            <button onclick="decrementQuantity()">-</button>
                            <input type="number" id="quantity" value="1" min="1" >
                            <button onclick="incrementQuantity()">+</button>
                        </div>
                        <span class="quantity-stock"> (Còn 200)</span> 
                    </div>
                </div>
                <div class="action-buttons">
                    <button class="buy-now">MUA NGAY</button>
                    <button class="add-to-cart">THÊM VÀO GIỎ HÀNG</button>
                </div>
            </div>
        </div>

        <div class="product-description">
            <h2>MÔ TẢ SẢN PHẨM</h2>
            <ul>
                <li>[CÓ SẴN] Len nhung đũa mềm mại, đủ màu cuộn dao động từ 92-100gr tuỳ cuộn</li>
                <li>- Kích thước sợi: 6mm</li>
                <li>- Kim móc: 6mm-10mm</li>
                <li>- Kim đan:6 mm - 10 mm</li>
                <li>- Trọng lượng cuộn: 100gam</li>
                <li>- Len Móc Thú bông, thảm, khăn....</li>
                <li>- Len nhung đũa phù hợp móc khăn, gấu, túi, ....</li>
                <li>- Sợi len trơn, mềm rất dễ móc, đan không đau tay. Thích hợp cho cả những người mới tập móc.</li>
                <li>- ...</li>
            </ul>
        </div>

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
