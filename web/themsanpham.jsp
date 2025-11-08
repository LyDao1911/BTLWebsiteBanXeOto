<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 
    Document   : themsanpham
    Created on : Oct 18, 2025, 7:08:23 PM
    Author     : Admin
--%>


<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
/* 📝 FORM THÊM SẢN PHẨM */
.container {
    max-width: 1200px;
    margin: 100px auto 60px; /* ✅ cách top 100px để không bị dính header */
    padding: 30px 40px;      /* ✅ tạo khoảng cách hai bên */
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 4px 25px rgba(0, 0, 0, 0.15);
}

.title {
    text-align: center;
    margin-bottom: 30px;
    color: #d60000;
    font-size: 26px;
    font-weight: bold;
}

.top {
    display: flex;
    gap: 50px;
    flex-wrap: wrap;
}

.left {
    flex: 1;
    min-width: 350px;
}

.right {
    flex: 1;
    min-width: 350px;
}

/* ✅ Ảnh chính */
.product-image img {
    width: 100%;
    max-width: 500px;
    height: auto;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 15px;
}

/* ✅ Ảnh mô tả */
.thumbs {
    display: flex;
    gap: 10px;
    margin-bottom: 15px;
}

.thumbs img {
    width: 90px;
    height: 60px;
    object-fit: cover;
    border: 1px solid #ccc;
    border-radius: 4px;
}

/* ✅ Input và Label */
.label {
    display: block;
    margin-top: 10px;
    font-weight: bold;
    font-size: 14px;
    color: #333;
}

.input, textarea, select {
    width: 100%;
    padding: 10px 12px;
    margin-top: 5px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 14px;
}

textarea {
    resize: none;
}

.qty {
    display: flex;
    align-items: center;
    gap: 5px;
    margin-top: 5px;
}

.qty button {
    padding: 5px 10px;
    background: #d60000;
    color: #fff;
    border: none;
    cursor: pointer;
    font-size: 18px;
    border-radius: 5px;
}

.qty button:hover {
    background: #a00000;
}

/* ✅ Nút submit */
.btn-submit {
    display: block;
    margin-top: 20px;
    background: #d60000;
    color: #fff;
    padding: 12px;
    border: none;
    width: 100%;
    font-size: 16px;
    border-radius: 8px;
    cursor: pointer;
    transition: background 0.3s ease;
}

.btn-submit:hover {
    background: #a00000;
}


</style>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm sản phẩm - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>

      <jsp:include page="header.jsp" />

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
                        <input type="file" name="mainImage" accept="uploads/*" onchange="previewMain(event)">

                        <label class="label">Ảnh mô tả (Chọn tối đa 3 ảnh)</label>
                        <input type="file" name="thumbs" multiple accept="uploads/*" onchange="previewThumbs(event)">
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

        <jsp:include page="footer.jsp" />

    </body>
</html>