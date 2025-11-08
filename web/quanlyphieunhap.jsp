<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.PurchaseInvoiceDetail" %>
<%@ page import="model.Supplier" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý phiếu nhập hàng | VELYRA AERO</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            /* ================================================= */
            /* 🚗 PURCHASE INVOICE MANAGEMENT - LUXURY STYLE */
            /* ================================================= */

            body {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
            }

            .admin-page-container {
                max-width: 1600px;
                margin: 120px auto 60px;
                padding: 0 40px;
            }

            /* Header sang trọng */
            .text-center {
                text-align: center;
                margin-bottom: 50px;
                position: relative;
            }

            .text-center h3 {
                font-size: 2.8rem;
                font-weight: 300;
                color: #1a1a1a;
                margin-bottom: 15px;
                letter-spacing: 2px;
                text-transform: uppercase;
            }

            .text-center::after {
                content: '';
                display: block;
                width: 100px;
                height: 3px;
                background: linear-gradient(90deg, #e52b2b, #b30000);
                margin: 20px auto;
                border-radius: 2px;
            }

            /* Section Cards */
            .supplier-section, .invoice-detail-section {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                padding: 40px;
                border: 1px solid rgba(229, 43, 43, 0.1);
                margin-bottom: 40px;
            }

            .section-title {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 2px solid #f0f0f0;
                background: linear-gradient(135deg, #e52b2b 0%, #b30000 100%) !important;
                color: white;
                padding: 15px 20px;
                border-radius: 12px;
                font-size: 1.3rem;
                font-weight: 600;
            }

            .section-title i {
                font-size: 1.5rem;
            }

            /* Supplier Table */
            .supplier-details-table .table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            }

            .supplier-details-table thead {
                background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            }

            .supplier-details-table th {
                padding: 20px 15px;
                color: #fff;
                font-weight: 500;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                border-bottom: 3px solid #e52b2b;
                text-align: left;
            }

            .supplier-details-table td {
                padding: 18px 15px;
                color: #555;
                font-size: 0.95rem;
                line-height: 1.6;
                border-bottom: 1px solid rgba(0, 0, 0, 0.03);
            }

            .supplier-details-table tbody tr {
                transition: all 0.3s ease;
            }

            .supplier-details-table tbody tr:hover {
                background: linear-gradient(90deg, #fff 0%, #fafafa 50%, #fff 100%);
            }

            /* Invoice Detail Table */
            .table-container {
                max-height: 600px;
                overflow-y: auto;
                margin-bottom: 30px;
                border-radius: 15px;
                border: 1px solid rgba(0, 0, 0, 0.05);
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
            }

            .table-container .table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
            }

            .table-container thead {
                background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
                position: sticky;
                top: 0;
                z-index: 10;
            }

            .table-container th {
                padding: 20px 15px;
                color: #fff;
                font-weight: 500;
                font-size: 0.8rem;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                border-bottom: 3px solid #e52b2b;
                text-align: left;
            }

            .table-container td {
                padding: 18px 15px;
                color: #555;
                font-size: 0.9rem;
                line-height: 1.6;
                border-bottom: 1px solid rgba(0, 0, 0, 0.03);
                vertical-align: middle;
            }

            .table-container tbody tr {
                transition: all 0.3s ease;
                position: relative;
            }

            .table-container tbody tr:hover {
                background: linear-gradient(90deg, #fff 0%, #fafafa 50%, #fff 100%);
                transform: translateY(-1px);
            }

            .table-container tbody tr::after {
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

            .table-container tbody tr:hover::after {
                opacity: 1;
            }

            /* Selected Row */
            .selected-row {
                background: linear-gradient(90deg, #e3f2fd 0%, #bbdefb 100%) !important;
                font-weight: 600;
                border-left: 4px solid #2196f3;
            }

            /* Checkbox Styling */
            input[type="checkbox"] {
                width: 18px;
                height: 18px;
                border: 2px solid #ddd;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            input[type="checkbox"]:checked {
                background: #e52b2b;
                border-color: #e52b2b;
            }

            /* Buttons */
            .table-action-buttons {
                display: flex;
                gap: 15px;
                margin-top: 30px;
                flex-wrap: wrap;
            }

            .btn {
                display: inline-flex;
                align-items: center;
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

            .btn-outline-danger {
                background: transparent;
                color: #dc3545;
                border: 2px solid #dc3545;
            }

            .btn-outline-danger:hover {
                background: #dc3545;
                color: white;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            }

            .btn-sm {
                padding: 10px 15px;
                font-size: 0.8rem;
                border-radius: 8px;
            }

            /* Price Styling */
            .table-container td:nth-child(6),
            .table-container td:nth-child(7) {
                font-weight: 600;
                color: #e52b2b;
                font-family: 'Courier New', monospace;
            }

            /* ID Badges */
            .table-container td:nth-child(2),
            .table-container td:nth-child(3),
            .table-container td:nth-child(4) {
                font-family: 'Courier New', monospace;
                font-weight: 600;
                color: #333;
            }

            /* Empty State */
            .text-center {
                color: #666;
                font-style: italic;
            }

            /* Responsive */
            @media (max-width: 1400px) {
                .admin-page-container {
                    margin: 100px auto 40px;
                    padding: 0 30px;
                }

                .text-center h3 {
                    font-size: 2.5rem;
                }
            }

            @media (max-width: 768px) {
                .admin-page-container {
                    margin: 100px auto 40px;
                    padding: 0 20px;
                }

                .supplier-section, .invoice-detail-section {
                    padding: 25px;
                    border-radius: 15px;
                }

                .text-center h3 {
                    font-size: 2rem;
                    letter-spacing: 2px;
                }

                .table-container {
                    max-height: 400px;
                }

                .table-container th,
                .table-container td {
                    padding: 12px 8px;
                    font-size: 0.8rem;
                }

                .table-action-buttons {
                    flex-direction: column;
                }

                .btn {
                    justify-content: center;
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

            .supplier-section, .invoice-detail-section {
                animation: fadeInUp 0.6s ease;
            }

            .table-container tbody tr {
                animation: fadeInUp 0.6s ease forwards;
                opacity: 0;
            }

            .table-container tbody tr:nth-child(1) {
                animation-delay: 0.1s;
            }
            .table-container tbody tr:nth-child(2) {
                animation-delay: 0.2s;
            }
            .table-container tbody tr:nth-child(3) {
                animation-delay: 0.3s;
            }
            .table-container tbody tr:nth-child(4) {
                animation-delay: 0.4s;
            }
            .table-container tbody tr:nth-child(5) {
                animation-delay: 0.5s;
            }

            /* Hover Effects */
            .table-container tbody tr:hover {
                background: linear-gradient(90deg, #fff 0%, #f8f9fa 50%, #fff 100%);
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <main class="admin-page-container container">
            <div class="right-panel">
                <div class="text-center">
                    <h3>Quản lý phiếu nhập hàng</h3>
                </div>

                <!-- Phần thông tin nhà cung cấp -->
                <div class="supplier-section">
                    <h4 class="section-title">
                        <i class="fas fa-truck"></i> Thông tin nhà cung cấp
                    </h4>

                    <div class="supplier-info">
                        <div class="supplier-details-table">
                            <table class="table table-bordered">
                                <thead class="table-secondary">
                                    <tr>
                                        <th><i class="fas fa-building"></i> Tên nhà cung cấp</th>
                                        <th><i class="fas fa-phone"></i> Số điện thoại</th>
                                        <th><i class="fas fa-map-marker-alt"></i> Địa chỉ</th>
                                        <th><i class="fas fa-envelope"></i> Email</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Supplier> supplierList = (List<Supplier>) request.getAttribute("supplierList");
                                        if (supplierList != null && !supplierList.isEmpty()) {
                                            for (Supplier supplier : supplierList) {
                                    %>
                                    <tr>
                                        <td><strong><%= supplier.getSupplierName()%></strong></td>
                                        <td><%= supplier.getPhoneNumber() != null ? supplier.getPhoneNumber() : "Chưa có"%></td>
                                        <td><%= supplier.getAddress() != null ? supplier.getAddress() : "Chưa có"%></td>
                                        <td><%= supplier.getEmail() != null ? supplier.getEmail() : "Chưa có"%></td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="4" class="text-center">Không có nhà cung cấp nào</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Phần chi tiết phiếu nhập -->
                <div class="invoice-detail-section">
                    <h4 class="section-title">
                        <i class="fas fa-file-invoice"></i> Chi tiết phiếu nhập hàng
                    </h4>

                    <div class="table-container">
                        <table class="table table-bordered table-hover align-middle">
                            <thead class="table-dark">
                                <tr>
                                    <th>Chọn</th>
                                    <th>Mã chi tiết</th>
                                    <th>Mã phiếu</th>
                                    <th>Mã xe</th>
                                    <th>Số lượng</th>
                                    <th>Giá nhập</th>
                                    <th>Thành tiền</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>

                            <tbody id="invoiceDetailTableBody">
                                <%
                                    List<PurchaseInvoiceDetail> detailList = (List<PurchaseInvoiceDetail>) request.getAttribute("invoiceDetailList");
                                    if (detailList != null && !detailList.isEmpty()) {
                                        for (PurchaseInvoiceDetail detail : detailList) {
                                %>
                                <tr data-id="<%= detail.getDetailID()%>">
                                    <td><input type="checkbox" name="selectDetail" value="<%= detail.getDetailID()%>"></td>
                                    <td><%= detail.getDetailID()%></td>
                                    <td><%= detail.getInvoiceID()%></td>
                                    <td><%= detail.getCarID()%></td>
                                    <td><%= detail.getQuantity()%></td>
                                    <td><%= String.format("%,.0f", detail.getImportPrice())%> VNĐ</td>
                                    <td><%= String.format("%,.0f", detail.getSubtotal())%> VNĐ</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-danger btn-delete-detail" 
                                                data-detailid="<%= detail.getDetailID()%>"
                                                title="Xóa chi tiết này">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr><td colspan="8" class="text-center">Không có chi tiết phiếu nhập nào</td></tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <div class="table-action-buttons">
                        <button type="button" class="btn btn-success" id="btnAddDetail">
                            <i class="fas fa-plus"></i> Thêm chi tiết
                        </button>

                        <button type="button" class="btn btn-danger" id="btnDeleteSelected">
                            <i class="fas fa-trash"></i> Xóa đã chọn
                        </button>
                    </div>
                </div>
            </div>
        </main>

        <script>
            // JavaScript giữ nguyên hoàn toàn
            let selectedDetailIds = [];

            document.querySelectorAll('#invoiceDetailTableBody input[type="checkbox"]').forEach(checkbox => {
                checkbox.addEventListener('change', function () {
                    const currentRow = this.closest('tr');

                    if (this.checked) {
                        currentRow.classList.add('selected-row');
                        if (!selectedDetailIds.includes(this.value)) {
                            selectedDetailIds.push(this.value);
                        }
                    } else {
                        currentRow.classList.remove('selected-row');
                        selectedDetailIds = selectedDetailIds.filter(id => id !== this.value);
                    }

                    console.log('Selected IDs:', selectedDetailIds);
                });
            });

            document.querySelectorAll('#invoiceDetailTableBody tr').forEach(row => {
                row.addEventListener('click', function (e) {
                    if (!e.target.classList.contains('btn-delete-detail') && !e.target.classList.contains('fa-trash')) {
                        const checkbox = this.querySelector('input[type="checkbox"]');
                        checkbox.checked = !checkbox.checked;
                        checkbox.dispatchEvent(new Event('change'));
                    }
                });
            });

            document.querySelectorAll('.btn-delete-detail').forEach(btn => {
                btn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    const detailId = this.dataset.detailid;
                    if (confirm('Bạn có chắc chắn muốn xóa chi tiết này không?')) {
                        window.location.href = 'XoaChiTietPhieuNhapServlet?detailId=' + detailId;
                    }
                });
            });

            document.getElementById('btnAddDetail').addEventListener('click', function () {
                window.location.href = 'NhapHangServlet';
            });

            document.getElementById('btnDeleteSelected').addEventListener('click', function () {
                if (selectedDetailIds.length > 0) {
                    if (confirm(`Bạn có chắc chắn muốn xóa ${selectedDetailIds.length} chi tiết phiếu nhập đã chọn không?`)) {
                        const detailIdsParam = selectedDetailIds.join(',');
                        window.location.href = 'XoaNhieuChiTietPhieuNhapServlet?detailIds=' + detailIdsParam;
                    }
                } else {
                    alert('Vui lòng chọn ít nhất một chi tiết phiếu nhập cần xóa.');
                }
            });

            document.querySelectorAll('#invoiceDetailTableBody tr').forEach(row => {
                row.addEventListener('mouseenter', function () {
                    if (!this.classList.contains('selected-row')) {
                        this.style.backgroundColor = '#f8f9fa';
                    }
                });

                row.addEventListener('mouseleave', function () {
                    if (!this.classList.contains('selected-row')) {
                        this.style.backgroundColor = '';
                    }
                });
            });

            document.addEventListener('DOMContentLoaded', function () {
                document.querySelectorAll('#invoiceDetailTableBody input[type="checkbox"]').forEach(checkbox => {
                    if (checkbox.checked) {
                        selectedDetailIds.push(checkbox.value);
                        checkbox.closest('tr').classList.add('selected-row');
                    }
                });
            });
        </script>

        <jsp:include page="footer.jsp" />
    </body>
</html>