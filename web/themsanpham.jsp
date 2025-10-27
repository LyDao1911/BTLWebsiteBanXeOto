<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 
    Document   : themsanpham
    Created on : Oct 18, 2025, 7:08:23 PM
    Author     : Admin
--%>


<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>



<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm sản phẩm - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>

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
                <div class="admin-menu account-menu">
                    <span class="admin-name account-name">
                        Quản trị <i class="fa-solid fa-caret-down"></i>
                    </span>
                    <ul class="dropdown">

                        <%-- SỬA 2: SỬA LINK NÀY ĐỂ LOAD BRAND --%>
                        <li><a href="ThemSanPhamServlet">Quản lý Xe / Thêm</a></li>

                        <li><a href="BrandServlet">Quản lý Hãng xe</a></li>
                        <li><a href="SanPhamServlet">Quản lý Xe</a></li>
                    </ul>
                </div>

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
                        <li><a href="ProfileServlet">Thông tin cá nhân</a></li>
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

        <div class="container">
            <h2 class="title">Thêm sản phẩm</h2>

            <form action="ThemSanPhamServlet" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
                <div class="top">
                    <div class="left">
                        <div class="product-image">
                            <img id="mainPreview" src="https://via.placeholder.com/500x300.png?text=Main+Image" alt="Ảnh chính">
                        </div>

                        <div class="thumbs">
                            <div class="thumb"><img id="t1" src="https://via.placeholder.com/90x60.png" alt=""></div>
                            <div class="thumb"><img id="t2" src="https://via.placeholder.com/90x60.png" alt=""></div>
                            <div class="thumb"><img id="t3" src="https://via.placeholder.com/90x60.png" alt=""></div>
                        </div>

                        <label class="label">Ảnh chính</label>
                        <%-- name="mainImage" khớp với Servlet --%>
                        <input type="file" name="mainImage" accept="image/*" onchange="previewMain(event)">

                        <label class="label">Ảnh mô tả (Chọn tối đa 3 ảnh)</label>
                        <input type="file" name="thumbs" multiple accept="image/*" onchange="previewThumbs(event)">
                    </div>

                    <div class="right"><br><br>
                        <label class="label">Thương hiệu</label>


                        <select name="brandID" class="input" required>
                            <option value="">-- Chọn thương hiệu --</option>

                            <c:forEach var="brand" items="${brandList}">
                                <option value="${brand.brandID}">${brand.brandName}</option>
                            </c:forEach>

                        </select><br><br>

                        <label class="label">Tên sản phẩm</label>
                        <input class="input" type="text" name="carName" placeholder="Tên sản phẩm" required>

                        <label class="label">Giá</label>
                        <input class="input" type="text" name="price" id="price" placeholder="981.695.000" required><br><br>

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
                            <%-- Nhớ thêm id/for nếu thêm màu mới --%>
                        </div><br><br>

                        <label class="label">Số lượng</label>
                        <div class="qty">
                            <button type="button" onclick="changeQty(-1)">-</button>
                            <%-- name="quantity" khớp Servlet (khớp Model CarStock.java) --%>
                            <input type="number" id="quantity" name="quantity" value="1" min="0" style="width:70px; text-align:center;">
                            <button type="button" onclick="changeQty(1)">+</button>
                        </div>

                        <label class="label">Mô tả sản phẩm</label>
                        <%-- name="description" khớp Servlet (khớp Model Car.java) --%>
                        <textarea name="description" rows="5" placeholder="Nhập mô tả chi tiết..."></textarea><br><br>

                        <button type="submit" class="btn-submit">THÊM SẢN PHẨM</button>
                    </div>
                </div>
            </form>
        </div>

        <script>
            // ✅ Preview ảnh chính
            function previewMain(evt) {
                const [file] = evt.target.files;
                if (file) {
                    document.getElementById('mainPreview').src = URL.createObjectURL(file);
                }
            }

            // SỬA: Hàm previewThumbs mới để xử lý "multiple"
            function previewThumbs(evt) {
                const files = evt.target.files; // Lấy danh sách các file đã chọn
                const thumbIds = ['t1', 't2', 't3']; // ID của 3 ô ảnh preview

                for (let i = 0; i < thumbIds.length; i++) {
                    const imgElement = document.getElementById(thumbIds[i]);
                    if (files[i]) {
                        // Nếu có file thứ i, hiển thị nó
                        imgElement.src = URL.createObjectURL(files[i]);
                    } else {
                        // Nếu không có file thứ i (chọn ít hơn 3 ảnh), hiển thị ảnh placeholder
                        imgElement.src = 'https://via.placeholder.com/90x60.png';
                    }
                }
            }

            // ✅ Tăng giảm số lượng
            function changeQty(delta) {
                const input = document.getElementById('quantity');
                let val = parseInt(input.value) || 0;
                val += delta;
                if (val < 0)
                    val = 0;
                input.value = val;
            }

            // ✅ Check màu

            document.querySelectorAll('.color-item').forEach(item => {
                item.addEventListener('click', () => {
                    // 1. Xóa class 'selected' khỏi tất cả các ô khác
                    document.querySelectorAll('.color-item').forEach(otherItem => {
                        otherItem.classList.remove('selected');
                    });

                    const input = item.querySelector('input[type="radio"]');

                    // 2. Tự động click vào input radio để nó được chọn
                    input.checked = true;

                    // 3. Thêm class 'selected' cho ô đang được chọn
                    item.classList.add('selected');
                });
            });

            // ✅ Format giá
            document.getElementById('price').addEventListener('input', (e) => {
                let value = e.target.value.replace(/\D/g, '');
                e.target.value = value.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
            });
        </script>

        <footer class="footer">
            ...
        </footer>

    </body>
</html>