<%-- 
    Document   : hoso
    Created on : Oct 19, 2025, 12:09:13 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
/*Trang hồ so và trang đổi mật khẩu*/

.profile-container {
    display: flex;
    width: 80%;
    margin: 50px auto;
    background-color: rgba(255, 255, 255, 0.3); /* màu trắng trong suốt */

    border-radius: 10px;
    overflow: hidden;
    border: 1px solid #444;
}

/* Cột Menu bên trái */
.profile-menu {
    width: 25%;
    background-color:rgba(34, 34, 34, 0.7); /* Màu đậm hơn */
    padding: 20px;
    border-right: 1px solid #444;
}
.profile-menu .user-avatar {
    text-align: center;
    margin-bottom: 20px;
}
.profile-menu .user-avatar img {
    width: 80px;
    height: 80px;
    border-radius: 50%;
}
.profile-menu .user-avatar p {
    font-weight: bold;
    margin-top: 10px;
}
.profile-menu ul {
    list-style-type: none;
    padding: 0;
}
.profile-menu ul li a {
    display: block;
    padding: 15px;
    text-decoration: none;
    color: #ccc;
    border-radius: 5px;
    margin-bottom: 5px;
}
.profile-menu ul li a.active,
.profile-menu ul li a:hover {
    background-color: #f39c12; /* Màu cam */
    color: #111;
}

/* Cột Form bên phải */
.profile-content {
    width: 75%;
    padding: 40px;
    background: url('image/tt.jpg') no-repeat center center; /* Ảnh nền mờ */
    background-size: cover;
}
.profile-form {
    max-width: 450px;
    margin: 0 auto; /* căn giữa ngang */
}
.profile-form label {
    display: block;
    margin-bottom: 5px;
    color: #ccc;
    font-weight: bold;
}
.profile-form input {
    width: 100%;
    padding: 12px;
    margin-bottom: 15px;
    background-color: #fff; /* Nền trắng như thiết kế */
    border: 1px solid #777;
    color: #333;
    border-radius: 5px;
}
.profile-form input[type="submit"] {
    background-color: #f39c12;
    color: white;
    cursor: pointer;
    font-weight: bold;
}
.message {
    color: lightgreen;
}
.errorMessage {
    color: red;
}
</style>
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
        <jsp:include page="header.jsp" />   

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


        <jsp:include page="footer.jsp" />
    </body>
</html>
