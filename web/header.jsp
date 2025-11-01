<%-- 
    Document   : header
    Created on : Oct 28, 2025, 3:54:57 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <div class="admin-menu account-menu">
            <span class="admin-name account-name">
                Quản trị <i class="fa-solid fa-caret-down"></i>
            </span>
            <ul class="dropdown">

                <li><a href="BrandServlet">Quản lý Hãng xe</a></li>
                <li><a href="SanPhamServlet">Quản lý Xe</a></li>
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