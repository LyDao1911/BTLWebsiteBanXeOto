<%@page contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>VELYRA AERO - Tìm kiếm xe hơi</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            /* ===== Trang tìm kiếm ===== */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #f5f5f5;
                color: #333;
                line-height: 1.6;
            }

            a {
                text-decoration: none;
                color: inherit;
            }

            /* ===== LAYOUT STYLES ===== */
            .search-page {
                display: flex;
                gap: 20px;
                max-width: 1200px;
                margin: 20px auto;
                padding: 0 15px;
            }

            /* ===== FILTER SIDEBAR ===== */
            .filter-box {
                width: 280px;
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                height: fit-content;
                position: sticky;
                top: 20px;
            }

            .filter-box h3 {
                margin-bottom: 20px;
                color: #333;
                border-bottom: 2px solid #e74c3c;
                padding-bottom: 10px;
                font-size: 1.2rem;
            }

            .filter-group {
                margin-bottom: 20px;
            }

            .filter-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #444;
            }

            /* Checkbox list styles */
            .checkbox-list {
                max-height: 150px;
                overflow-y: auto;
                padding: 10px;
                border: 1px solid #e0e0e0;
                border-radius: 4px;
                background: #f9f9f9;
            }

            .checkbox-list label {
                display: flex;
                align-items: center;
                margin-bottom: 8px;
                font-weight: normal;
                cursor: pointer;
                white-space: nowrap;
            }

            .checkbox-list input[type="checkbox"] {
                margin-right: 8px;
                flex-shrink: 0;
            }

            /* Price range styles */
            .price-inputs {
                display: flex;
                gap: 10px;
                margin-bottom: 8px;
            }

            .price-inputs input {
                flex: 1;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
            }

            .filter-group small {
                display: block;
                text-align: right;
                padding-right: 5px;
                font-size: 0.85em;
                color: #666;
            }

            /* Button styles */
            .btn-filter-apply {
                width: 100%;
                padding: 12px;
                background-color: #e74c3c;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 1em;
                margin-top: 10px;
                margin-bottom: 10px;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .btn-filter-apply:hover {
                background-color: #c0392b;
            }

            .reset-filters a {
                display: block;
                text-align: center;
                color: #333;
                text-decoration: underline;
                font-size: 0.9em;
                padding: 8px;
                border-radius: 4px;
                transition: background-color 0.3s;
            }

            .reset-filters a:hover {
                background-color: #f0f0f0;
            }

            /* ===== SORT BAR ===== */
            .sort-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding: 15px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .sort-options {
                display: flex;
                gap: 10px;
            }

            .sort-btn {
                padding: 8px 15px;
                background: white;
                border: 1px solid #ddd;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.3s;
                font-size: 0.9em;
            }

            .sort-btn:hover {
                background: #f0f0f0;
            }

            .sort-btn.active {
                background: #e74c3c;
                color: white;
                border-color: #e74c3c;
            }

            /* ===== RESULTS SECTION ===== */
            .result-box {
                flex: 1;
            }

            .search-info {
                margin-bottom: 15px;
                padding: 15px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .car-list {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }

            .car-item {
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                transition: transform 0.3s, box-shadow 0.3s;
            }

            .car-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.15);
            }

            .car-item a {
                display: block;
                text-decoration: none;
                color: inherit;
            }

            .car-image-container {
                position: relative;
                height: 180px;
                overflow: hidden;
            }

            .car-image-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s;
            }

            .car-item:hover .car-image-container img {
                transform: scale(1.05);
            }

            .car-badge {
                position: absolute;
                top: 10px;
                right: 10px;
                background: rgba(231, 76, 60, 0.9);
                color: white;
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 0.8rem;
                font-weight: bold;
            }

            .out-of-stock {
                opacity: 0.7;
            }

            .out-of-stock::after {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0,0,0,0.1);
            }

            .car-details {
                padding: 15px;
            }

            .product-brand {
                font-size: 0.9rem;
                color: #666;
                margin-bottom: 5px;
            }

            .product-name {
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: 10px;
                color: #333;
                line-height: 1.3;
            }

            .product-price {
                font-size: 1.2rem;
                font-weight: bold;
                color: #e74c3c;
                margin-bottom: 8px;
            }

            .product-color {
                font-size: 0.9rem;
                color: #666;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .product-color::before {
                content: "";
                display: inline-block;
                width: 12px;
                height: 12px;
                border-radius: 50%;
                border: 1px solid #ddd;
            }

            .product-color[data-color="Brown"]::before {
                background: #8B4513;
            }
            .product-color[data-color="Yellow"]::before {
                background: #FFD700;
            }
            .product-color[data-color="Black"]::before {
                background: #000000;
            }
            .product-color[data-color="White"]::before {
                background: #FFFFFF;
            }
            .product-color[data-color="Red"]::before {
                background: #FF0000;
            }
            .product-color[data-color="Blue"]::before {
                background: #0000FF;
            }
            .product-color[data-color="Silver"]::before {
                background: #C0C0C0;
            }

            .no-results {
                text-align: center;
                padding: 40px;
                color: #666;
                font-size: 1.1rem;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .loading-spinner {
                display: none;
                text-align: center;
                padding: 40px;
            }

            .loading-spinner i {
                font-size: 2rem;
                color: #e74c3c;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .search-page {
                    flex-direction: column;
                }
                .filter-box {
                    width: 100%;
                    position: static;
                }
                .sort-bar {
                    flex-direction: column;
                    gap: 10px;
                    align-items: flex-start;
                }
                .sort-options {
                    width: 100%;
                    justify-content: space-between;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <main>
            <div class="search-page">
                <!-- Filter Sidebar -->
                <aside class="filter-box">
                    <h3><i class="fas fa-filter"></i> BỘ LỌC TÌM KIẾM</h3>

                    <form action="${pageContext.request.contextPath}/TimKiemServlet" method="get" id="filterForm">
                        <!-- Keyword search -->
                        <div class="filter-group">
                            <label for="keyword"><i class="fas fa-search"></i> Từ khóa</label>
                            <input type="text" id="keyword" name="keyword" 
                                   value="${fn:escapeXml(param.keyword)}" 
                                   placeholder="Nhập tên xe, model..." 
                                   style="width:100%; padding:10px; border:1px solid #ddd; border-radius:4px;">
                        </div>

                        <!-- Brand filter with checkboxes -->
                        <div class="filter-group">
                            <label><i class="fas fa-car"></i> Thương hiệu</label>
                            <div class="checkbox-list">
                                <c:choose>
                                    <c:when test="${not empty availableBrands}">
                                        <c:forEach var="brand" items="${availableBrands}">
                                            <label>
                                                <input type="checkbox" name="brand" value="${fn:escapeXml(brand)}"
                                                       <c:if test="${fn:contains(selectedBrands, brand)}">checked</c:if>>
                                                ${fn:escapeXml(brand)}
                                            </label>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Default brands if none from database -->
                                        <label><input type="checkbox" name="brand" value="Audi"> Audi</label>
                                        <label><input type="checkbox" name="brand" value="BMW"> BMW</label>
                                        <label><input type="checkbox" name="brand" value="Mercedes"> Mercedes</label>
                                        <label><input type="checkbox" name="brand" value="Toyota"> Toyota</label>
                                        <label><input type="checkbox" name="brand" value="Honda"> Honda</label>
                                        </c:otherwise>
                                    </c:choose>
                            </div>
                        </div>

                        <!-- Color filter with checkboxes -->
                        <div class="filter-group">
                            <label><i class="fas fa-palette"></i> Màu sắc</label>
                            <div class="checkbox-list">
                                <c:choose>
                                    <c:when test="${not empty availableColors}">
                                        <c:forEach var="color" items="${availableColors}">
                                            <label>
                                                <input type="checkbox" name="color" value="${fn:escapeXml(color)}"
                                                       <c:if test="${fn:contains(selectedColors, color)}">checked</c:if>>
                                                ${fn:escapeXml(color)}
                                            </label>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Default colors if none from database -->
                                        <label><input type="checkbox" name="color" value="Brown"> Brown</label>
                                        <label><input type="checkbox" name="color" value="Yellow"> Yellow</label>
                                        <label><input type="checkbox" name="color" value="Black"> Black</label>
                                        <label><input type="checkbox" name="color" value="White"> White</label>
                                        <label><input type="checkbox" name="color" value="Red"> Red</label>
                                        <label><input type="checkbox" name="color" value="Blue"> Blue</label>
                                        <label><input type="checkbox" name="color" value="Silver"> Silver</label>
                                        </c:otherwise>
                                    </c:choose>
                            </div>
                        </div>

                        <!-- Price range filter -->
                        <div class="filter-group">
                            <label><i class="fas fa-tag"></i> Khoảng giá (VNĐ)</label>
                            <div class="price-inputs">
                                <input type="number" name="minPrice" placeholder="Giá thấp nhất" 
                                       value="${fn:escapeXml(param.minPrice)}" min="0">
                                <input type="number" name="maxPrice" placeholder="Giá cao nhất" 
                                       value="${fn:escapeXml(param.maxPrice)}" min="0">
                            </div>
                            <c:if test="${not empty maxPriceInSystem}">
                                <small>Giá cao nhất: <fmt:formatNumber value="${maxPriceInSystem}" type="number"/> ₫</small>
                            </c:if>
                        </div>

                        <!-- Hidden inputs for sorting -->
                        <input type="hidden" name="sortBy" id="sortBy" value="${fn:escapeXml(param.sortBy)}">
                        <input type="hidden" name="sortOrder" id="sortOrder" value="${fn:escapeXml(param.sortOrder)}">

                        <button type="submit" class="btn-filter-apply" id="applyFilter">
                            <i class="fas fa-filter"></i> ÁP DỤNG BỘ LỌC
                        </button>

                        <div class="reset-filters">
                            <a href="${pageContext.request.contextPath}/TimKiemServlet">
                                <i class="fas fa-redo"></i> Reset bộ lọc
                            </a>
                        </div>
                    </form>
                </aside>

                <!-- Results Section -->
                <section class="result-box">
                    <!-- Search Info -->
                    <div class="search-info">
                        <c:choose>
                            <c:when test="${not empty searchResults}">
                                <c:choose>
                                    <c:when test="${not empty searchKeyword}">
                                        <p>Kết quả tìm kiếm: <strong>${fn:escapeXml(searchKeyword)}</strong> 
                                            - Tìm thấy <strong>${fn:length(searchResults)}</strong> sản phẩm</p>
                                        </c:when>
                                        <c:otherwise>
                                        <p>Tất cả sản phẩm - Tìm thấy <strong>${fn:length(searchResults)}</strong> sản phẩm</p>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:when test="${not empty searchKeyword}">
                                <p>Không tìm thấy kết quả nào cho: <strong>${fn:escapeXml(searchKeyword)}</strong></p>
                            </c:when>
                            <c:otherwise>
                                <p>Vui lòng nhập từ khóa tìm kiếm hoặc chọn bộ lọc</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Sort Bar -->
                    <div class="sort-bar">
                        <div><strong>Sắp xếp theo:</strong></div>
                        <div class="sort-options">
                            <button class="sort-btn ${param.sortBy == 'newest' or empty param.sortBy ? 'active' : ''}" 
                                    data-sort="newest" data-order="desc">
                                <i class="fas fa-clock"></i> Mới nhất
                            </button>
                            <button class="sort-btn ${param.sortBy == 'price' and param.sortOrder == 'asc' ? 'active' : ''}" 
                                    data-sort="price" data-order="asc">
                                <i class="fas fa-arrow-up"></i> Giá: Tăng dần
                            </button>
                            <button class="sort-btn ${param.sortBy == 'price' and param.sortOrder == 'desc' ? 'active' : ''}" 
                                    data-sort="price" data-order="desc">
                                <i class="fas fa-arrow-down"></i> Giá: Giảm dần
                            </button>
                        </div>
                    </div>

                    <!-- Loading Spinner -->
                    <div class="loading-spinner" id="loadingSpinner" style="display: none;">
                        <i class="fas fa-spinner fa-spin"></i>
                        <p>Đang tải kết quả...</p>
                    </div>

                    <!-- Car List -->
                    <div class="car-list" id="carList">
                        <c:choose>
                            <c:when test="${empty searchResults}">
                                <div class="no-results">
                                    <i class="fas fa-search" style="font-size: 3rem; margin-bottom: 15px; color: #ddd;"></i>
                                    <h3>Không tìm thấy sản phẩm nào</h3>
                                    <p>Hãy thử điều chỉnh bộ lọc hoặc từ khóa tìm kiếm</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="car" items="${searchResults}">
                                    <a href="${pageContext.request.contextPath}/MotaServlet?carID=${car.carID}">
                                        <div class="car-item ${car.quantity <= 0 ? 'out-of-stock' : ''}">
                                            <div class="car-image-container">
                                                <!-- SỬA: Dùng đơn giản như trang chủ -->
                                                <img src="${pageContext.request.contextPath}/uploads/${car.mainImageURL}" 
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-car.jpg'">
                                                <c:if test="${car.quantity <= 0}">
                                                    <div class="car-badge">HẾT HÀNG</div>
                                                </c:if>
                                            </div>
                                            <div class="car-details">
                                                <div class="product-brand">${fn:escapeXml(car.brandName)}</div>
                                                <div class="product-name">${fn:escapeXml(car.carName)}</div>
                                                <div class="product-price">
                                                    <fmt:formatNumber value="${car.price}" type="number" /> ₫
                                                </div>
                                                <div class="product-color" data-color="${fn:escapeXml(car.color)}">
                                                    Màu: ${fn:escapeXml(car.color)}
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>
            </div>
        </main>

        <jsp:include page="footer.jsp" />

        <script>
            // Xử lý loading state khi áp dụng filter
            document.getElementById('filterForm').addEventListener('submit', function () {
                const applyBtn = document.getElementById('applyFilter');
                const loadingSpinner = document.getElementById('loadingSpinner');
                const carList = document.getElementById('carList');

                applyBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
                applyBtn.disabled = true;
                loadingSpinner.style.display = 'block';
                carList.style.opacity = '0.5';
            });

            // Xử lý sắp xếp
            document.querySelectorAll('.sort-btn').forEach(button => {
                button.addEventListener('click', function () {
                    const sortBy = this.getAttribute('data-sort');
                    const sortOrder = this.getAttribute('data-order');

                    // Update hidden inputs
                    document.getElementById('sortBy').value = sortBy;
                    document.getElementById('sortOrder').value = sortOrder;

                    // Hiển thị loading
                    const loadingSpinner = document.getElementById('loadingSpinner');
                    const carList = document.getElementById('carList');

                    loadingSpinner.style.display = 'block';
                    carList.style.opacity = '0.5';

                    // Submit form
                    document.getElementById('filterForm').submit();
                });
            });

            // Format price inputs
            document.querySelectorAll('input[name="minPrice"], input[name="maxPrice"]').forEach(input => {
                input.addEventListener('blur', function () {
                    if (this.value) {
                        const numericValue = this.value.replace(/\./g, '');
                        const formattedValue = new Intl.NumberFormat('vi-VN').format(numericValue);
                        this.value = formattedValue;
                    }
                });

                input.addEventListener('focus', function () {
                    this.value = this.value.replace(/\./g, '');
                });
            });

            // Auto-submit form when checkbox changes (optional)
            document.querySelectorAll('.checkbox-list input[type="checkbox"]').forEach(checkbox => {
                checkbox.addEventListener('change', function () {
                    // Optional: Auto-submit when filter changes
                    // document.getElementById('filterForm').submit();
                });
            });

            // Handle responsive layout
            function handleResponsive() {
                if (window.innerWidth <= 768) {
                    document.querySelector('.search-page').style.flexDirection = 'column';
                } else {
                    document.querySelector('.search-page').style.flexDirection = 'row';
                }
            }

            window.addEventListener('resize', handleResponsive);
            handleResponsive();

            // Initialize page
            document.addEventListener('DOMContentLoaded', function () {
                console.log('VELYRA AERO Search Page Loaded');

                // Ẩn loading spinner nếu đang hiển thị
                const loadingSpinner = document.getElementById('loadingSpinner');
                if (loadingSpinner) {
                    loadingSpinner.style.display = 'none';
                }

                const carList = document.getElementById('carList');
                if (carList) {
                    carList.style.opacity = '1';
                }
            });
        </script>
    </body>
</html>