<%-- 
    Document   : hoso
    Created on : Oct 19, 2025, 12:09:13 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đổi mật khẩu- Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <!-- Font Awesome --> 
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body style="background-image: url(image/tt.jpg)">

        <%

            // Lấy Tên Đăng Nhập từ session
            String username = (String) session.getAttribute("username");

            // KIỂM TRA ĐĂNG NHẬP
            if (username == null) {
                // Nếu chưa đăng nhập, chuyển hướng về trang đăng nhập
                response.sendRedirect("dangnhap.jsp");
                return;
            }

            // Lấy thông báo (nếu có) từ quá trình xử lý form
            String msg = request.getParameter("msg");
        %>
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
                        <li><a href="quanlykho.jsp">Quản lý Kho</a></li>
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

        <div class="profile-container">

            <div class="profile-menu">
                <ul>
                    <li><a href="ProfileServlet">HỒ SƠ</a></li>
                    <li><a href="doimatkhau.jsp" class="active">ĐỔI MẬT KHẨU</a></li>
                    <li><a href="donmua.jsp">ĐƠN MUA</a></li>
                    <li><a href="giohang.jsp">GIỎ HÀNG</a></li>
                </ul>
            </div>

            <div class="profile-content">

                <h2 style="color: #f39c12;">ĐỔI MẬT KHẨU</h2>

                <c:if test="${not empty message}">
                    <p class="message">${message}</p>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <p class="errorMessage">${errorMessage}</p>
                </c:if>

                <form class="profile-form" action="ChangePasswordServlet" method="POST">

                    <label>MẬT KHẨU CŨ:</label>
                    <input type="password" name="oldPassword" required />

                    <label>MẬT KHẨU MỚI:</label>
                    <input type="password" name="newPassword" required />

                    <label>NHẬP LẠI MẬT KHẨU:</label>
                    <input type="password" name="confirmPassword" required />

                    <input type="submit" value="ĐỔI MẬT KHẨU" />
                </form>

            </div>
        </div>


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
