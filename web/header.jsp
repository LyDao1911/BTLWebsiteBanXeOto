<%--
    Document   : header
    Created on : Nov 9, 2025, 1:08:30 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
<%
    // Lấy giỏ hàng từ session để tính tổng số lượng
    Map<Integer, Integer> cartQuantityMap = (Map<Integer, Integer>) session.getAttribute("cartQuantityMap");
    int totalItemsInCart = 0;
    if (cartQuantityMap != null) {
        // Đếm TỔNG số lượng sản phẩm
        for (Integer quantity : cartQuantityMap.values()) {
            totalItemsInCart += quantity;
        }
    }
    // Gán username vào scope để dễ dàng sử dụng trong EL/JSTL
    session.setAttribute("currentUsername", (String) session.getAttribute("username"));
    // Lưu ý: Dùng sessionScope.username thay cho biến local username trong JSTL/EL
%>
<header class="navbar">
    <div class="logo">
        <a href="HomeServlet" style="text-decoration: none; color: inherit;">
            <img src="image/logo.png" alt="Velyra Aero Logo" />
            <span>VELYRA AERO</span>
        </a>
    </div>

    <nav class="menu">
        <%-- Kiểm tra đã đăng nhập chưa --%>
        <c:choose>
            <c:when test="${not empty sessionScope.currentUsername}">
                <%-- Đã đăng nhập --%>
                <c:choose>
                    <c:when test="${sessionScope.currentUsername eq 'admin'}">
                        <%-- ✅ Nếu là ADMIN - KHÔNG có tìm kiếm và giỏ hàng --%>
                        <div class="admin-menu account-menu">
                            <span class="admin-name account-name">
                                Quản lý hỗ trợ <i class="fa-solid fa-caret-down"></i>
                            </span>
                            <ul class="dropdown">
                                <li><a href="AdminSupportServlet">Quản Lý Danh Sách Hỗ trợ</a></li>
                            </ul>
                        </div>
                        <div class="admin-menu account-menu">
                            <span class="admin-name account-name">
                                Quản trị <i class="fa-solid fa-caret-down"></i>
                            </span>
                            <ul class="dropdown">
                                <li><a href="BrandServlet">Quản lý Hãng xe</a></li>
                                <li><a href="SanPhamServlet">Quản lý Xe</a></li>
                                <li><a href="SupplierServlet">Quản lý Nhà Cung Cấp</a></li>
                                <li><a href="NhapHangServlet">Tạo Phiếu Nhập Hàng</a></li>
                                <li><a href="DanhSachPhieuNhapServlet">Quản Lý Phiếu Nhập</a></li>
                                <li><a href="ReportServlet">Báo Cáo Thống Kê</a></li>
                            </ul>
                        </div>
                        <div class="account-menu">
                            <span class="account-name">
                                ${sessionScope.currentUsername} <i class="fa-solid fa-caret-down"></i>
                            </span>
                            <ul class="dropdown">
                                <li><a href="ChangePasswordServlet">Đổi mật khẩu</a></li>
                                <li><a href="dangxuat.jsp">Đăng xuất</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%-- ✅ Nếu là NGƯỜI DÙNG THƯỜNG - CÓ tìm kiếm và giỏ hàng --%>
                        <div class="search-icon-wrapper">
                            <button class="search-icon-btn" id="searchToggle">
                                <i class="fas fa-search"></i>
                            </button>
                            <div class="search-box-mini" id="searchBoxMini">
                                <form action="TimKiemServlet" method="GET" class="search-form-mini">
                                    <input type="text"
                                           name="keyword"
                                           placeholder="Tìm kiếm xe..."
                                           class="search-input-mini"
                                           value="${param.keyword}"
                                           id="searchInput">
                                    <button type="submit" class="search-submit-mini">
                                        <i class="fas fa-arrow-right"></i>
                                    </button>
                                </form>
                            </div>
                        </div>

                        <div class="cart-icon-wrapper">
                            <a href="GioHangServlet" class="cart-link">
                                <i class="fa-solid fa-cart-shopping"></i>
                                <span id="cart-item-count" class="badge">
                                    <%= totalItemsInCart%>
                                </span>
                            </a>
                        </div>

                        <div class="admin-menu account-menu">
                            <span class="admin-name account-name">
                                Hỗ trợ <i class="fa-solid fa-caret-down"></i>
                            </span>
                            <ul class="dropdown">
                                <li><a href="hotro.jsp">Gửi yêu cầu hỗ trợ</a></li>
                                <li><a href="MySupportServlet"> Yêu Cầu Hỗ Trợ Của Tôi</a></li>
                            </ul>
                        </div>
                        <div class="account-menu">
                            <span class="account-name">
                                ${sessionScope.currentUsername} <i class="fa-solid fa-caret-down"></i>
                            </span>
                            <ul class="dropdown">
                                <li><a href="ProfileServlet">Thông tin cá nhân</a></li>
                                <li><a href="DonMuaServlet">Đơn mua</a></li>
                                <li><a href="dangxuat.jsp">Đăng xuất</a></li>
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <%-- Chưa đăng nhập: Hiển thị tìm kiếm, Giỏ hàng và nút Đăng nhập/Đăng ký --%>
                <div class="search-icon-wrapper">
                    <button class="search-icon-btn" id="searchToggle">
                        <i class="fas fa-search"></i>
                    </button>
                    <div class="search-box-mini" id="searchBoxMini">
                        <form action="TimKiemServlet" method="GET" class="search-form-mini">
                            <input type="text"
                                   name="keyword"
                                   placeholder="Tìm kiếm xe..."
                                   class="search-input-mini"
                                   value="${param.keyword}"
                                   id="searchInput">
                            <button type="submit" class="search-submit-mini">
                                <i class="fas fa-arrow-right"></i>
                            </button>
                        </form>
                    </div>
                </div>

                <div class="cart-icon-wrapper">
                    <a href="GioHangServlet" class="cart-link">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <span id="cart-item-count" class="badge">
                            <%= totalItemsInCart%>
                        </span>
                    </a>
                </div>
                <a href="dangnhap.jsp">Đăng nhập</a>
                <a href="dangky.jsp">Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </nav>
