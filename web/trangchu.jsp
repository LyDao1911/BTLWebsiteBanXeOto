<%-- 
    Document   : trangchu
    Created on : Oct 15, 2025, 4:56:23 PM
    Author     : Admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>
        <!-- 🔹 THANH TÁC VỤ -->
        <jsp:include page="header.jsp" />
           

           

        <!-- 🔹 HERO VIDEO -->
        <section class="hero">
            <video autoplay muted loop playsinline class="hero-video">
                <source src="video/video_home.mp4" type="video/mp4" />
            </video>

            <div class="overlay"></div>

            <div class="hero-content">
                <h1>Khám phá thế giới xe tương lai</h1>
                <p>Trải nghiệm sức mạnh & công nghệ vượt trội cùng Velyra Aero</p>
            </div>
        </section>
        <section class="brands">
            <c:choose>
                <c:when test="${not empty brandsList}">
                    <div class="brand-container"> 
                        <c:forEach var="brand" items="${brandsList}">
                            <div class="brand-card">

                                <c:set var="cleanLogoURL" value="${fn:substringAfter(brand.logoURL, '/')}" />

                                <img src="${pageContext.request.contextPath}/uploads/logos/${brand.logoURL}" alt="${brand.brandName}" />

                                <p>${brand.brandName}</p> 
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="text-align: center; width: 100%; padding: 20px;">
                        Không có hãng xe nào để hiển thị.
                    </p>
                </c:otherwise>
            </c:choose>
        </section>
        <!-- 🔹 DANH SÁCH XE THEO HÃNG -->
        <c:choose>
            <c:when test="${not empty carsByBrand}">
                <c:forEach var="entry" items="${carsByBrand}">
                    <section class="car-section">
                        <!-- Tên hãng xe -->
                        <h2 class="brand-title">${entry.key.brandName}</h2>

                        <div class="car-list">
                            <c:forEach var="car" items="${entry.value}">
                                <div class="car-card">
                                    <a href="MotaServlet?carID=${car.carID}">
                                        <!-- Ảnh xe -->
                                        <c:set var="imageDirName" value="${car.carName}" />
                                        <img src="${pageContext.request.contextPath}/uploads/${car.mainImageURL}" alt="${car.carName}">

                                        <!-- Tên xe -->
                                        <p class="car-name">${car.carName}</p>

                                        <!-- Giá xe -->
                                        <p class="car-price">${car.price} VND</p>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <section class="car-section" style="text-align: center;">
                    <h2>Sản phẩm</h2>
                    <p>Hiện không có sản phẩm nào để hiển thị.</p>
                </section>
            </c:otherwise>
        </c:choose>

        <jsp:include page="footer.jsp" />
       
    </body>
</html>

