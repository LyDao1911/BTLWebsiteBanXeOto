<%-- 
    Document   : themsanpham
    Created on : Oct 18, 2025, 7:08:23 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
        <h3 class="title">Sửa sản phẩm</h3> 
        <div class="container">


            <form action="SuaXeServlet" method="post" enctype="multipart/form-data">

                <input type="hidden" name="carId" value="${car.carID}">
                <input type="hidden" name="status" value="${car.status}"> 
                <div class="top"> 

                    <div class="left">
                        <!-- Ảnh chính hiện tại -->
                        <label class="label">Ảnh chính hiện tại</label>
                        <div class="product-image">
                            <div class="main-placeholder">
                                <img id="t1"
                                     src="${pageContext.request.contextPath}/uploads/${car.mainImageURL}"
                                     alt="Ảnh chính" width="200">
                                <!-- Ảnh cũ -->
                                <input type="hidden" name="oldImage" value="${car.mainImageURL}">
                            </div>
                        </div>

                        <!-- Ảnh chính mới -->
                        <label class="label">Ảnh chính (Thay thế)</label>
                        <input type="file" name="mainImage" accept="image/*" onchange="previewMain(event)">

                        <!-- Ảnh mô tả hiện tại -->
                        <label class="label">Ảnh mô tả hiện tại</label>
                        <div class="thumbs-preview">
                            <c:forEach var="thumb" items="${car.thumbs}">
                                <input type="hidden" name="oldThumbs" value="${thumb}">
                                <img src="${pageContext.request.contextPath}/uploads/${thumb}"
                                     alt="Ảnh mô tả"
                                     width="90" height="60"
                                     style="margin:5px; border:1px solid #ccc;">
                            </c:forEach>
                        </div>

                        <!-- Ảnh mô tả thay thế -->
                        <label class="label">Ảnh mô tả (Thay thế)</label>
                        <input type="file" name="thumbs" multiple accept="image/*" onchange="previewThumbs(event)">
                    </div>
                    <div class="right"><br> 
                        <label class="label">Thương hiệu</label>
                        <select name="brandID" class="input" required>
                            <option value="">-- Chọn thương hiệu --</option>
                            <c:forEach var="brand" items="${brandList}">
                                <option value="${brand.brandID}"
                                        ${brand.brandID == car.brandID ? 'selected' : ''}>
                                    ${brand.brandName}
                                </option>
                            </c:forEach>
                        </select>

                        </select> <label class="label">Tên sản phẩm</label>
                        <input class="input" type="text" name="carName" placeholder="Tên sản phẩm" value="${car.carName}">
                        <label class="label">Giá</label>
                        <input class="input" type="text" name="price" id="price" value="${car.price}">
                        <label class="label">Màu sắc</label> <div class="color-palette">
                            <label class="color-item"> 
                                <input type="radio" name="color" value="Red" ${car.color == 'Red' ? 'checked' : ''}>
                                <span style="background:#b30b0b;"></span>
                            </label> <label class="color-item"> 
                                <input type="radio" name="color" value="Yellow" ${car.color == 'Yellow' ? 'checked' : ''}>
                                <span style="background:#ffd966;"></span> 
                            </label> 
                            <label class="color-item"> 
                                <input type="radio" name="color" value="Pink" ${car.color == 'Pink' ? 'checked' : ''}>
                                <span style="background:#ff8ad9;"></span> 
                            </label>
                            <label class="color-item"> 
                                <input type="radio" name="color" value="Blue" ${car.color == 'Blue' ? 'checked' : ''}> 
                                <span style="background:#00c1d4;"></span>
                            </label> 
                            <label class="color-item"> 
                                <input type="radio" name="color" value="Green" ${car.color == 'Green' ? 'checked' : ''}> 
                                <span style="background:#2a7f2a;"></span>
                            </label> 
                            <label class="color-item"> 
                                <input type="radio" name="color" value="Brown" ${car.color == 'Brown' ? 'checked' : ''}>
                                <span style="background:#d2691e;"></span>
                            </label> 
                        </div><br><br> 
                        <label class="label">Số lượng</label>
                        <div class="qty">
                            <button type="button" onclick="changeQty(-1)">-</button>
                            <input type="number" id="quantity" name="quantity" value="${car.quantity}" min="0"> 
                            <button type="button" onclick="changeQty(1)">+</button>
                        </div> 
                        <label class="label">Mô tả sản phẩm</label> 
                        <textarea name="description" rows="5">${car.description}</textarea>
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
