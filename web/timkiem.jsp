<%-- 
    Document   : timkiem
    Created on : Oct 16, 2025, 10:15:22 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tìm kiếm - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <!-- Font Awesome --> 
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>
        <!-- 🔹 THANH TÁC VỤ -->
       <jsp:include page="header.jsp" />
        <main class="search-page clean-style">
            <aside class="filter-box">
                <h3><i class="fas fa-filter"></i> BỘ LỌC TÌM KIẾM</h3>

                <div class="filter-group brand-filter">
                    <label>Thương hiệu</label>
                    <div class="checkbox-list">
                        <label><input type="checkbox" name="brand" value="VinFast"> VinFast</label>
                        <label><input type="checkbox" name="brand" value="Lamborghini"> Lamborghini</label>
                        <label><input type="checkbox" name="brand" value="Porsche"> Porsche</label>
                        <label><input type="checkbox" name="brand" value="Ferrari"> Ferrari</label>
                        <label><input type="checkbox" name="brand" value="Rolls-Royce"> Rolls-Royce</label>
                    </div>
                </div>

                <div class="filter-group color-filter">
                    <label>Màu sắc</label>
                    <div class="checkbox-list">
                        <label><input type="checkbox" name="color" value="Red"> Đỏ</label>
                        <label><input type="checkbox" name="color" value="Yellow"> Vàng</label>
                        <label><input type="checkbox" name="color" value="Black"> Đen</label>
                        <label><input type="checkbox" name="color" value="Blue"> Xanh</label>
                    </div>
                </div>

                <div class="filter-group price-range-filter">
                    <label>Khoảng giá</label>
                    <div class="price-input-group">
                        <input type="text" placeholder="Từ" class="price-input">
                        <div class="price-divider">-</div>
                        <input type="text" placeholder="Đến" class="price-input">
                    </div>
                    <button class="btn-filter-apply">ÁP DỤNG</button>
                </div>
                <button class="btn-clear-filters">XÓA BỘ LỌC</button>
            </aside>

            <section class="result-box">

                <div class="sort-bar clean-sort-bar">
                    <span>Sắp xếp theo:</span>
                    <button class="sort-option active">Mới Nhất</button>

                    <div class="sort-option-dropdown">
                        <button class="sort-option dropdown-toggle">Giá <i class="fas fa-sort"></i></button>
                        <div class="dropdown-content">
                            <span class="sort-action" data-sort-order="asc">Tăng dần</span>
                            <span class="sort-action" data-sort-order="desc">Giảm dần</span>
                        </div>
                    </div>
                </div>

                <div class="car-list simple-product-grid">

                    <div class="car-item simple-product-item">
                        <div class="car-image-container">
                            <img src="image/vinfast.png" alt="VinFast Lux A2.0">
                        </div>
                        <h4 class="product-name">VinFast Lux A2.0</h4>
                        <p class="product-price">981.695.000 ₫</p>
                        <span class="product-sales-badge">Đã bán 15</span>
                    </div>

                    <div class="car-item simple-product-item">
                        <div class="car-image-container">
                            <img src="image/lamborghini.png" alt="Lamborghini Aventador SVJ Roadster">
                        </div>
                        <h4 class="product-name">Lamborghini Aventador SVJ Roadster</h4>
                        <p class="product-price">21.000.000.000 ₫</p>
                        <span class="product-sales-badge">Đã bán 15</span>
                    </div>

                </div>
            </section>
        </main>


       <jsp:include page="footer.jsp" />

    </body>
</html>
