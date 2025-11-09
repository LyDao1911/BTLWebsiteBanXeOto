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
            /* ===== RESET & BASE STYLES ===== */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #f8f9fa;
                color: #333;
                line-height: 1.6;
                padding-top: 80px;
            }

            a {
                text-decoration: none;
                color: inherit;
            }

            /* ===== LAYOUT STYLES ===== */
            .search-page {
                display: flex;
                gap: 25px;
                max-width: 1400px;
                margin: 25px auto;
                padding: 0 20px;
                align-items: flex-start;
            }

            /* ===== FILTER SIDEBAR ===== */
            .filter-box {
                width: 300px;
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 15px rgba(0,0,0,0.06);
                height: fit-content;
                position: sticky;
                top: 90px;
                border: 1px solid #eaeaea;
            }

            .filter-box h3 {
                margin-bottom: 20px;
                color: #2c3e50;
                border-bottom: 2px solid #e74c3c;
                padding-bottom: 10px;
                font-size: 1.2rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .filter-group {
                margin-bottom: 20px;
            }

            .filter-group label {
                display: block;
                margin-bottom: 10px;
                font-weight: 600;
                color: #2c3e50;
                font-size: 0.95rem;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            /* Keyword input */
            #keyword {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #e0e0e0;
                border-radius: 6px;
                font-size: 0.9rem;
                transition: all 0.3s ease;
                background: #fafafa;
            }

            #keyword:focus {
                outline: none;
                border-color: #e74c3c;
                background: white;
                box-shadow: 0 0 0 2px rgba(231, 76, 60, 0.1);
            }

            /* Checkbox list styles */
            .checkbox-list {
                max-height: 180px;
                overflow-y: auto;
                padding: 12px;
                border: 1px solid #eaeaea;
                border-radius: 6px;
                background: #fafafa;
                scrollbar-width: thin;
                scrollbar-color: #e74c3c #f0f0f0;
            }

            .checkbox-list::-webkit-scrollbar {
                width: 5px;
            }

            .checkbox-list::-webkit-scrollbar-track {
                background: #f0f0f0;
                border-radius: 3px;
            }

            .checkbox-list::-webkit-scrollbar-thumb {
                background: #e74c3c;
                border-radius: 3px;
            }

            .checkbox-list label {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
                font-weight: 500;
                cursor: pointer;
                white-space: nowrap;
                padding: 4px 0;
                transition: color 0.3s ease;
                font-size: 0.9rem;
            }

            .checkbox-list label:hover {
                color: #e74c3c;
            }

            .checkbox-list input[type="checkbox"] {
                margin-right: 10px;
                flex-shrink: 0;
                width: 16px;
                height: 16px;
                accent-color: #e74c3c;
                cursor: pointer;
            }

            /* Price range styles - FIXED ALIGNMENT */
            .price-inputs {
                display: flex;
                gap: 10px;
                margin-bottom: 8px;
                align-items: center;
            }

            .price-inputs input {
                flex: 1;
                padding: 10px;
                border: 1px solid #e0e0e0;
                border-radius: 6px;
                font-size: 0.9rem;
                transition: all 0.3s ease;
                background: #fafafa;
                height: 42px;
                min-width: 0;
            }

            .price-inputs input:focus {
                outline: none;
                border-color: #e74c3c;
                background: white;
                box-shadow: 0 0 0 2px rgba(231, 76, 60, 0.1);
            }

            .price-inputs::before {
                content: "-";
                color: #7f8c8d;
                font-weight: 600;
                flex-shrink: 0;
            }

            .filter-group small {
                display: block;
                text-align: right;
                padding-right: 5px;
                font-size: 0.8em;
                color: #7f8c8d;
                font-weight: 500;
                margin-top: 6px;
            }

            /* Button styles */
            .btn-filter-apply {
                width: 100%;
                padding: 12px;
                background: linear-gradient(135deg, #e74c3c, #c0392b);
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 1rem;
                font-weight: 600;
                margin-top: 12px;
                margin-bottom: 12px;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                box-shadow: 0 2px 10px rgba(231, 76, 60, 0.3);
            }

            .btn-filter-apply:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 15px rgba(231, 76, 60, 0.4);
                background: linear-gradient(135deg, #c0392b, #a93226);
            }

            .reset-filters a {
                display: block;
                text-align: center;
                color: #7f8c8d;
                text-decoration: none;
                font-size: 0.9em;
                padding: 10px;
                border-radius: 6px;
                transition: all 0.3s ease;
                border: 1px solid #e0e0e0;
                font-weight: 500;
            }

            .reset-filters a:hover {
                background-color: #f8f9fa;
                border-color: #e74c3c;
                color: #e74c3c;
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
                box-shadow: 0 2px 10px rgba(0,0,0,0.06);
                border: 1px solid #eaeaea;
            }

            .sort-bar > div:first-child {
                font-weight: 600;
                color: #2c3e50;
                font-size: 1rem;
            }

            .sort-options {
                display: flex;
                gap: 10px;
            }

            .sort-btn {
                padding: 10px 16px;
                background: white;
                border: 1px solid #e0e0e0;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 0.9rem;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .sort-btn:hover {
                background: #f8f9fa;
                border-color: #bdc3c7;
            }

            .sort-btn.active {
                background: #e74c3c;
                color: white;
                border-color: #e74c3c;
                box-shadow: 0 2px 10px rgba(231, 76, 60, 0.3);
            }

            /* ===== RESULTS SECTION ===== */
            .result-box {
                flex: 1;
                min-width: 0;
            }

            .search-info {
                margin-bottom: 15px;
                padding: 15px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.06);
                border: 1px solid #eaeaea;
                font-size: 1rem;
                color: #2c3e50;
            }

            .search-info strong {
                color: #e74c3c;
            }

            /* ===== CARD SẢN PHẨM NHỎ GỌN ===== */
            .car-list {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                gap: 18px;
            }

            .car-item {
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                transition: all 0.3s ease;
                border: 1px solid #eaeaea;
                position: relative;
            }

            .car-item:hover {
                transform: translateY(-3px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.12);
            }

            .car-item a {
                display: block;
                text-decoration: none;
                color: inherit;
            }

            /* Ảnh nhỏ gọn */
            .car-image-container {
                position: relative;
                height: 120px;
                overflow: hidden;
                background-color: #f8f9fa;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .car-image-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s ease;
            }

            .car-item:hover .car-image-container img {
                transform: scale(1.05);
            }

            /* Placeholder khi ảnh không load được */
            .car-image-container:after {
                content: "No Image";
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                color: #999;
                font-size: 12px;
                display: none;
            }

            .car-image-container img[src=""]:after,
            .car-image-container:not(:has(img[src])):after {
                display: block;
            }

            .car-badge {
                position: absolute;
                top: 6px;
                right: 6px;
                background: rgba(231, 76, 60, 0.95);
                color: white;
                padding: 3px 6px;
                border-radius: 4px;
                font-size: 0.7rem;
                font-weight: 600;
            }

            .out-of-stock {
                opacity: 0.8;
            }

            .out-of-stock::after {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0,0,0,0.05);
            }

            /* Nội dung card nhỏ gọn */
            .car-details {
                padding: 12px;
            }

            .product-brand {
                font-size: 0.8rem;
                color: #7f8c8d;
                margin-bottom: 5px;
                font-weight: 500;
            }

            .product-name {
                font-size: 0.95rem;
                font-weight: 600;
                margin-bottom: 8px;
                color: #2c3e50;
                line-height: 1.3;
                height: 2.4em;
                overflow: hidden;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
            }

            .product-price {
                font-size: 1rem;
                font-weight: 700;
                color: #e74c3c;
                margin-bottom: 6px;
            }

            .product-color {
                font-size: 0.8rem;
                color: #7f8c8d;
                display: flex;
                align-items: center;
                gap: 5px;
                font-weight: 500;
            }

            .product-color::before {
                content: "";
                display: inline-block;
                width: 12px;
                height: 12px;
                border-radius: 50%;
                border: 1px solid #e0e0e0;
            }

            .product-color[data-color="Brown"]::before {
                background: #8B4513;
            }
            .product-color[data-color="Yellow"]::before {
                background: #FFD700;
            }
            .product-color[data-color="Black"]::before {
                background: #2c3e50;
            }
            .product-color[data-color="White"]::before {
                background: #ecf0f1;
                border-color: #bdc3c7;
            }
            .product-color[data-color="Red"]::before {
                background: #e74c3c;
            }
            .product-color[data-color="Blue"]::before {
                background: #3498db;
            }
            .product-color[data-color="Silver"]::before {
                background: #bdc3c7;
            }
            .product-color[data-color="Gray"]::before {
                background: #7f8c8d;
            }
            .product-color[data-color="Green"]::before {
                background: #27ae60;
            }
            .product-color[data-color="Orange"]::before {
                background: #f39c12;
            }

            .no-results {
                text-align: center;
                padding: 50px 30px;
                color: #7f8c8d;
                font-size: 1.1rem;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.06);
                border: 1px solid #eaeaea;
                grid-column: 1 / -1;
            }

            .no-results i {
                font-size: 3rem;
                margin-bottom: 15px;
                color: #e0e0e0;
            }

            .no-results h3 {
                color: #2c3e50;
                margin-bottom: 10px;
                font-size: 1.3rem;
            }

            .loading-spinner {
                display: none;
                text-align: center;
                padding: 50px 30px;
                grid-column: 1 / -1;
            }

            .loading-spinner i {
                font-size: 2.5rem;
                color: #e74c3c;
                margin-bottom: 12px;
            }

            .loading-spinner p {
                color: #7f8c8d;
                font-size: 1rem;
            }

            /* ===== RESPONSIVE DESIGN ===== */
            @media (max-width: 1200px) {
                .search-page {
                    max-width: 100%;
                    padding: 0 15px;
                }

                .car-list {
                    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                    gap: 15px;
                }
            }

            @media (max-width: 992px) {
                .search-page {
                    flex-direction: column;
                    gap: 18px;
                }

                .filter-box {
                    width: 100%;
                    position: static;
                }

                .car-list {
                    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                }
            }

            @media (max-width: 768px) {
                body {
                    padding-top: 70px;
                }

                .search-page {
                    margin: 18px auto;
                    padding: 0 10px;
                }

                .filter-box {
                    padding: 18px;
                }

                .sort-bar {
                    flex-direction: column;
                    gap: 12px;
                    align-items: flex-start;
                    padding: 12px;
                }

                .sort-options {
                    width: 100%;
                    flex-wrap: wrap;
                    gap: 6px;
                }

                .sort-btn {
                    flex: 1;
                    min-width: 130px;
                    justify-content: center;
                    padding: 8px 12px;
                    font-size: 0.85rem;
                }

                .car-list {
                    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                    gap: 12px;
                }

                .car-image-container {
                    height: 110px;
                }

                .price-inputs {
                    flex-direction: row;
                    gap: 8px;
                }

                .price-inputs::before {
                    content: "-";
                    margin: 0 4px;
                }
            }

            @media (max-width: 480px) {
                .filter-box {
                    padding: 15px;
                }

                .price-inputs {
                    flex-direction: column;
                    gap: 8px;
                }

                .price-inputs::before {
                    display: none;
                }

                .sort-btn {
                    min-width: 110px;
                    font-size: 0.8rem;
                }

                .product-name {
                    font-size: 0.9rem;
                }

                .product-price {
                    font-size: 0.95rem;
                }

                .car-image-container {
                    height: 100px;
                }

                .car-list {
                    grid-template-columns: 1fr;
                    gap: 10px;
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
                                   placeholder="Nhập tên xe, model..." >
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
                                <input type="number" name="minPrice" placeholder="Từ" 
                                       value="${fn:escapeXml(param.minPrice)}" min="0">
                                <input type="number" name="maxPrice" placeholder="Đến" 
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
                    <!-- Car List - CÁCH ĐƠN GIẢN -->
                    <div class="car-list" id="carList">
                        <c:choose>
                            <c:when test="${empty searchResults}">
                                <div class="no-results">
                                    <i class="fas fa-search"></i>
                                    <h3>Không tìm thấy sản phẩm nào</h3>
                                    <p>Hãy thử điều chỉnh bộ lọc hoặc từ khóa tìm kiếm</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="car" items="${searchResults}">
                                    <a href="${pageContext.request.contextPath}/MotaServlet?carID=${car.carID}">
                                        <div class="car-item ${car.quantity <= 0 ? 'out-of-stock' : ''}">
                                            <div class="car-image-container">
                                                <%-- ⭐ CÁCH ĐƠN GIẢN: Logic xử lý ảnh trực tiếp --%>
                                                <c:choose>
                                                    <c:when test="${empty car.mainImageURL}">
                                                        <%-- Ảnh mặc định --%>
                                                        <img src="${pageContext.request.contextPath}/image/default-car.jpg" 
                                                             alt="${fn:escapeXml(car.carName)}">
                                                    </c:when>
                                                    <c:when test="${car.mainImageURL.startsWith('http') or car.mainImageURL.startsWith('/')}">
                                                        <%-- Ảnh từ URL tuyệt đối --%>
                                                        <img src="${car.mainImageURL}" 
                                                             alt="${fn:escapeXml(car.carName)}"
                                                             onerror="this.src='${pageContext.request.contextPath}/image/default-car.jpg'">
                                                    </c:when>
                                                    <c:when test="${car.mainImageURL.startsWith('uploads/') or car.mainImageURL.startsWith('image/')}">
                                                        <%-- Ảnh có đường dẫn tương đối đúng --%>
                                                        <img src="${pageContext.request.contextPath}/${car.mainImageURL}" 
                                                             alt="${fn:escapeXml(car.carName)}"
                                                             onerror="this.src='${pageContext.request.contextPath}/image/default-car.jpg'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <%-- Chỉ có tên file - thêm uploads/ --%>
                                                        <img src="${pageContext.request.contextPath}/uploads/${car.mainImageURL}" 
                                                             alt="${fn:escapeXml(car.carName)}"
                                                             onerror="this.src='${pageContext.request.contextPath}/image/default-car.jpg'">
                                                    </c:otherwise>
                                                </c:choose>

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
            document.getElementById('filterForm').addEventListener('submit', function () {
                const applyBtn = document.getElementById('applyFilter');
                const loadingSpinner = document.getElementById('loadingSpinner');
                const carList = document.getElementById('carList');

                applyBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
                applyBtn.disabled = true;
                loadingSpinner.style.display = 'block';
                carList.style.opacity = '0.5';
            });

            document.querySelectorAll('.sort-btn').forEach(button => {
                button.addEventListener('click', function () {
                    const sortBy = this.getAttribute('data-sort');
                    const sortOrder = this.getAttribute('data-order');

                    document.getElementById('sortBy').value = sortBy;
                    document.getElementById('sortOrder').value = sortOrder;

                    const loadingSpinner = document.getElementById('loadingSpinner');
                    const carList = document.getElementById('carList');

                    loadingSpinner.style.display = 'block';
                    carList.style.opacity = '0.5';

                    document.getElementById('filterForm').submit();
                });
            });

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

            document.addEventListener('DOMContentLoaded', function () {
                console.log('VELYRA AERO Search Page Loaded');

                // Debug: log thông tin ảnh
            <c:if test="${not empty searchResults}">
                console.log('Search results found:', ${fn:length(searchResults)});
                <c:forEach var="car" items="${searchResults}" varStatus="status">
                console.log('Car ${status.index + 1}:', '${car.carName}', 'Image URL:', '${car.mainImageURL}');
                </c:forEach>
            </c:if>

                const loadingSpinner = document.getElementById('loadingSpinner');
                if (loadingSpinner) {
                    loadingSpinner.style.display = 'none';
                }

                const carList = document.getElementById('carList');
                if (carList) {
                    carList.style.opacity = '1';
                }

                // Debug: kiểm tra ảnh load
                const images = document.querySelectorAll('.car-image-container img');
                images.forEach((img, index) => {
                    img.addEventListener('load', function () {
                        console.log('Image loaded successfully:', this.src);
                    });
                    img.addEventListener('error', function () {
                        console.log('Image failed to load:', this.src);
                    });
                });
            });
        </script>
    </body>
</html>