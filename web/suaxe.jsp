<%-- 
    Document   : themsanpham
    Created on : Oct 18, 2025, 7:08:23 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sửa sản phẩm - Velyra Aero</title>
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
        <h3 class="title">Sửa sản phẩm</h3> 
        <div class="container">


            <form action="SuaSanPhamServlet" method="post" enctype="multipart/form-data">

                <input type="hidden" name="carId" value="[CarID]">

                <div class="top">
                    <div class="left">
                        <label class="label">Ảnh hiện tại</label>
                        <div class="product-image">
                            <div class="main-placeholder"><img id="t1" src="https://via.placeholder.com/90x60.png?text=Ảnh+Chính+Cũ" alt="Ảnh chính"></div>
                            <div class="main-placeholder"><img id="t2" src="https://via.placeholder.com/90x60.png?text=T2" alt="Ảnh phụ 1"></div>
                            <div class="main-placeholder"><img id="t3" src="https://via.placeholder.com/90x60.png?text=T3" alt="Ảnh phụ 2"></div>
                            <div class="main-placeholder"><img id="t4" src="https://via.placeholder.com/90x60.png?text=T4" alt="Ảnh phụ 3"></div>

                        </div>

                        <label class="label">Ảnh chính (Thay thế)</label>
                        <input type="file" name="mainImage" accept="image/*" onchange="previewMain(event)">

                        <label class="label">Ảnh mô tả (Thay thế)</label>
                        <input type="file" name="thumbs" multiple accept="image/*" onchange="previewThumbs(event)">
                    </div>

                    <div class="right"><br>
                        <label class="label">Thương hiệu</label>
                        <select name="brand" class="input">
                            <option value="">-- Chọn thương hiệu --</option>
                            <option value="Toyota">Toyota</option>
                            <option value="Honda">Honda</option>
                            <option value="BMW">BMW</option>
                            <option value="Mercedes">Mercedes</option>
                            <option value="VinFast" selected>VinFast (Mặc định)</option>
                        </select>

                        <label class="label">Tên sản phẩm</label>
                        <input class="input" type="text" name="name" placeholder="Tên sản phẩm" value="Tên sản phẩm cũ">

                        <label class="label">Giá</label>
                        <input class="input" type="text" name="price" id="price" placeholder="981.695.000" value="981.695.000">

                        <label class="label">Màu sắc</label>
                        <div class="color-palette">
                            <label class="color-item" for="color_red"> <%-- Thêm for --%>
                                <input type="radio" name="color" value="Red" id="color_red"> <%-- Thêm id --%>
                                <span style="background:#b30b0b;"></span>
                            </label>
                            <label class="color-item" for="color_yellow"> <%-- Thêm for --%>
                                <input type="radio" name="color" value="Yellow" id="color_yellow"> <%-- Thêm id --%>
                                <span style="background:#ffd966;"></span>
                            </label>
                            <label class="color-item" for="color_pink"> <%-- Thêm for --%>
                                <input type="radio" name="color" value="Pink" id="color_pink"> <%-- Thêm id --%>
                                <span style="background:#ff8ad9;"></span>
                            </label>
                            <label class="color-item" for="color_blue"> <%-- Thêm for --%>
                                <input type="radio" name="color" value="Blue" id="color_blue"> <%-- Thêm id --%>
                                <span style="background:#00c1d4;"></span>
                            </label>
                            <label class="color-item" for="color_green"> <%-- Thêm for --%>
                                <input type="radio" name="color" value="Green" id="color_green"> <%-- Thêm id --%>
                                <span style="background:#2a7f2a;"></span>
                            </label>
                            <label class="color-item" for="color_brown"> <%-- Thêm for --%>
                                <input type="radio" name="color" value="Brown" id="color_brown"> <%-- Thêm id --%>
                                <span style="background:#d2691e;"></span>
                            </label>
                        </div><br><br>
                        <label class="label">Số lượng</label>
                        <div class="qty">
                            <button type="button" onclick="changeQty(-1)">-</button>
                            <input type="number" id="quantity" name="quantity" value="10" min="0">
                            <button type="button" onclick="changeQty(1)">+</button>
                        </div>

                        <label class="label">Mô tả sản phẩm</label>
                        <textarea name="description" rows="5" placeholder="Nhập mô tả chi tiết...">Đây là mô tả chi tiết cũ của sản phẩm...</textarea>

                        <button type="submit" class="btn-submit">CẬP NHẬT SẢN PHẨM</button>
                    </div>
                </div>
            </form>
        </div>

        <script>
            // Hàm Preview Ảnh chính
            function previewMain(evt) {
                const [file] = evt.target.files;
                const el = document.getElementById('t1');
                if (file) {
                    el.src = URL.createObjectURL(file);
                    el.style.display = 'block';
                }
            }

            // Hàm Preview Ảnh phụ
            function previewThumbs(evt) {
                const files = evt.target.files;

                // Bắt đầu từ ô thứ 2 (t2, t3)
                for (let i = 0; i < 3; i++) {
                    const el = document.getElementById('t' + (i + 2));
                    if (files[i]) {
                        el.src = URL.createObjectURL(files[i]);
                    } else {
                        // Nếu không có file mới, đặt lại ảnh placeholder
                        el.src = 'https://via.placeholder.com/90x60.png';
                    }
                }
            }

            // Hàm Tăng/Giảm Số lượng 
            function changeQty(delta) {
                const input = document.getElementById('quantity');
                let val = parseInt(input.value) || 0;
                val += delta;
                if (val < 0)
                    val = 0;
                input.value = val;
            }

            // Xử lý Checkbox màu và Format giá khi trang tải
            window.onload = function () {

                // Gán sự kiện click cho việc chọn/bỏ chọn màu
                document.querySelectorAll('.color-item').forEach(item => {
                    const input = item.querySelector('input');
                    item.addEventListener('click', (e) => {
                        if (e.target !== input) {
                            input.checked = !input.checked;
                        }
                        item.classList.toggle('selected', input.checked);
                    });
                });

                // Hàm format giá 
                document.getElementById('price').addEventListener('input', (e) => {
                    let value = e.target.value.replace(/\D/g, '');
                    e.target.value = value.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
                });
            };
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
