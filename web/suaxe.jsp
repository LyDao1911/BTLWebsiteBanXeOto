<%-- 
    Document   : themsanpham
    Created on : Oct 18, 2025, 7:08:23 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
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
    /* ✅ Palette màu sắc */
    .color-palette {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
        margin-top: 5px;
    }

    .color-item {
        display: flex;
        align-items: center;
        gap: 5px;
        cursor: pointer;
        padding: 5px;
        border-radius: 5px;
        transition: all 0.3s ease;
    }

    .color-item:hover {
        background: #f0f0f0;
    }

    .color-item.selected {
        background: #e0e0e0;
        border: 1px solid #d60000;
    }

    .color-item input[type="radio"] {
        display: none; /* Ẩn radio button gốc */
    }

    .color-item span {
        display: inline-block;
        width: 30px;
        height: 30px;
        border-radius: 50%;
        border: 2px solid #ddd;
        transition: all 0.3s ease;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    /* Hiệu ứng khi được chọn */
    .color-item input[type="radio"]:checked + span {
        border: 2px solid #d60000;
        transform: scale(1.1);
        box-shadow: 0 0 8px rgba(214, 0, 0, 0.5);
    }

    /* Màu sắc cụ thể */
    .color-item span[style*="background:#b30b0b"] {
        background: #b30b0b;
    } /* Red */
    .color-item span[style*="background:#ffd966"] {
        background: #ffd966;
    } /* Yellow */
    .color-item span[style*="background:#ff8ad9"] {
        background: #ff8ad9;
    } /* Pink */
    .color-item span[style*="background:#00c1d4"] {
        background: #00c1d4;
    } /* Blue */
    .color-item span[style*="background:#2a7f2a"] {
        background: #2a7f2a;
    } /* Green */
    .color-item span[style*="background:#d2691e"] {
        background: #d2691e;
    } /* Brown */
.color-name {
    font-size: 12px;
    color: #333;
    font-weight: 500;
}
</style>
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

        <jsp:include page="header.jsp" />
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
                            <%-- Ẩn nút tăng giảm và để input disabled --%>
                            <input type="number" id="quantity" name="quantity" value="0" min="0" 
                                   style="width:70px; text-align:center;" disabled>
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


        <jsp:include page="footer.jsp" />

    </body>
</html>
