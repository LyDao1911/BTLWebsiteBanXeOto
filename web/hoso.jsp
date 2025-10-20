<%-- 
    Document   : hoso
    Created on : Oct 19, 2025, 12:09:13 PM
    Author     : Admin
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hồ Sơ Của Bạn</title>
        <link rel="stylesheet" href="style.css"> 
        

    </head>
    <body>
        <!-- 🔹 THANH TÁC VỤ -->
        <header class="navbar">
            <div class="logo">
                <img src="image/logo.png" alt="Velyra Aero Logo" />
                <span>VELYRA AERO</span>
            </div>


            <div class="search-box">
                <input type="text" placeholder="Tìm kiếm xe..." />
                <button><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>

            <% String username = (String) session.getAttribute("username"); %>

            <nav class="menu">
                <a href="hotro.jsp">Hỗ trợ</a>
                <% if (username != null) {%>
                <div class="account-menu">
                    <span class="account-name">
                        👋 <%= username%> <i class="fa-solid fa-caret-down"></i>
                    </span>
                    <ul class="dropdown">
                        <li><a href="ProfileServlet">Thông tin cá nhân</a></li>
                        <li><a href="giohang.jsp">Giỏ hàng</a></li>
                        <li><a href="donmua.jsp">Đơn mua</a></li>
                            <% if ("admin".equals(username)) { %>
                        <li><a href="themsanpham.jsp">Thêm sản phẩm</a></li>
                            <% } %>
                        <li><a href="dangxuat.jsp">Đăng xuất</a></li>
                    </ul>
                </div>
                <% } else { %>
                <a href="dangnhap.jsp">Đăng nhập</a>
                <a href="dangky.jsp">Đăng ký</a>
                <% }%>
            </nav>
        </header>
            
        <!-- 🔹 form -->
        <div class="profile-container">

            <div class="profile-menu">
                <ul>
                    <li><a href="ProfileServlet" class="active">HỒ SƠ</a></li>
                    <li><a href="doimatkhau.jsp">ĐỔI MẬT KHẨU</a></li>
                    <li><a href="donmua.jsp">ĐƠN MUA</a></li>
                    <li><a href="giohang.jsp">GIỎ HÀNG</a></li>
                </ul>
            </div>

            <div class="profile-content">

                <c:if test="${not empty message}">
                    <p class="message">${message}</p>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <p class="errorMessage">${errorMessage}</p>
                </c:if>

                <form class="profile-form" action="ProfileServlet" method="POST">

                    <label>TÊN ĐĂNG NHẬP:</label>
                    <input type="text" value="${customer.userName}" disabled />

                    <label>HỌ VÀ TÊN:</label>
                    <input type="text" name="fullName" value="${customer.fullName}" />

                    <label>EMAIL:</label>
                    <input type="email" name="email" value="${customer.email}" />

                    <label>SỐ ĐIỆN THOẠI:</label>
                    <input type="tel" name="phone" value="${customer.phoneNumber}" />

                    <label>ĐỊA CHỈ:</label>
                    <input type="text" name="address" value="${customer.address}" />

                    <input type="submit" value="LƯU" />
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
