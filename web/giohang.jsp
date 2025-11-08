<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<style>
/* ==========================
GIỎ HÀNG (giohang.jsp)
========================== */
.cart-container {
    width: 85%;
    margin: 40px auto;
    background: #fff;
    border-radius: 10px;
    padding: 20px 40px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
.cart-header, .cart-item {
    display: grid;
    grid-template-columns: 60px 2fr 1fr 1fr 1fr 0.7fr;
    align-items: center;
    text-align: center;
    padding: 12px 0;
    border-bottom: 1px solid #eee;
}
.cart-header {
    font-weight: bold;
    color: #444;
    border-bottom: 2px solid #ccc;
}
.brand {
    color: #c00;
    font-weight: bold;
    margin-top: 25px;
    margin-bottom: 8px;
    font-size: 17px;
}
.cart-item img {
    width: 110px;
    height: 70px;
    object-fit: cover;
    border-radius: 6px;
    margin-right: 10px;
}
.product-info {
    display: flex;
    align-items: center;
    justify-content: flex-start;
    gap: 10px;
}
.product-info span {
    font-size: 15px;
}
.qty-control {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 4px;
}
.qty-control button {
    border: 1px solid #aaa;
    background: #fff;
    width: 32px;
    height: 32px;
    cursor: pointer;
    font-size: 18px;
    border-radius: 4px;
    transition: all 0.2s;
}
.qty-control button:hover {
    background: #f2f2f2;
}
.qty-control input {
    width: 45px;
    text-align: center;
    border: 1px solid #ccc;
    height: 32px;
    border-radius: 4px;
    font-size: 16px;
}
.price {
    color: #333;
    font-weight: bold;
    font-size: 16px;
}
.remove {
    color: red;
    cursor: pointer;
    text-decoration: underline;
}
.cart-footer {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    margin-top: 25px;
    font-size: 18px;
}
.total {
    margin-right: 20px;
    font-weight: bold;
}
.buy-btn {
    background-color: orange;
    color: #fff;
    border: none;
    padding: 10px 25px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 16px;
}
.buy-btn:hover {
    background-color: #e69500;
}
input[type="checkbox"] {
    transform: scale(1.3);
    cursor: pointer;
}

</style>
<html>
   
    <head>
       
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Giỏ hàng - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>

        <jsp:include page="header.jsp" />

        <c:if test="${not empty sessionScope.toastMessage}">
            <script>alert("${sessionScope.toastMessage}");</script>
            <c:remove var="toastMessage" scope="session"/>
        </c:if>

        <form id="checkoutForm" method="GET" action="DatHangServlet">
            <div class="cart-container">
                <h2>🛒 Giỏ hàng của bạn</h2>

                <c:choose>
                    <c:when test="${empty requestScope.cartList}">
                        <p>Giỏ hàng của bạn đang trống. <a href="HomeServlet">Mua ngay!</a></p>
                    </c:when>

                    <c:otherwise>
                        <div class="cart-main-form">	
                            <div class="cart-header">
                                <input type="checkbox" id="selectAll">
                                <div>SẢN PHẨM</div>
                                <div>ĐƠN GIÁ</div>
                                <div>SỐ LƯỢNG</div>
                                <div>SỐ TIỀN</div>
                                <div>THAO TÁC</div>
                            </div>

                            <c:forEach var="car" items="${requestScope.cartList}">
                                <div class="cart-item" data-carid="${car.carID}">
                                    <input type="checkbox" class="selectItem" value="${car.carID}">	

                                    <div class="product-info">
                                        <img src="${pageContext.request.contextPath}/uploads/${car.mainImageURL}" alt="${car.carName}" width="100">
                                        <span>${car.carName}</span>
                                    </div>
                                    <div class="price" data-price="${car.price}">
                                        <fmt:formatNumber value="${car.price}" pattern="#,##0" />đ
                                    </div>
                                    <div class="qty-control">
                                        <button type="button" class="minus">-</button>
                                        <input type="number" value="${car.quantity}" class="qty" min="1">	
                                        <button type="button" class="plus">+</button>
                                    </div>
                                    <div class="subtotal" data-subtotal="${car.price * car.quantity}">
                                        <fmt:formatNumber value="${car.price * car.quantity}" pattern="#,##0" />đ
                                    </div>
                                    <div class="remove">
                                        <a href="RemoveFromCartServlet?carID=${car.carID}" class="remove-btn">Xoá</a>
                                    </div>
                                </div>
                            </c:forEach>

                            <div class="cart-footer">
                                <div class="total">
                                    Tổng: <span id="totalPrice">0đ</span>
                                </div>
                                <button type="button" class="buy-btn" id="btnMuaHang">MUA HÀNG</button>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </form>

        <jsp:include page="footer.jsp" />

        <script>
            // KHAI BÁO BIẾN ĐẦU TIÊN
            const selectAll = document.getElementById("selectAll");
            const itemCheckboxes = document.querySelectorAll(".selectItem");
            const totalPriceEl = document.getElementById("totalPrice");
            const btnMuaHang = document.getElementById("btnMuaHang");
            const checkoutForm = document.getElementById("checkoutForm"); // LẤY FORM MỚI

            // Hàm gọi AJAX để cập nhật số lượng trên Server (Session)
            function updateCartOnServer(carID, newQuantity, itemElement) {
                const xhr = new XMLHttpRequest();
                xhr.open("POST", "GioHangServlet", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success) {
                                const qtyInput = itemElement.querySelector(".qty");

                                if (parseInt(qtyInput.value) !== response.quantity) {
                                    qtyInput.value = response.quantity;
                                    updateSubtotalInternal(itemElement);
                                }

                                if (response.message) {
                                    alert(response.message);
                                }

                                if (response.quantity === 0) {
                                    itemElement.remove();
                                }

                                updateTotal();
                            } else {
                                alert("Lỗi khi cập nhật giỏ hàng.");
                            }
                        } catch (e) {
                            console.error("Lỗi parse JSON hoặc kết nối: " + e);
                        }
                    }
                };
                xhr.send(`action=update&carID=${carID}&quantity=${newQuantity}`);
            }

            // Hàm nội bộ chỉ tính phụ phí trên client (dùng sau khi Server giới hạn)
            function updateSubtotalInternal(itemElement) {
                const price = parseFloat(itemElement.querySelector(".price").dataset.price);
                const qtyInput = itemElement.querySelector(".qty");
                const qty = parseInt(qtyInput.value);
                const subtotalEl = itemElement.querySelector(".subtotal");
                const subtotal = price * qty;
                subtotalEl.textContent = subtotal.toLocaleString("vi-VN") + "đ";
                subtotalEl.dataset.subtotal = subtotal;
            }

            // Hàm tính toán phụ phí và gọi Server (dùng khi người dùng thao tác)
            function updateSubtotal(itemElement) {
                const qtyInput = itemElement.querySelector(".qty");
                let qty = parseInt(qtyInput.value);
                if (isNaN(qty) || qty < 0) {
                    qty = 0;
                    qtyInput.value = 0;
                }

                updateSubtotalInternal(itemElement);

                const carID = itemElement.dataset.carid;
                updateCartOnServer(carID, qty, itemElement);
            }

            // 1. CHỨC NĂNG CHECK ALL và TÍNH TỔNG TIỀN
            selectAll?.addEventListener("change", function () {
                document.querySelectorAll(".selectItem").forEach(cb => cb.checked = selectAll.checked);
                updateTotal();
            });
            itemCheckboxes.forEach(cb => cb.addEventListener("change", updateTotal));

            // 2. CHỨC NĂNG TĂNG/GIẢM SỐ LƯỢNG
            document.querySelectorAll(".cart-item").forEach(item => {
                const qtyInput = item.querySelector(".qty");
                item.querySelector(".plus").addEventListener("click", () => {
                    let currentQty = parseInt(qtyInput.value);
                    qtyInput.value = currentQty + 1;
                    updateSubtotal(item);
                });
                item.querySelector(".minus").addEventListener("click", () => {
                    if (parseInt(qtyInput.value) > 0) {
                        qtyInput.value = parseInt(qtyInput.value) - 1;
                        updateSubtotal(item);
                    }
                });
                qtyInput.addEventListener("change", () => {
                    updateSubtotal(item);
                });
            });

            // 3. CẬP NHẬT TỔNG TIỀN (Chỉ tính những mục được chọn)
            function updateTotal() {
                let total = 0;
                document.querySelectorAll(".cart-item").forEach(item => {
                    const cb = item.querySelector(".selectItem");
                    const subtotal = parseFloat(item.querySelector(".subtotal")?.dataset.subtotal || 0);
                    if (cb.checked) {
                        total += subtotal;
                    }
                });
                totalPriceEl.textContent = total.toLocaleString("vi-VN") + "đ";
            }

            // Chạy hàm tổng tiền lần đầu khi tải trang
            document.addEventListener('DOMContentLoaded', () => {
                updateTotal();
            });

            // 4. CHỨC NĂNG MUA HÀNG (Checkout) - Dùng để thêm tham số vào form rồi submit
            function checkout() {
                let selectedCarIDs = [];
                const checkedItems = document.querySelectorAll(".cart-item .selectItem:checked");

                // 1. Kiểm tra sản phẩm được chọn
                if (checkedItems.length === 0) {
                    alert("Vui lòng chọn ít nhất một sản phẩm để mua hàng.");
                    return;
                }

                // 2. Thu thập CarIDs
                checkedItems.forEach(cb => {
                    const itemElement = cb.closest(".cart-item");
                    const quantity = parseInt(itemElement.querySelector(".qty").value);

                    if (quantity > 0) {
                        selectedCarIDs.push(cb.value);
                    } else {
                        // Nếu có sản phẩm số lượng = 0, báo lỗi và dừng
                        alert(`Sản phẩm ${itemElement.querySelector('.product-info span').textContent} đang có số lượng là 0. Vui lòng cập nhật.`);
                        selectedCarIDs = []; // Xóa hết ID nếu có lỗi
                        return;
                    }
                });

                if (selectedCarIDs.length === 0) {
                    alert("Không có sản phẩm hợp lệ nào được chọn để mua hàng.");
                    return;
                }

                // 3. Xóa hidden input cũ nếu có
                const oldInput = checkoutForm.querySelector('input[name="carIDs"]');
                if (oldInput) {
                    oldInput.remove();
                }

                // 4. Tạo hidden input để truyền list ID qua tham số carIDs
                const carIDsInput = document.createElement('input');
                carIDsInput.type = 'hidden';
                carIDsInput.name = 'carIDs';
                carIDsInput.value = selectedCarIDs.join(',');

                checkoutForm.appendChild(carIDsInput);

                // 5. Kích hoạt Form Submit
                checkoutForm.submit();
            }

            // 5. GẮN HÀM CHECKOUT VÀO NÚT "MUA HÀNG"
            if (btnMuaHang) {
                btnMuaHang.addEventListener('click', checkout);
            }
        </script>

    </body>
</html>