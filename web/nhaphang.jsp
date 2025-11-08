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
        <title>Tạo Phiếu Nhập Hàng | VELYRA AERO</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            /* ================================================= */
            /* 🚗 PURCHASE ORDER - LUXURY CAR DEALER STYLE */
            /* ================================================= */
            
            body {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
            }

            .container {
                max-width: 1400px;
                margin: 120px auto 60px;
                padding: 0 40px;
            }

            /* Header sang trọng */
            .title {
                text-align: center;
                margin-bottom: 50px;
                position: relative;
                font-size: 2.8rem;
                font-weight: 300;
                color: #1a1a1a;
                letter-spacing: 2px;
                text-transform: uppercase;
            }

            .title::after {
                content: '';
                display: block;
                width: 80px;
                height: 3px;
                background: linear-gradient(90deg, #e52b2b, #b30000);
                margin: 20px auto;
                border-radius: 2px;
            }

            /* Form Container */
            #purchaseForm {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                padding: 40px;
                border: 1px solid rgba(229, 43, 43, 0.1);
                margin-bottom: 40px;
            }

            /* Top Section - Grid Layout */
            .top {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 40px;
                margin-bottom: 40px;
            }

            .left, .right {
                background: linear-gradient(135deg, #fafafa 0%, #f5f5f5 100%);
                border-radius: 15px;
                padding: 30px;
                border: 1px solid rgba(0, 0, 0, 0.05);
            }

            .section-title {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 2px solid rgba(229, 43, 43, 0.2);
                font-size: 1.3rem;
                font-weight: 600;
                color: #333;
            }

            /* Form Elements */
            .label {
                display: block;
                font-size: 0.9rem;
                color: #666;
                margin-bottom: 8px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .input, select.input {
                width: 100%;
                padding: 15px 20px;
                border: 2px solid #e9ecef;
                border-radius: 12px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: #fff;
                box-sizing: border-box;
            }

            .input:focus, select.input:focus {
                outline: none;
                border-color: #e52b2b;
                box-shadow: 0 0 0 3px rgba(229, 43, 43, 0.1);
            }

            .input:disabled {
                background: #f8f9fa;
                color: #6c757d;
                cursor: not-allowed;
            }

            /* Total Amount Display */
            #totalAmountDisplay {
                background: linear-gradient(135deg, #e52b2b 0%, #b30000 100%);
                color: white;
                padding: 25px;
                border-radius: 15px;
                text-align: center;
                margin-top: 20px;
                font-size: 2.2rem;
                font-weight: 700;
                letter-spacing: 1px;
            }

            /* Buttons */
            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                padding: 15px 25px;
                border: none;
                border-radius: 12px;
                font-size: 0.9rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                text-decoration: none;
                transition: all 0.3s ease;
                cursor: pointer;
                position: relative;
                overflow: hidden;
            }

            .btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn:hover::before {
                left: 100%;
            }

            .btn-success {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
            }

            .btn-danger {
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                color: white;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            }

            .btn-sm {
                padding: 10px 20px;
                font-size: 0.8rem;
                border-radius: 8px;
            }

            /* Table Styling */
            #invoiceDetailTable {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                margin: 30px 0;
            }

            #invoiceDetailTable thead {
                background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            }

            #invoiceDetailTable th {
                padding: 20px 15px;
                color: #fff;
                font-weight: 500;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                border-bottom: 3px solid #e52b2b;
                text-align: left;
            }

            #invoiceDetailTable td {
                padding: 18px 15px;
                color: #555;
                font-size: 0.95rem;
                line-height: 1.6;
                border-bottom: 1px solid rgba(0, 0, 0, 0.03);
                vertical-align: middle;
            }

            #invoiceDetailTable tbody tr {
                transition: all 0.3s ease;
                position: relative;
            }

            #invoiceDetailTable tbody tr:hover {
                background: linear-gradient(90deg, #fff 0%, #fafafa 50%, #fff 100%);
                transform: translateY(-1px);
            }

            #invoiceDetailTable tbody tr::after {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                height: 100%;
                width: 4px;
                background: #e52b2b;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            #invoiceDetailTable tbody tr:hover::after {
                opacity: 1;
            }

            /* Submit Button */
            .btn-submit {
                display: inline-flex;
                align-items: center;
                gap: 12px;
                padding: 18px 45px;
                background: linear-gradient(135deg, #e52b2b 0%, #b30000 100%);
                color: white;
                border: none;
                border-radius: 25px;
                font-size: 1.1rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 2px;
                transition: all 0.3s ease;
                cursor: pointer;
                position: relative;
                overflow: hidden;
                margin: 30px auto;
                display: block;
            }

            .btn-submit::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
                transition: left 0.6s;
            }

            .btn-submit:hover::before {
                left: 100%;
            }

            .btn-submit:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 30px rgba(229, 43, 43, 0.4);
            }

            /* Error Message */
            .error-message {
                background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
                color: #721c24;
                padding: 20px 25px;
                border-radius: 15px;
                margin-bottom: 30px;
                border-left: 4px solid #dc3545;
                text-align: center;
                font-weight: 500;
            }

            /* Divider */
            hr {
                margin: 30px 0;
                border: none;
                height: 2px;
                background: linear-gradient(90deg, transparent, #e52b2b, transparent);
                border-radius: 2px;
            }

            /* Responsive */
            @media (max-width: 1200px) {
                .container {
                    margin: 100px auto 40px;
                    padding: 0 30px;
                }
                
                .top {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }
                
                .title {
                    font-size: 2.3rem;
                }
            }

            @media (max-width: 768px) {
                .container {
                    margin: 100px auto 40px;
                    padding: 0 20px;
                }
                
                #purchaseForm {
                    padding: 25px;
                    border-radius: 15px;
                }
                
                .left, .right {
                    padding: 20px;
                }
                
                .title {
                    font-size: 1.8rem;
                    letter-spacing: 1px;
                }
                
                #invoiceDetailTable th,
                #invoiceDetailTable td {
                    padding: 15px 10px;
                    font-size: 0.9rem;
                }
                
                .btn-submit {
                    padding: 15px 30px;
                    font-size: 1rem;
                    width: 100%;
                }
            }

            /* Animation */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            #purchaseForm {
                animation: fadeInUp 0.6s ease;
            }

            #invoiceDetailTable tbody tr {
                animation: fadeInUp 0.6s ease forwards;
                opacity: 0;
            }

            #invoiceDetailTable tbody tr:nth-child(1) { animation-delay: 0.1s; }
            #invoiceDetailTable tbody tr:nth-child(2) { animation-delay: 0.2s; }
            #invoiceDetailTable tbody tr:nth-child(3) { animation-delay: 0.3s; }
            #invoiceDetailTable tbody tr:nth-child(4) { animation-delay: 0.4s; }
            #invoiceDetailTable tbody tr:nth-child(5) { animation-delay: 0.5s; }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" /> 

        <div class="container">
            <h2 class="title">Tạo Phiếu Nhập Hàng</h2>

            <c:if test="${not empty errorMessage}">
                <p class="error-message">${errorMessage}</p>
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
                        <h3 id="totalAmountDisplay">0 VNĐ</h3>
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

                <hr>

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

                <button type="submit" class="btn-submit">💾 LƯU HÓA ĐƠN NHẬP</button>
            </form>
        </div>

        <script>
            // ✅ Thêm sản phẩm vào phiếu nhập
            document.getElementById('btnAddItem').addEventListener('click', function () {
                const carSelector = document.getElementById('carSelector');
                const selectedOption = carSelector.options[carSelector.selectedIndex];
                const carId = selectedOption.value;
                const carName = selectedOption.getAttribute('data-name');
                const quantity = parseInt(document.getElementById('itemQuantity').value.trim());
                const importPriceStr = document.getElementById('itemImportPrice').value.trim().replace(/\D/g, '');
                const importPrice = parseInt(importPriceStr);

                // 1. Kiểm tra dữ liệu
                if (!carId || isNaN(quantity) || isNaN(importPrice) || quantity <= 0 || importPrice <= 0) {
                    alert('⚠️ Vui lòng chọn xe, nhập số lượng và đơn giá nhập hợp lệ!');
                    return;
                }

                const subtotal = quantity * importPrice;
                const tableBody = document.getElementById('invoiceDetailBody');
                const formatter = new Intl.NumberFormat('vi-VN');

                try {
                    // Tạo hàng mới
                    const newRow = document.createElement('tr');
                    newRow.setAttribute('data-subtotal', subtotal);

                    // Ô 1: Tên xe + input ẩn
                    const cellName = document.createElement('td');
                    cellName.textContent = carName;

                    // Tạo input hidden bằng createElement (tránh lỗi)
                    const carIdInput = document.createElement('input');
                    carIdInput.type = 'hidden';
                    carIdInput.name = 'carId';
                    carIdInput.value = carId;
                    cellName.appendChild(carIdInput);

                    const quantityInput = document.createElement('input');
                    quantityInput.type = 'hidden';
                    quantityInput.name = 'quantity';
                    quantityInput.value = quantity;
                    cellName.appendChild(quantityInput);

                    const importPriceInput = document.createElement('input');
                    importPriceInput.type = 'hidden';
                    importPriceInput.name = 'importPrice';
                    importPriceInput.value = importPrice;
                    cellName.appendChild(importPriceInput);

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
                    const deleteButton = document.createElement('button');
                    deleteButton.type = 'button';
                    deleteButton.className = 'btn btn-danger btn-sm';
                    deleteButton.textContent = 'Xóa';
                    deleteButton.onclick = function () {
                        removeItem(this);
                    };
                    cellDelete.appendChild(deleteButton);

                    // Gắn tất cả ô vào hàng
                    newRow.appendChild(cellName);
                    newRow.appendChild(cellQty);
                    newRow.appendChild(cellPrice);
                    newRow.appendChild(cellSubtotal);
                    newRow.appendChild(cellDelete);

                    // Gắn hàng vào bảng
                    tableBody.appendChild(newRow);

                } catch (e) {
                    console.error("LỖI KHI TẠO HÀNG:", e);
                    alert("Đã xảy ra lỗi khi tạo hàng: " + e.message);
                    return;
                }

                updateTotal(); // Cập nhật tổng tiền

                // Reset input
                carSelector.selectedIndex = 0;
                document.getElementById('itemQuantity').value = 1;
                document.getElementById('itemImportPrice').value = '';
            });

            // ✅ Xóa dòng
            function removeItem(button) {
                if (confirm('Bạn có chắc muốn xóa sản phẩm này?')) {
                    button.closest('tr').remove();
                    updateTotal();
                }
            }

            // ✅ Cập nhật tổng tiền
            function updateTotal() {
                let total = 0;
                document.querySelectorAll('#invoiceDetailBody tr').forEach(row => {
                    const sub = parseFloat(row.getAttribute('data-subtotal'));
                    if (!isNaN(sub)) {
                        total += sub;
                    }
                });
                const formatter = new Intl.NumberFormat('vi-VN');
                document.getElementById('totalAmountDisplay').textContent = formatter.format(total) + " VNĐ";
                document.getElementById('totalAmountInput').value = total;
            }

            // ✅ Format tiền khi nhập
            document.getElementById('itemImportPrice').addEventListener('input', function (e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value) {
                    e.target.value = new Intl.NumberFormat('vi-VN').format(parseInt(value));
                } else {
                    e.target.value = '';
                }
            });

            // ✅ Lấy giá trị số khi mất focus
            document.getElementById('itemImportPrice').addEventListener('blur', function (e) {
                let value = e.target.value.replace(/\D/g, '');
                // Giữ lại giá trị số trong thuộc tính data
                e.target.dataset.rawValue = value;
            });

            // ✅ Kiểm tra trước khi submit
            document.getElementById('purchaseForm').addEventListener('submit', function (e) {
                const rows = document.querySelectorAll('#invoiceDetailBody tr');
                const supplier = document.querySelector('[name="supplierID"]').value;

                if (!supplier) {
                    e.preventDefault();
                    alert('⚠️ Vui lòng chọn nhà cung cấp!');
                    return;
                }

                if (rows.length === 0) {
                    e.preventDefault();
                    alert('⚠️ Vui lòng thêm ít nhất một sản phẩm trước khi lưu!');
                    return;
                }

                if (!confirm('Bạn có chắc muốn lưu phiếu nhập này không?')) {
                    e.preventDefault();
                }
            });

            // ✅ Đảm bảo lấy đúng giá trị số khi thêm sản phẩm
            document.getElementById('itemImportPrice').addEventListener('focus', function (e) {
                let value = e.target.value.replace(/\D/g, '');
                e.target.value = value; // Hiển thị giá trị số khi focus
            });
        </script>

        <jsp:include page="footer.jsp" />
    </body>
</html>