</header>

<style>
    /* CSS cơ bản cho số lượng giỏ hàng */
    .cart-icon-wrapper {
        position: relative;
        display: inline-block;
        margin-left: 10px;
    }
    .cart-link {
        text-decoration: none;
        color: inherit;
    }
    .cart-icon-wrapper .badge {
        position: absolute;
        top: -10px;
        right: -10px;
        padding: 2px 6px;
        border-radius: 50%;
        background: red;
        color: white;
        font-size: 10px;
        line-height: 1.2;
        min-width: 12px;
        text-align: center;
        z-index: 10;
        margin-right: 20px;
    }

    /* CSS cho biểu tượng tìm kiếm nhỏ */
    .search-icon-wrapper {
        position: relative;
        display: inline-block;
    }
    .search-icon-btn {
        background: none;
        border: none;
        color: #fff;
        font-size: 16px;
        padding: 8px 12px;
        cursor: pointer;
        border-radius: 50%;
        transition: all 0.3s ease;
    }
    .search-icon-btn:hover {
        background: #f5f5f5;
        color: #e52b2b;
    }
    .search-box-mini {
        position: absolute;
        top: 100%;
        right: 0;
        width: 300px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        padding: 10px;
        z-index: 1000;
        display: none;
        margin-top: 5px;
    }
    .search-box-mini.active {
        display: block;
    }
    .search-form-mini {
        display: flex;
        gap: 8px;
    }
    .search-input-mini {
        flex: 1;
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 14px;
        outline: none;
    }
    .search-input-mini:focus {
        border-color: #e52b2b;
    }
    .search-submit-mini {
        padding: 8px 12px;
        background: #e52b2b;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: background 0.3s ease;
    }
    .search-submit-mini:hover {
        background: #c41e1e;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .search-box-mini {
            right: -50px;
            width: 250px;
        }
    }
    .search-box {
        display: flex;
        align-items: center;
        background-color: #fff;
        border-radius: 20px;
        padding: 5px 10px;
        margin-right: 20px;
    }

    .search-box input {
        border: none;
        outline: none;
        padding: 6px 10px;
        font-size: 14px;
        border-radius: 20px;
        font-family: 'Poppins', sans-serif;
    }

    .search-box button {
        background: none;
        border: none;
        cursor: pointer;
        color: #e52b2b;
        font-size: 16px;
    }
</style>

<script>
    // Xử lý mở/đóng thanh tìm kiếm
    document.addEventListener('DOMContentLoaded', function () {
        const searchToggle = document.getElementById('searchToggle');
        const searchBoxMini = document.getElementById('searchBoxMini');
        const searchInput = document.getElementById('searchInput');
        const searchForm = document.querySelector('.search-form-mini');

        // Chỉ xử lý nếu các phần tử tồn tại (tránh lỗi khi admin đăng nhập)
        if (searchToggle && searchBoxMini && searchInput && searchForm) {
            // Mở/đóng thanh tìm kiếm khi click icon
            searchToggle.addEventListener('click', function (e) {
                e.stopPropagation();
                searchBoxMini.classList.toggle('active');
                if (searchBoxMini.classList.contains('active')) {
                    setTimeout(() => {
                        searchInput.focus();
                    }, 100);
                }
            });

            // Đóng thanh tìm kiếm khi click ra ngoài
            document.addEventListener('click', function (e) {
                if (!searchBoxMini.contains(e.target) && e.target !== searchToggle) {
                    searchBoxMini.classList.remove('active');
                }
            });

            // Ngăn đóng khi click trong thanh tìm kiếm
            searchBoxMini.addEventListener('click', function (e) {
                e.stopPropagation();
            });

            // Submit form khi nhấn Enter
            searchInput.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    searchForm.submit();
                }
            });

            // Tự động focus vào input khi mở
            searchToggle.addEventListener('click', function () {
                setTimeout(() => {
                    if (searchInput)
                        searchInput.focus();
                }, 100);
            });
        }
    });
</script>