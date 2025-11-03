<%@page import="model.Car" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% Car car = (Car) request.getAttribute("car");%> 

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

                    <div class="quantity-selector">
                        <span class="quantity-label">SỐ LƯỢNG:</span>
                        <button type="button" onclick="decrementQuantity()">-</button>
                        <input type="number" id="quantity" value="1" min="1" max="${car.quantity}">
                        <button type="button" onclick="incrementQuantity()">+</button>

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