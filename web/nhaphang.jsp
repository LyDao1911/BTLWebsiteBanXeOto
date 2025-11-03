<%-- 
    Document   : nhaphang
    Created on : Nov 2, 2025
    Author     : Hong Ly
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tạo Phiếu Nhập Hàng</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>
        <jsp:include page="header.jsp" /> 

        <div class="container">
            <h2 class="title">Tạo Phiếu Nhập Hàng</h2>

            <c:if test="${not empty errorMessage}">
                <p style="color: red; text-align: center; margin-bottom: 15px;">${errorMessage}</p>
            </c:if>

            <form action="NhapHangServlet" method="POST" id="purchaseForm">
                <div class="top">
                    <div class="left">
                        <label class="label">Nhà Cung Cấp</label>
                        <select name="supplierID" class="input" required>
                            <option value="">-- Chọn nhà cung cấp --</option>
                            <c:forEach var="supplier" items="${supplierList}">
                                <option value="${supplier.supplierID}">
                                    ${supplier.supplierName}
                                </option>
                            </c:forEach>
                        </select>

                        <label class="label">Ngày Nhập</label>
                        <input type="text" class="input" value="Hôm nay (Tự động)" disabled>

                        <label class="label" style="margin-top: 20px;">Tổng Tiền Hóa Đơn</label>
                        <h3 id="totalAmountDisplay" style="color: #d60000; font-size: 28px;">0 VNĐ</h3>
                        <input type="hidden" name="totalAmount" id="totalAmountInput" value="0">
                    </div>

                    <div class="right">
                        <label class="label">Chọn Sản Phẩm (Xe)</label>
                        <select id="carSelector" class="input">
                            <option value="">-- Chọn xe để thêm vào phiếu --</option>
                            <c:forEach var="car" items="${carList}">
                                <option value="${car.carID}"
                                        data-name="${fn:escapeXml(car.carName)}"
                                        data-price="${car.price}"
                                        data-quantity="${car.quantity}">
                                    ${car.carName}
                                </option>
                            </c:forEach>
                        </select>

                        <label class="label">Số Lượng Nhập</label>
                        <input type="number" id="itemQuantity" class="input" value="1" min="1">

                        <label class="label">Đơn Giá Nhập (VNĐ)</label>
                        <input type="text" id="itemImportPrice" class="input" placeholder="Nhập giá nhập (ví dụ: 500000000)">

                        <button type="button" class="btn btn-success" id="btnAddItem" style="margin-top: 10px;">➕ Thêm vào Phiếu</button>
                    </div>
                </div>

                <hr style="margin: 30px 0;">

                <h3 class="title">Chi Tiết Phiếu Nhập</h3>
                <table class="table table-bordered table-hover" id="invoiceDetailTable">
                    <thead class="table-dark">
                        <tr>
                            <th>Tên Xe</th>
                            <th>Số Lượng</th>
                            <th>Đơn Giá Nhập (VNĐ)</th>
                            <th>Thành Tiền (Tạm tính)</th>
                            <th>Xóa</th>
                        </tr>
                    </thead>
                    <tbody id="invoiceDetailBody">
                    </tbody>
                </table>

                <button type="submit" class="btn-submit" style="margin-top: 20px;">💾 LƯU HÓA ĐƠN NHẬP</button>
            </form>
        </div>

        <script>
            // ✅ Thêm sản phẩm vào phiếu nhập
            // ✅ Thêm sản phẩm vào phiếu nhập
            // ✅ Thêm sản phẩm vào phiếu nhập
            // ✅ Thêm sản phẩm vào phiếu nhập (PHIÊN BẢN SỬA LỖI CACHE)
            document.getElementById('btnAddItem').addEventListener('click', function () {
                const carSelector = document.getElementById('carSelector');
                const selectedOption = carSelector.options[carSelector.selectedIndex];
                const carId = selectedOption.value;
                const carName = selectedOption.getAttribute('data-name');
                const quantity = parseInt(document.getElementById('itemQuantity').value.trim());
                const importPriceStr = document.getElementById('itemImportPrice').value.trim().replace(/\D/g, '');
                const importPrice = parseInt(importPriceStr);

                // 1. Kiểm tra dữ liệu (Vẫn như cũ)
                if (!carId || isNaN(quantity) || isNaN(importPrice) || quantity <= 0 || importPrice <= 0) {
                    alert('⚠️ Vui lòng chọn xe, nhập số lượng và đơn giá nhập hợp lệ!');
                    return;
                }

                const subtotal = quantity * importPrice;
                const tableBody = document.getElementById('invoiceDetailBody');
                const formatter = new Intl.NumberFormat('vi-VN');

                // ========================================================
                // ✅ BẮT ĐẦU: Code thêm hàng mới (thay thế insertAdjacentHTML)
                // ========================================================
                try {
                    // Tạo 1 hàng mới
                    const newRow = document.createElement('tr');
                    newRow.setAttribute('data-subtotal', subtotal);

                    // Ô 1: Tên xe + input ẩn
                    const cellName = document.createElement('td');
                    cellName.textContent = carName; // Thêm tên xe
                    cellName.innerHTML += `<input type="hidden" name="carId" value="${carId}">`;
                    cellName.innerHTML += `<input type="hidden" name="quantity" value="${quantity}">`;
                    cellName.innerHTML += `<input type="hidden" name="importPrice" value="${importPrice}">`;

                    // Ô 2: Số lượng
                    const cellQty = document.createElement('td');
                    cellQty.textContent = formatter.format(quantity);

                    // Ô 3: Đơn giá
                    const cellPrice = document.createElement('td');
                    cellPrice.textContent = formatter.format(importPrice);

                    // Ô 4: Thành tiền
                    const cellSubtotal = document.createElement('td');
                    cellSubtotal.textContent = formatter.format(subtotal);

                    // Ô 5: Nút Xóa
                    const cellDelete = document.createElement('td');
                    cellDelete.innerHTML = '<button type="button" class="btn btn-danger btn-sm" onclick="removeItem(this)">Xóa</button>';

                    // Gắn tất cả ô vào hàng
                    newRow.appendChild(cellName);
                    newRow.appendChild(cellQty);
                    newRow.appendChild(cellPrice);
                    newRow.appendChild(cellSubtotal);
                    newRow.appendChild(cellDelete);

                    // Gắn hàng vào bảng
                    tableBody.appendChild(newRow);

                } catch (e) {
                    // Nếu có bất kỳ lỗi nào, báo cho chúng ta biết
                    console.error("LỖI KHI TẠO HÀNG (createElement):", e);
                    alert("Đã xảy ra lỗi khi tạo hàng: " + e.message);
                    return;
                }
                // ========================================================
                // ✅ KẾT THÚC: Code thêm hàng mới
                // ========================================================


                updateTotal(); // Cập nhật tổng tiền

                // Reset input
                carSelector.selectedIndex = 0;
                document.getElementById('itemQuantity').value = 1;
                document.getElementById('itemImportPrice').value = '';
            });

            // ✅ Xóa dòng
            function removeItem(button) {
                button.closest('tr').remove();
                updateTotal();
            }

            // ✅ Cập nhật tổng tiền
            function updateTotal() {
                let total = 0;
                document.querySelectorAll('#invoiceDetailBody tr').forEach(row => {
                    const sub = parseFloat(row.getAttribute('data-subtotal'));
                    if (!isNaN(sub))
                        total += sub;
                });
                const formatter = new Intl.NumberFormat('vi-VN');
                document.getElementById('totalAmountDisplay').innerText = formatter.format(total) + " VNĐ";
                document.getElementById('totalAmountInput').value = total;
            }

            // ✅ Format tiền khi nhập
            document.getElementById('itemImportPrice').addEventListener('input', (e) => {
                let value = e.target.value.replace(/\D/g, '');
                e.target.value = value.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
            });

            // ✅ Kiểm tra trước khi submit
            document.getElementById('purchaseForm').addEventListener('submit', function (e) {
                const rows = document.querySelectorAll('#invoiceDetailBody tr');
                if (rows.length === 0) {
                    e.preventDefault();
                    alert('⚠️ Vui lòng thêm ít nhất một sản phẩm trước khi lưu!');
                    return;
                }
                if (!confirm('Bạn có chắc muốn lưu phiếu nhập này không?')) {
                    e.preventDefault();
                }
            });
        </script>

        <jsp:include page="footer.jsp" />
    </body>
</html>
