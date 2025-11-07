<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.PurchaseInvoiceDetail" %>
<%@ page import="model.Supplier" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý phiếu nhập hàng - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <!-- Font Awesome --> 
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            .selected-row {
                background-color: #e3f2fd !important;
                font-weight: bold;
            }
            .table-action-buttons {
                margin-top: 20px;
                display: flex;
                gap: 10px;
            }
            .table-container {
                max-height: 400px;
                overflow-y: auto;
                margin-bottom: 30px;
            }
            .section-title {
                background: linear-gradient(#e52b2b, #731919, #0b0b0b);
                color: white;
                padding: 10px 15px;
                border-radius: 5px;
                margin: 20px 0 15px 0;
            }
            .supplier-info {

                padding: 15px;
                border-radius: 5px;

                margin-bottom: 20px;
            }
            .supplier-details-table {
                margin-top: 15px;
            }
        </style>
    </head>
    <body>

        <jsp:include page="header.jsp" />
        <main class="admin-page-container container">

            <div class="right-panel">
                <h3 class="text-center mb-4">Quản lý phiếu nhập hàng</h3>

                <!-- Phần thông tin nhà cung cấp -->
                <div class="supplier-section">
                    <h4 class="section-title">
                        <i class="fas fa-truck"></i> Thông tin nhà cung cấp
                    </h4>

                    <div class="supplier-info">
                        <!-- Hiển thị thông tin nhà cung cấp cố định -->
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
            let selectedDetailIds = [];

            // === XỬ LÝ CHỌN CHI TIẾT PHIẾU NHẬP ===
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

            // === CLICK VÀO DÒNG ===
            document.querySelectorAll('#invoiceDetailTableBody tr').forEach(row => {
                row.addEventListener('click', function (e) {
                    if (!e.target.classList.contains('btn-delete-detail') && !e.target.classList.contains('fa-trash')) {
                        const checkbox = this.querySelector('input[type="checkbox"]');
                        checkbox.checked = !checkbox.checked;
                        checkbox.dispatchEvent(new Event('change'));
                    }
                });
            });

            // === XÓA TỪNG CHI TIẾT (nút xóa trên từng dòng) ===
            document.querySelectorAll('.btn-delete-detail').forEach(btn => {
                btn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    const detailId = this.dataset.detailid;
                    if (confirm('Bạn có chắc chắn muốn xóa chi tiết này không?')) {
                        // Gọi servlet xóa từng chi tiết
                        window.location.href = 'XoaChiTietPhieuNhapServlet?detailId=' + detailId;
                    }
                });
            });

            // === XỬ LÝ NÚT THAO TÁC ===

            // Thêm chi tiết - Chuyển đến NhapHangServlet
            document.getElementById('btnAddDetail').addEventListener('click', function () {
                window.location.href = 'NhapHangServlet';
            });

            // Xóa nhiều chi tiết (nút xóa đã chọn)
            document.getElementById('btnDeleteSelected').addEventListener('click', function () {
                if (selectedDetailIds.length > 0) {
                    if (confirm(`Bạn có chắc chắn muốn xóa ${selectedDetailIds.length} chi tiết phiếu nhập đã chọn không?`)) {
                        // Gọi servlet xóa nhiều chi tiết
                        const detailIdsParam = selectedDetailIds.join(',');
                        window.location.href = 'XoaNhieuChiTietPhieuNhapServlet?detailIds=' + detailIdsParam;
                    }
                } else {
                    alert('Vui lòng chọn ít nhất một chi tiết phiếu nhập cần xóa.');
                }
            });

            // === XỬ LÝ HIỆU ỨNG HOVER ===
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

            // === KIỂM TRA TRẠNG THÁI KHI TẢI TRANG ===
            document.addEventListener('DOMContentLoaded', function () {
                // Tự động chọn các checkbox đã được chọn trước đó (nếu có)
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