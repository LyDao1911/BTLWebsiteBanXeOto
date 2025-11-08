<%-- 
    Document   : trangchu
    Created on : Oct 15, 2025, 4:56:23 PM
    Author     : Admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<style>
    /* Thêm vào file style.css */
    .video-navigation {
        position: absolute; /* Đặt tương đối với .hero */
        top: 50%;
        left: 0;
        width: 100%;
        display: flex;
        justify-content: space-between;
        transform: translateY(-50%);
        z-index: 10; /* Đặt trên video và overlay */
        padding: 0 20px;
    }

    .nav-button {
        background: rgba(0, 0, 0, 0.5);
        color: white;
        border: none;
        padding: 15px 10px;
        cursor: pointer;
        font-size: 24px;
        transition: background 0.3s;
        border-radius: 5px;
    }

    .nav-button:hover {
        background: rgba(0, 0, 0, 0.8);
    }
    .hero-video {
        /* ... các thuộc tính khác của video ... */
        width: 100%;
        height: 100%;
        object-fit: cover;
        opacity: 1; /* Mặc định là hiển thị */
        transition: opacity 0.5s ease-in-out; /* THÊM TRANSITION */
    }

    /* Lớp này dùng để ẩn video khi đang tải */
    .video-fading {
        opacity: 0 !important;
    }
</style>
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
            <video autoplay muted loop playsinline class="hero-video" id="heroVideo">
                <source id="heroVideoSource" src="" type="video/mp4" />
            </video>

            <div id="videoList" style="display: none;"
                 data-videos='["video/vd.mp4", "video/vd1.mp4", "video/video_home.mp4"]'>
            </div>

            <div class="video-navigation">
                <button class="nav-button prev-button" id="prevVideoBtn">
                    <i class="fas fa-chevron-left"></i>
                </button>
                <button class="nav-button next-button" id="nextVideoBtn">
                    <i class="fas fa-chevron-right"></i>
                </button>
            </div>

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
                                        <p class="car-price">
                                            Giá: <fmt:formatNumber value="${car.price}" pattern="#,##0"/>đ 
                                        </p>

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
        <jsp:include page="footer.jsp" />

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const heroVideo = document.getElementById('heroVideo');
                const heroVideoSource = document.getElementById('heroVideoSource');
                const prevBtn = document.getElementById('prevVideoBtn');
                const nextBtn = document.getElementById('nextVideoBtn');
                const videoListDiv = document.getElementById('videoList');

                const videoURLs = JSON.parse(videoListDiv.getAttribute('data-videos'));
                const contextPath = "${pageContext.request.contextPath}";
                let currentVideoIndex = 0;
                const FADE_TIME = 500; // Thời gian hiệu ứng mờ (phải khớp với CSS: 0.5s)

                if (!videoURLs || videoURLs.length === 0) {
                    console.error("Không tìm thấy danh sách video.");
                    return;
                }

                // --- HÀM THAY ĐỔI VIDEO ---
                function loadVideo(index) {

                    // Tạm dừng phát lại để tránh hiện tượng nháy khung hình
                    heroVideo.pause();

                    // 1. Áp dụng hiệu ứng mờ dần (Fade Out)
                    heroVideo.classList.add('video-fading');

                    // Đợi cho hiệu ứng mờ dần hoàn tất
                    setTimeout(() => {
                        // Đảm bảo chỉ mục nằm trong phạm vi (tuần hoàn)
                        if (index < 0) {
                            index = videoURLs.length - 1;
                        } else if (index >= videoURLs.length) {
                            index = 0;
                        }

                        currentVideoIndex = index;
                        const selectedVideoURL = videoURLs[currentVideoIndex];

                        // 2. Cập nhật nguồn video
                        heroVideoSource.src = contextPath + "/" + selectedVideoURL;
                        heroVideo.load();

                        // 3. Đợi video mới sẵn sàng để phát
                        heroVideo.oncanplay = () => {
                            // 4. Bắt đầu phát và loại bỏ hiệu ứng mờ (Fade In)
                            heroVideo.classList.remove('video-fading');
                            heroVideo.play().catch(error => {
                                console.warn("Autoplay bị chặn.");
                            });

                            // Loại bỏ sự kiện để nó không chạy lại khi video tạm dừng
                            heroVideo.oncanplay = null;
                        };

                    }, FADE_TIME); // Độ trễ bằng thời gian transition CSS
                }

                // --- XỬ LÝ NÚT BẤM ---
                prevBtn.addEventListener('click', () => {
                    loadVideo(currentVideoIndex - 1);
                });

                nextBtn.addEventListener('click', () => {
                    loadVideo(currentVideoIndex + 1);
                });

                // Tải video đầu tiên khi trang load xong (không cần hiệu ứng mờ)
                // Lưu ý: Chúng ta không dùng loadVideo() ở đây để tránh độ trễ ban đầu
                heroVideoSource.src = contextPath + "/" + videoURLs[currentVideoIndex];
                heroVideo.load();
                heroVideo.play().catch(error => {
                });
            });
        </script>



    </body>
</html>

