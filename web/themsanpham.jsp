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
        <title>Thêm sản phẩm - Velyra Aero</title>
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
                <a href="dangnhap.jsp">Đăng nhập</a>
                <a href="dangky.jsp">Đăng ký</a>
            </nav>
            <%
                // Chỉ hiện khi đã đăng nhập là admin
                if (session.getAttribute("user") != null && session.getAttribute("role").equals("admin")) {
            %>
            <li><a href="themsanpham.jsp">Thêm sản phẩm</a></li>
                <%
                    }
                %>
        </ul>
    </nav> 
</header>

<!-- 📝 FORM THÊM SẢN PHẨM -->
<div class="container">
    <h2 class="title">Thêm sản phẩm</h2>

    <form action="ThemSanPhamServlet" method="post" enctype="multipart/form-data">
        <div class="top">
            <!-- BÊN TRÁI -->
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
                <input type="file" name="mainImage" accept="image/*" onchange="previewMain(event)">

                <label class="label">Ảnh mô tả</label>
                <input type="file" name="thumbs" multiple accept="image/*" onchange="previewThumbs(event)">
            </div>

            <!-- BÊN PHẢI -->
            <div class="right"><br><br>
                <label class="label">Thương hiệu</label>
                <select name="brand" class="input">
                    <option value="">-- Chọn thương hiệu --</option>
                    <option value="Toyota">Toyota</option>
                    <option value="Honda">Honda</option>
                    <option value="BMW">BMW</option>
                    <option value="Mercedes">Mercedes</option>
                    <option value="VinFast">VinFast</option>
                </select><br><br>

                <label class="label">Tên sản phẩm</label>
                <input class="input" type="text" name="name" placeholder="Tên sản phẩm">

                <label class="label">Giá</label>
                <input class="input" type="text" name="price" id="price" placeholder="981.695.000"><br><br>

                <label class="label">Màu sắc</label>
                <div class="color-palette">
                    <label class="color-item" style="background:#b30b0b;"><input type="checkbox" name="color" value="#b30b0b"></label>
                    <label class="color-item" style="background:#ffd966;"><input type="checkbox" name="color" value="#ffd966"></label>
                    <label class="color-item" style="background:#ff8ad9;"><input type="checkbox" name="color" value="#ff8ad9"></label>
                    <label class="color-item" style="background:#00c1d4;"><input type="checkbox" name="color" value="#00c1d4"></label>
                    <label class="color-item" style="background:#2a7f2a;"><input type="checkbox" name="color" value="#2a7f2a"></label>
                    <label class="color-item" style="background:#d2691e;"><input type="checkbox" name="color" value="#d2691e"></label>
                </div><br><br>

                <label class="label">Số lượng</label>
                <div class="qty">
                    <button type="button" onclick="changeQty(-1)">-</button>
                    <input type="number" id="quantity" name="quantity" value="1" min="0" style="width:70px; text-align:center;">
                    <button type="button" onclick="changeQty(1)">+</button>
                </div>

                <label class="label">Mô tả sản phẩm</label>
                <textarea name="description" rows="5" placeholder="Nhập mô tả chi tiết..."></textarea><br><br>

                <button type="submit" class="btn-submit">THÊM SẢN PHẨM</button>
            </div>
        </div>
    </form>
</div>

<!-- 📜 SCRIPT -->
<script>
    // ✅ Preview ảnh chính
    function previewMain(evt) {
        const [file] = evt.target.files;
        if (file) {
            document.getElementById('mainPreview').src = URL.createObjectURL(file);
        }
    }

    // ✅ Preview ảnh phụ
    function previewThumbs(evt) {
        const files = evt.target.files;
        for (let i = 0; i < 3; i++) {
            const el = document.getElementById('t' + (i + 1));
            if (files[i]) {
                el.src = URL.createObjectURL(files[i]);
            } else {
                el.src = 'https://via.placeholder.com/90x60.png';
            }
        }
    }

    // ✅ Tăng giảm số lượng
    function changeQty(delta) {
        const input = document.getElementById('quantity');
        let val = parseInt(input.value) || 0;
        val += delta;
        if (val < 0) val = 0;
        input.value = val;
    }

    // ✅ Check màu
    document.querySelectorAll('.color-item').forEach(item => {
        item.addEventListener('click', () => {
            const input = item.querySelector('input');
            input.checked = !input.checked;
            item.classList.toggle('selected', input.checked);
        });
    });

    // ✅ Format giá
    document.getElementById('price').addEventListener('input', (e) => {
        let value = e.target.value.replace(/\D/g, '');
        e.target.value = value.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
    });
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
