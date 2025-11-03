<%-- 
    Document   : sanpham
    Created on : Oct 19, 2025, 9:06:32 PM
    Author     : Admin
--%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Car" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý xe - Velyra Aero</title>
    <link rel="stylesheet" href="style.css" />
    <!-- Font Awesome --> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>

   <jsp:include page="header.jsp" />
    <main class="admin-page-container container">

        <div class="right-panel">
            <h3 class="text-center mb-4">Danh sách sản phẩm</h3>

            <table class="table table-bordered table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Chọn</th> <%-- Cột mới: Checkbox --%>
                        <th>CarID</th>
                        <th>CarName</th>
                        <th>BrandID</th>
                        <th>Price</th>
                        <th>Color</th>
                        <th>Quantity</th>
                        <th>Description</th>
                        <th>Status</th>

                    </tr>
                </thead>

                <tbody id="carTableBody">
                    <%
                        List<model.Car> list = (List<model.Car>) request.getAttribute("carList");
                        if (list != null && !list.isEmpty()) {
                            for (model.Car c : list) {
                    %>
                    <tr data-id="<%= c.getCarID()%>" data-name="<%= c.getCarName()%>">
                        <td><input type="checkbox" name="selectCar" value="<%= c.getCarID()%>"></td>
                        <td><%= c.getCarID()%></td>
                        <td><%= c.getCarName()%></td>
                        <td><%= c.getBrandID()%></td>
                        <td><%= c.getPrice()%></td>
                        <td><%= c.getColor()%></td>
                        <td><%= c.getQuantity()%></td>
                        <td><%= c.getDescription()%></td>
                        <td><%= c.getStatus()%></td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr><td colspan="9" class="text-center">Không có sản phẩm nào</td></tr>
                    <%
                        }
                    %>
                </tbody>

            </table>

            <div class="table-action-buttons">
                <button type="button" class="btn btn-success" id="btnAdd">➕ Thêm</button>
                <button type="button" class="btn btn-warning" id="btnEdit">✏️ Sửa</button>
                <button type="button" class="btn btn-danger" id="btnDelete">🗑️ Xóa</button>
            </div>
        </div>
    </main>

    <script>
        let selectedCarId = null; // Biến để lưu trữ ID của dòng được chọn

        // === XỬ LÝ CHỌN CHỈ MỘT DÒNG DUY NHẤT VỚI CHECKBOX ===
        document.querySelectorAll('#carTableBody input[type="checkbox"]').forEach(checkbox => {
            checkbox.addEventListener('change', function () {
                const currentRow = this.closest('tr');

                if (this.checked) {
                    // 1. Bỏ chọn tất cả các checkbox khác
                    document.querySelectorAll('#carTableBody input[type="checkbox"]').forEach(otherCheckbox => {
                        if (otherCheckbox !== this) {
                            otherCheckbox.checked = false;
                            otherCheckbox.closest('tr').classList.remove('selected-row');
                        }
                    });

                    // 2. Cập nhật biến toàn cục và highlight dòng hiện tại
                    selectedCarId = this.value; // value của checkbox chính là CarID
                    currentRow.classList.add('selected-row');
                } else {
                    // Nếu bỏ check chính nó, reset biến và bỏ highlight
                    selectedCarId = null;
                    currentRow.classList.remove('selected-row');
                }
            });
        });

        // === TÙY CHỌN: CHO PHÉP CLICK VÀO DÒNG CŨNG TỰ ĐỘNG CHECK BOX ===
        document.querySelectorAll('#carTableBody tr').forEach(row => {
            row.addEventListener('click', function (e) {
                const checkbox = this.querySelector('input[type="checkbox"]');

                // Chỉ check/uncheck nếu click không phải vào chính checkbox đó
                if (e.target !== checkbox) {
                    checkbox.checked = !checkbox.checked;
                    // Kích hoạt sự kiện 'change' để chạy logic chọn duy nhất
                    checkbox.dispatchEvent(new Event('change'));
                } else {
                    // Nếu click trực tiếp vào checkbox, vẫn chạy logic change
                    checkbox.dispatchEvent(new Event('change'));
                }
            });
        });


        // === XỬ LÝ NÚT THAO TÁC DƯỚI BẢNG ===

        // 1. Nút THÊM: Chuyển hướng đến trang thêm.jsp
        document.getElementById('btnAdd').addEventListener('click', function () {
            window.location.href = 'ThemSanPhamServlet';
        });

        // 2. Nút SỬA: Chuyển hướng đến trang sua.jsp với CarID
        document.getElementById('btnEdit').addEventListener('click', function () {
            if (selectedCarId) {

                window.location.href = 'SuaXeServlet?carId=' + selectedCarId;
            } else {
                alert('Vui lòng chọn một sản phẩm trong bảng (tick vào checkbox) trước khi nhấn Sửa.');
            }
        });


// 3. Nút XOÁ: Yêu cầu xác nhận và thực hiện xóa
        document.getElementById('btnDelete').addEventListener('click', function () {
            // ... code kiểm tra selectedCarId ...

            if (selectedCarId) {
                // ... code lấy carName và hiển thị confirm ...

                if (confirm(`Bạn có chắc chắn muốn xóa sản phẩm ID ${selectedCarId} (${carName}) không?`)) {
                   window.location.href = '${pageContext.request.contextPath}/XoaXeServlet?carId=' + selectedCarId;
                }
            } else {
                alert('Vui lòng chọn một sản phẩm trong bảng (tick vào checkbox) trước khi nhấn Xóa.');
            }
        });

    </script>
    <jsp:include page="footer.jsp" />

</body>
</html>
