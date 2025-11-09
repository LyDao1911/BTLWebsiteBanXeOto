<%-- 
    Document   : baocao
    Created on : Nov 7, 2025, 9:40:37 PM
    Author     : Hong Ly
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Báo Cáo Thống Kê</title>
    <link rel="stylesheet" href="style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
        /* CSS để chia 2 cột cho Bán Chạy / Bán Chậm */
        .report-columns {
            display: flex;
            gap: 30px;
            margin-top: 30px;
        }
        .report-column {
            flex: 1;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" /> 

    <main class="container">
        <div class="right-panel" style="flex: 1;"> 
            <h3 class="title">Báo Cáo Thống Kê</h3>
            
            <c:if test="${not empty errorMessage}">
                <p style="color: red; text-align: center; margin-bottom: 15px;">${errorMessage}</p>
            </c:if>

            <form action="ReportServlet" method="GET" style="margin-bottom: 20px; display: flex; gap: 15px; align-items: center; background: #f9f9f9; padding: 15px; border-radius: 8px;">
                <div class="form-group" style="margin: 0;">
                    <label>Từ ngày:</label>
                    <input type="date" name="startDate" value="${startDate}" class="input" required>
                </div>
                <div class="form-group" style="margin: 0;">
                    <label>Đến ngày:</label>
                    <input type="date" name="endDate" value="${endDate}" class="input" required>
                </div>
                <button type="submit" class="btn btn-success">📊 Xem Báo Cáo</button>
            </form>

            <hr>

            <h3 class="title">Doanh Thu & Lợi Nhuận (Theo Ngày)</h3>
            <p style="font-style: italic; margin-top: -10px; margin-bottom: 15px;">
                *Lưu ý: Giá vốn được tính bằng giá nhập trung bình của sản phẩm.*
            </p>
            <table class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>Ngày</th>
                        <th>Doanh Thu (Bán)</th>
                        <th>Giá Vốn (Nhập TB)</th>
                        <th>Lợi Nhuận</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="tongDoanhThu" value="0" />
                    <c:set var="tongGiaVon" value="0" />
                    <c:forEach var="r" items="${reportList}">
                        <tr>
                            <td><fmt:formatDate value="${r.reportDate}" pattern="dd/MM/yyyy"/></td>
                            <td><fmt:formatNumber value="${r.totalRevenue}" type="number" groupingUsed="true"/> VNĐ</td>
                            <td><fmt:formatNumber value="${r.totalCost}" type="number" groupingUsed="true"/> VNĐ</td>
                            <td style="font-weight: bold; color: ${r.totalProfit > 0 ? 'green' : 'red'};">
                                <fmt:formatNumber value="${r.totalProfit}" type="number" groupingUsed="true"/> VNĐ
                            </td>
                        </tr>
                        <c:set var="tongDoanhThu" value="${tongDoanhThu + r.totalRevenue}" />
                        <c:set var="tongGiaVon" value="${tongGiaVon + r.totalCost}" />
                    </c:forEach>
                    <c:if test="${empty reportList}">
                        <tr><td colspan="4">Không có dữ liệu bán hàng cho khoảng thời gian này.</td></tr>
                    </c:if>
                </tbody>
                <tfoot style="background: #eee; font-weight: bold; font-size: 1.1em;">
                    <c:set var="tongLoiNhuan" value="${tongDoanhThu - tongGiaVon}" />
                    <tr>
                        <td>TỔNG CỘNG</td>
                        <td><fmt:formatNumber value="${tongDoanhThu}" type="number" groupingUsed="true"/> VNĐ</td>
                        <td><fmt:formatNumber value="${tongGiaVon}" type="number" groupingUsed="true"/> VNĐ</td>
                        <td style="color: ${tongLoiNhuan > 0 ? 'green' : 'red'};">
                            <fmt:formatNumber value="${tongLoiNhuan}" type="number" groupingUsed="true"/> VNĐ
                        </td>
                    </tr>
                </tfoot>
            </table>

            <h3 class="title" style="margin-top: 30px;">Biểu Đồ Lợi Nhuận</h3>
            <canvas id="profitChart" style="max-height: 400px; width: 100%;"></canvas>
            

[Image of a line chart showing Revenue, Cost, and Profit over time]


            <div class="report-columns">
                <div class="report-column">
                    <h3 class="title">Top 5 Bán Chạy</h3>
                    <table class="table table-bordered table-hover">
                        <thead class="table-dark">
                            <tr><th>Tên Xe</th><th>Đã Bán (chiếc)</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${bestSellingList}">
                                <tr>
                                    <td>${item.carName}</td>
                                    <td>${item.totalSold}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="report-column">
                    <h3 class="title">Top 5 Bán Chậm/Không Bán Được</h3>
                    <table class="table table-bordered table-hover">
                        <thead class="table-dark">
                            <tr><th>Tên Xe</th><th>Đã Bán (chiếc)</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${worstSellingList}">
                                <tr>
                                    <td>${item.carName}</td>
                                    <td style="${item.totalSold == 0 ? 'color: red;' : ''}">${item.totalSold}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('profitChart');
            if (ctx && ${not empty reportList}) { // Chỉ vẽ nếu có dữ liệu
                new Chart(ctx, {
                    type: 'line', 
                    data: {
                        labels: [
                            <c:forEach var="r" items="${reportList}" varStatus="loop">
                                "<fmt:formatDate value="${r.reportDate}" pattern="dd/MM"/>"<c:if test="${!loop.last}">,</c:if>
                            </c:forEach>
                        ],
                        datasets: [
                            {
                                label: 'Doanh Thu',
                                data: [ <c:forEach var="r" items="${reportList}" varStatus="loop">${r.totalRevenue}<c:if test="${!loop.last}">,</c:if></c:forEach> ],
                                borderColor: 'green',
                                tension: 0.1
                            },
                            {
                                label: 'Giá Vốn (TB)',
                                data: [ <c:forEach var="r" items="${reportList}" varStatus="loop">${r.totalCost}<c:if test="${!loop.last}">,</c:if></c:forEach> ],
                                borderColor: 'red',
                                tension: 0.1
                            },
                            {
                                label: 'Lợi Nhuận',
                                data: [ <c:forEach var="r" items="${reportList}" varStatus="loop">${r.totalProfit}<c:if test="${!loop.last}">,</c:if></c:forEach> ],
                                borderColor: 'blue',
                                borderWidth: 3,
                                tension: 0.1
                            }
                        ]
                    }
                });
            }
        });
    </script>
    
    <jsp:include page="footer.jsp" />
</body>
</html>
