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
                                        <label><input type="checkbox" name="brand" value="Audi" checked> Audi</label>
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
                            <small>Giá cao nhất: <fmt:formatNumber value="${maxPriceInSystem}" type="number"/> ₫</small>
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
                                <p>Kết quả tìm kiếm: <strong>${fn:escapeXml(searchKeyword)}</strong> 
                                    - Tìm thấy <strong>${fn:length(searchResults)}</strong> sản phẩm</p>
                                </c:when>
                                <c:when test="${not empty searchKeyword}">
                                <p>Không tìm thấy kết quả nào cho: <strong>${fn:escapeXml(searchKeyword)}</strong></p>
                            </c:when>
                            <c:otherwise>
                                <p>Tất cả sản phẩm - <strong>${fn:length(searchResults)}</strong> sản phẩm</p>
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
                    <div class="loading-spinner" id="loadingSpinner">
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
                                                <!-- SỬA ĐƯỜNG DẪN ẢNH - GIỐNG TRANG CHỦ -->
                                                <img src="${pageContext.request.contextPath}/uploads/${car.mainImageURL}" 
                                                     alt="${fn:escapeXml(car.carName)}"
                                                     onerror="this.src='${pageContext.request.contextPath}/uploads/default-car.jpg'">

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
            });
        </script>
    </body>
</html>