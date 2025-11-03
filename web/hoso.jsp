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
                    <jsp:include page="footer.jsp" />
    </body>
</html>
