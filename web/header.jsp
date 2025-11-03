<%-- header.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
<%
    // Lấy giỏ hàng từ session để tính tổng số lượng
    Map<Integer, Integer> cartQuantityMap = (Map<Integer, Integer>) session.getAttribute("cartQuantityMap");
    int totalItemsInCart = 0;
    if (cartQuantityMap != null) {
        // ⭐ ĐÃ SỬA: Đếm TỔNG số lượng sản phẩm (ví dụ: 2 chiếc A4 + 1 chiếc A6 = 3)
        for (Integer quantity : cartQuantityMap.values()) {
            totalItemsInCart += quantity;
        }
    }
%>
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

        <% if (username != null) {%>

        <div class="cart-icon-wrapper">
            <a href="GioHangServlet" class="cart-link">
                <i class="fa-solid fa-cart-shopping"></i>
                <span id="cart-item-count" class="badge">
                    <%= totalItemsInCart%>
                </span>
            </a>
        </div>

        <%-- ... (Phần hiển thị Admin/User menu giữ nguyên) ... --%>
        <% if ("admin".equals(username)) {%>
        <div class="admin-menu account-menu">
            <span class="admin-name account-name">
                Quản trị <i class="fa-solid fa-caret-down"></i>
            </span>
            <ul class="dropdown">

               <li><a href="BrandServlet">Quản lý Hãng xe</a></li>
                <li><a href="SanPhamServlet">Quản lý Xe</a></li>
                <li><a href="SupplierServlet">Quản lý Nhà Cung Cấp</a></li>
                <li><a href="NhapHangServlet">Tạo Phiếu Nhập Hàng</a></li>
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
                <li><a href="DonMuaServlet">Đơn mua</a></li>
                <li><a href="dangxuat.jsp">Đăng xuất</a></li>
            </ul>
        </div>
        <% } %>

        <% } else {%>
        <div class="cart-icon-wrapper">
            <a href="GioHangServlet" class="cart-link">
                <i class="fa-solid fa-cart-shopping"></i>
                <span id="cart-item-count" class="badge">
                    <%= totalItemsInCart%>
                </span>
            </a>
        </div>

        <%-- ✅ Nếu chưa đăng nhập --%>
        <a href="dangnhap.jsp">Đăng nhập</a>
        <a href="dangky.jsp">Đăng ký</a>
        <% }%>
    </nav>
</header>

<style>
    /* CSS cơ bản cho số lượng giỏ hàng */
    .cart-icon-wrapper {
        position: relative;
        display: inline-block;
        margin-left: 10px; /* Thêm khoảng cách với các menu khác */
    }
    .cart-link {
        text-decoration: none;
        color: inherit; /* Kế thừa màu chữ */
    }
    .cart-icon-wrapper .badge {
        position: absolute;
        top: -10px; /* Đặt số lên trên icon */
        right: -10px; /* Đặt số ra phía ngoài icon */
        padding: 2px 6px;
        border-radius: 50%;
        background: red;
        color: white;
        font-size: 10px;
        line-height: 1.2;
        min-width: 12px; /* Đảm bảo hình tròn ngay cả với số 0 hoặc 1 */
        text-align: center;
        z-index: 10;
    }
</style>