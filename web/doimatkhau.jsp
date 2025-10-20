<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đổi Mật Khẩu</title>
        <link rel="stylesheet" href="style.css"> 
    </head>
    <body>

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

    </body>
</html>