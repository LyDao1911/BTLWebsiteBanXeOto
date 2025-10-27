<%-- 
    Document   : giohang
    Created on : Oct 21, 2025, 9:10:28 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Giỏ hàng - Velyra Aero</title>
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

        <div class="cart-container">
            <div class="cart-header">
                <input type="checkbox" id="selectAll">
                <div>SẢN PHẨM</div>
                <div>ĐƠN GIÁ</div>
                <div>SỐ LƯỢNG</div>
                <div>SỐ TIỀN</div>
                <div>THAO TÁC</div>
            </div>

            <div class="brand">MERCEDES</div>

            <div class="cart-item">
                <input type="checkbox" class="selectItem">
                <div class="product-info">
                    <img src="images/vinfast.jpg" alt="">
                    <span>VinFast Lux A2.0</span>
                </div>
                <div class="price" data-price="981695000">981.695.000đ</div>
                <div class="qty-control">
                    <button class="minus">-</button>
                    <input type="text" value="1" class="qty">
                    <button class="plus">+</button>
                </div>
                <div class="subtotal">981.695.000đ</div>
                <div class="remove">Xoá</div>
            </div>

            <div class="brand">FERRARI</div>

            <div class="cart-item">
                <input type="checkbox" class="selectItem">
                <div class="product-info">
                    <img src="images/vinfast.jpg" alt="">
                    <span>VinFast Lux A2.0</span>
                </div>
                <div class="price" data-price="981695000">981.695.000đ</div>
                <div class="qty-control">
                    <button class="minus">-</button>
                    <input type="text" value="1" class="qty">
                    <button class="plus">+</button>
                </div>
                <div class="subtotal">981.695.000đ</div>
                <div class="remove">Xoá</div>
            </div>

            <div class="cart-footer">
                <div class="total">Tổng: <span id="totalPrice">0đ</span></div>
                <button class="buy-btn">MUA HÀNG</button>
            </div>
        </div>

        <script>
            const selectAll = document.getElementById("selectAll");
            const itemCheckboxes = document.querySelectorAll(".selectItem");
            const totalPriceEl = document.getElementById("totalPrice");

            // Chọn tất cả
            selectAll.addEventListener("change", function () {
                itemCheckboxes.forEach(cb => cb.checked = selectAll.checked);
                updateTotal();
            });

            // Tăng giảm số lượng
            document.querySelectorAll(".cart-item").forEach(item => {
                const price = parseInt(item.querySelector(".price").dataset.price);
                const qtyInput = item.querySelector(".qty");
                const subtotalEl = item.querySelector(".subtotal");

                item.querySelector(".plus").addEventListener("click", () => {
                    qtyInput.value = parseInt(qtyInput.value) + 1;
                    updateSubtotal();
                });

                item.querySelector(".minus").addEventListener("click", () => {
                    if (parseInt(qtyInput.value) > 1) {
                        qtyInput.value = parseInt(qtyInput.value) - 1;
                        updateSubtotal();
                    }
                });

                function updateSubtotal() {
                    const qty = parseInt(qtyInput.value);
                    const subtotal = price * qty;
                    subtotalEl.textContent = subtotal.toLocaleString("vi-VN") + "đ";
                    updateTotal();
                }
            });

            // Cập nhật tổng tiền
            function updateTotal() {
                let total = 0;
                document.querySelectorAll(".cart-item").forEach(item => {
                    const cb = item.querySelector(".selectItem");
                    const price = parseInt(item.querySelector(".price").dataset.price);
                    const qty = parseInt(item.querySelector(".qty").value);
                    if (cb.checked)
                        total += price * qty;
                });
                totalPriceEl.textContent = total.toLocaleString("vi-VN") + "đ";
            }

            // Tick chọn từng sản phẩm
            itemCheckboxes.forEach(cb => cb.addEventListener("change", updateTotal));
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
