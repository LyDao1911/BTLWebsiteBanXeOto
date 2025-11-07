<%-- 
    Document   : hotro
    Created on : Oct 15, 2025, 10:14:14 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="model.Customer"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Hỗ trợ - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
      
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <section class="contact-section">
            <div class="contact-left">
                <h2>LIÊN HỆ</h2>
                <p>Hỗ trợ khách hàng mua online</p>
                <p>Tổng đài: <strong>1800 6061</strong></p>
                <p>Thời gian: 9h - 11h, 13h - 17h (Thứ 2 - Thứ 6)</p>
                <p>Email: <a href="mailto:saleonline@canifa.com">saleonline@canifa.com</a></p>
                <p>Bạn vui lòng mô tả chi tiết các vấn đề cần hỗ trợ để chúng tôi giúp bạn nhanh chóng và hiệu quả nhất.</p>
            </div>

            <div class="contact-form">
                <%-- Hiển thị thông báo từ servlet --%>
                <c:if test="${not empty message}">
                    <div class="msg ${message.startsWith('✅') ? 'success' : 'error'}">${message}</div>
                </c:if>

                <%
                    Customer customer = (Customer) session.getAttribute("customer");
                    String hoten = (customer != null) ? customer.getFullName() : "";
                    String email = (customer != null) ? customer.getEmail() : "";
                    String sdt = (customer != null) ? customer.getPhoneNumber() : "";
                    String diachi = (customer != null) ? customer.getAddress() : "";
                %>

                <form action="HotroServlet" method="post">
                    <label for="hoten">Họ tên</label>
                    <input type="text" id="hoten" name="hoten" value="<%= hoten%>" required><br><br>

                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="<%= email%>" required><br><br>

                    <label for="sdt">Số điện thoại</label>
                    <input type="text" id="sdt" name="sdt" value="<%= sdt%>" required><br><br>

                    <label for="diachi">Địa chỉ</label>
                    <input type="text" id="diachi" name="diachi" value="<%= diachi%>"><br><br>

                    <label for="noidung">Nội dung cần hỗ trợ</label>
                    <textarea id="noidung" name="noidung" rows="5" required></textarea><br><br>

                    <button type="submit">GỬI YÊU CẦU</button>
                </form>
            </div>
        </section>

        <jsp:include page="footer.jsp" />
    </body>
</html>