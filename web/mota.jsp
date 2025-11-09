<%@page import="model.Car" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% Car car = (Car) request.getAttribute("car");%> 
<style>
    /* Tổng khung chứa ảnh và thông tin */
    .product-container {
        display: flex;
        flex-wrap: wrap;
        gap: 40px;
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    }

    /* Khung ảnh bên trái */
    .product-images {
        flex: 1;
        min-width: 400px;
    }

    /* Ảnh chính */
    .main-image {
        position: relative;
        overflow: hidden;
        border-radius: 10px;
        background: #f8f9fa;
        padding: 15px;
    }

    .main-image img {
        width: 100%;
        height: 400px;
        object-fit: contain;
        border-radius: 8px;
        transition: transform 0.3s ease;
    }

    .main-image:hover img {
        transform: scale(1.02);
    }

    /* Ảnh mô tả nhỏ - CHỈNH SỬA QUAN TRỌNG */
    .thumbs {
        display: flex;
        flex-wrap: nowrap; /* Không xuống dòng */
        justify-content: space-between; /* Chia đều khoảng cách */
        gap: 10px;
        margin-top: 20px;
        width: 100%; /* Bằng chiều rộng ảnh chính */
    }

    .thumbs img {
        flex: 1; /* Mỗi ảnh chiếm không gian bằng nhau */
        min-width: 0; /* Quan trọng để flex hoạt động */
        height: 80px; /* Tăng chiều cao cho cân đối */
        object-fit: cover;
        border-radius: 6px;
        border: 2px solid #e0e0e0;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .thumbs img:hover {
        transform: translateY(-2px);
        border-color: #333;
    }

    /* Thông tin sản phẩm */
    .product-details {
        flex: 1;
        min-width: 400px;
        padding: 10px;
    }

    /* Tiêu đề sản phẩm */
    .product-details h1 {
        font-size: 28px;
        margin-bottom: 15px;
        color: #333;
        font-weight: 600;
        line-height: 1.3;
    }

    /* Giá */
    .product-details .price {
        font-size: 24px;
        color: #333;
        font-weight: 600;
        margin: 20px 0;
        padding: 15px 0;
        border-bottom: 1px solid #eee;
    }

    /* Màu sắc */
   

    .color-label {
        font-weight: 500;
        color: #333;
        margin-right: 10px;
        font-size: 14px;
    }

    .color-swatch {
        width: 25px;
        height: 25px;
        border-radius: 50%;
        display: inline-block;
        border: 2px solid #fff;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
        vertical-align: middle;
    }

    /* Số lượng */
   

    .quantity-label {
        font-weight: 500;
        color: #000000;
        margin-right: 15px;
        font-size: 14px;
    }

    .quantity-controls {
        display: inline-flex;
        align-items: center;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 6px;
        overflow: hidden;
        margin-right: 10px;
    }

    .quantity-selector button {
        width: 35px;
        height: 35px;
        border: none;
        background: #f8f9fa;
        color: #333;
        font-size: 16px;
        cursor: pointer;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .quantity-selector button:hover {
        background: #e9ecef;
    }

    .quantity-selector input {
        width: 50px;
        height: 35px;
        text-align: center;
        border: none;
        border-left: 1px solid #ddd;
        border-right: 1px solid #ddd;
        font-size: 14px;
        font-weight: 500;
        background: #fff;
    }

    .quantity-selector span {
        color: #000000;
        font-size: 13px;
    }
    /* Nút hành động */
    .action-buttons {
        display: flex;
        gap: 15px;
        margin-top: 25px;
    }

    .action-buttons button {
        flex: 1;
        padding: 16px 20px;
        font-weight: 600;
        font-size: 15px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    /* Nút MUA NGAY - ombre đỏ đen */
    .action-buttons .buy-now {
        background: linear-gradient(135deg, #ff0000 0%, #8b0000 50%, #000000 100%);
        color: #fff;
       
    }


    .action-buttons .buy-now:hover::before {
        left: 100%;
    }

    /* Nút THÊM VÀO GIỎ - đơn giản tinh tế */
    .action-buttons .add-to-cart {
        background:#777
            color: black;

    }

    .action-buttons .add-to-cart:hover {
        background: #777;
        transform: translateY(-2px);
    }

    /* Phần mô tả sản phẩm */
    .product-description {
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
        background: #ffffff;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        border-radius: 12px;
    }

    .product-description h2 {
        font-size: 20px;
        font-weight: 600;
        border-bottom: 2px solid #eee;
        padding-bottom: 12px;
        margin-bottom: 20px;
        color: #333;
    }

    .product-description p {
        line-height: 1.7;
        font-size: 15px;
        color: #555;
        text-align: justify;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .product-container {
            flex-direction: column;
            gap: 25px;
            margin: 20px;
            padding: 20px;
        }

        .product-images,
        .product-details {
            min-width: 100%;
        }

        .main-image img {
            height: 300px;
        }

        .thumbs {
            flex-wrap: wrap; /* Trên mobile cho phép xuống dòng */
        }

        .thumbs img {
            flex: 0 0 calc(33.333% - 10px); /* 3 ảnh trên 1 hàng */
            height: 70px;
        }

        .action-buttons {
            flex-direction: column;
        }

        .product-details h1 {
            font-size: 22px;
        }

        .product-details .price {
            font-size: 20px;
        }
    }
</style>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mô tả sản phẩm - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>

        <jsp:include page="header.jsp" />

        <c:if test="${not empty car}"> 
            <div class="product-container">
                <div class="product-images">
                    <div class="product-images">
                        <div class="main-image">
                            <img src="${pageContext.request.contextPath}/uploads/${car.mainImageURL}" alt="Ảnh chính" style="width:100%; height:auto;">
                        </div>

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
                    <h1>${car.carName}</h1> 

                    <div class="price">
                        Giá: <fmt:formatNumber value="${car.price}" pattern="#,##0"/>đ 
                    </div>

                    <div class="color-options">
                        <span class="color-label">MÀU SẮC:</span>
                        <div class="color-swatch"
                             style="background-color:${car.color != null ? car.color : "#ccc"};
                             width:20px;height:20px;border-radius:50%;display:inline-block;">
                        </div>
                    </div>
                             <br><br>
                    <div class="quantity-selector">
                        <span class="quantity-label">SỐ LƯỢNG:</span>
                        <div class="quantity-controls">
                            <button type="button" onclick="decrementQuantity()">-</button>
                            <input type="number" id="quantity" value="1" min="1" max="${car.quantity}">
                            <button type="button" onclick="incrementQuantity()">+</button>
                        </div>
                        <span>(Còn ${car.quantity} sản phẩm)</span> 
                    </div>

                    <form id="cartForm" method="post" action="${pageContext.request.contextPath}/GioHangServlet">
                        <input type="hidden" name="carID" value="${car.carID}"> 
                        <input type="hidden" name="quantity" id="hiddenQuantity" value="1">

                        <div class="action-buttons">
                            <button type="button" class="buy-now" onclick="muaNgay()">MUA NGAY</button>
                            <button type="button" class="add-to-cart" onclick="themGioHang()">THÊM VÀO GIỎ HÀNG</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="product-description">
                <h2>MÔ TẢ SẢN PHẨM</h2>
                <p>${car.description}</p> 
            </div>
        </c:if>

        <c:if test="${empty car}">
            <h2 style="text-align:center; color:red;">Không tìm thấy sản phẩm!</h2>
        </c:if>

        <script>
            // Các hàm tăng giảm số lượng giữ nguyên
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

                const tmp = mainImg.src;
                mainImg.src = thumbEl.src;
                thumbEl.src = tmp;

                mainImg.style.opacity = 0;
                setTimeout(() => mainImg.style.opacity = 1, 60);
            }

            // ⭐⭐⭐ HÀM MUA NGAY GIỮ NGUYÊN (Không dùng AJAX) ⭐⭐⭐
            function muaNgay() {
                const quantityInput = document.getElementById('quantity');
                let qty = parseInt(quantityInput.value);
                let maxQty = parseInt(quantityInput.max);

                if (qty > maxQty) {
                    alert('Số lượng tối đa có thể mua là ' + maxQty);
                    qty = maxQty;
                }
                if (qty < 1) {
                    qty = 1;
                }

                const carID = document.querySelector('input[name="carID"]').value;
                window.location.href = '${pageContext.request.contextPath}/DatHangServlet?carID=' + carID + '&quantity=' + qty;
            }


            // ⭐⭐⭐ HÀM THÊM GIỎ HÀNG DÙNG AJAX (ĐÃ SỬA) ⭐⭐⭐
            async function themGioHang() {
                const quantityInput = document.getElementById('quantity');
                const hiddenQuantityInput = document.getElementById('hiddenQuantity');
                const form = document.getElementById('cartForm');

                if (!form)
                    return;

                // 1. Kiểm tra và lấy số lượng
                let qty = parseInt(quantityInput.value);
                let maxQty = parseInt(quantityInput.max);

                if (qty > maxQty) {
                    alert('Số lượng tối đa có thể mua là ' + maxQty);
                    qty = maxQty;
                    quantityInput.value = maxQty;
                }
                if (qty < 1) {
                    qty = 1;
                    quantityInput.value = 1;
                }

                hiddenQuantityInput.value = qty;

                // 2. Chuẩn bị dữ liệu để gửi đi
                const formData = new FormData(form);
                const url = form.action;

                try {
                    const response = await fetch(url, {
                        method: 'POST',
                        // Chuyển FormData sang chuỗi query param để Servlet đọc dễ dàng
                        body: new URLSearchParams(formData)
                    });

                    // Đảm bảo response là OK và có thể đọc JSON
                    if (!response.ok) {
                        throw new Error(`Lỗi HTTP: ${response.status}`);
                    }

                    const data = await response.json(); // Nhận JSON từ GioHangServlet

                    if (data.success) {
                        // 3. Cập nhật số lượng giỏ hàng trên header
                        const cartCountElement = document.getElementById('cart-item-count');
                        if (cartCountElement && data.totalItems !== undefined) {
                            cartCountElement.textContent = data.totalItems;
                        }

                        // 4. Hiển thị thông báo thành công
                        alert(data.message);

                    } else {
                        // Hiển thị thông báo lỗi từ Server (nếu success: false)
                        alert("Lỗi: " + data.message);
                    }
                } catch (error) {
                    console.error('Lỗi AJAX khi thêm giỏ hàng:', error);
                    alert("Đã xảy ra lỗi hệ thống khi thêm vào giỏ hàng. Vui lòng thử lại.");
                }
            }
        </script>

        <jsp:include page="footer.jsp" />
    </body>
</html>