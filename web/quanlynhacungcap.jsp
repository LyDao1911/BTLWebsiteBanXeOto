<%-- 
    Document   : quanlynhacungcap
    Created on : Nov 1, 2025, 11:30:17 PM
    Author     : Hong Ly
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý Nhà Cung Cấp | VELYRA AERO</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            /* ================================================= */
            /* 🚗 SUPPLIER MANAGEMENT - LUXURY CAR DEALER STYLE */
            /* ================================================= */

            body {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .admin-container {
                max-width: 1600px;
                margin: 120px auto 60px;
                padding: 0 40px;
                display: grid;
                grid-template-columns: 400px 1fr;
                gap: 40px;
                align-items: start;
            }

            /* Header sang trọng */
            .page-header {
                grid-column: 1 / -1;
                text-align: center;
                margin-bottom: 40px;
                position: relative;
            }

            .page-header h1 {
                font-size: 3rem;
                font-weight: 300;
                color: #1a1a1a;
                margin-bottom: 15px;
                letter-spacing: 3px;
                text-transform: uppercase;
            }

            .page-header::after {
                content: '';
                display: block;
                width: 100px;
                height: 3px;
                background: linear-gradient(90deg, #e52b2b, #b30000);
                margin: 20px auto;
                border-radius: 2px;
            }

            /* Form Panel */
            .form-panel {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                padding: 40px;
                border: 1px solid rgba(229, 43, 43, 0.1);
                position: sticky;
                top: 120px;
            }

            .form-header {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 2px solid #f0f0f0;
            }

            .form-header h3 {
                font-size: 1.5rem;
                font-weight: 600;
                color: #333;
                margin: 0;
            }

            .form-header i {
                color: #e52b2b;
                font-size: 1.8rem;
            }

            /* Form Elements */
            .form-group {
                margin-bottom: 25px;
            }

            .form-label {
                display: block;
                font-size: 0.9rem;
                color: #666;
                margin-bottom: 8px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .form-input {
                width: 100%;
                padding: 15px 20px;
                border: 2px solid #e9ecef;
                border-radius: 12px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: #fff;
            }

            .form-input:focus {
                outline: none;
                border-color: #e52b2b;
                box-shadow: 0 0 0 3px rgba(229, 43, 43, 0.1);
            }

            .form-textarea {
                width: 100%;
                padding: 15px 20px;
                border: 2px solid #e9ecef;
                border-radius: 12px;
                font-size: 1rem;
                resize: vertical;
                min-height: 100px;
                transition: all 0.3s ease;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .form-textarea:focus {
                outline: none;
                border-color: #e52b2b;
                box-shadow: 0 0 0 3px rgba(229, 43, 43, 0.1);
            }

            /* Buttons */
            .btn-group-vertical {
                display: flex;
                flex-direction: column;
                gap: 15px;
                margin-top: 30px;
            }

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

            .btn-warning {
                background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
                color: white;
            }

            .btn-danger {
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                color: white;
            }

            .btn-primary {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
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

            /* Table Panel */
            .table-panel {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                padding: 40px;
                border: 1px solid rgba(229, 43, 43, 0.1);
                overflow: hidden;
            }

            .table-header {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 2px solid #f0f0f0;
            }

            .table-header h3 {
                font-size: 1.5rem;
                font-weight: 600;
                color: #333;
                margin: 0;
            }

            .table-header i {
                color: #e52b2b;
                font-size: 1.8rem;
            }

            /* Table Styling */
            .supplier-table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
            }

            thead {
                background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            }

            thead th {
                padding: 20px 15px;
                color: #fff;
                font-weight: 500;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                border-bottom: 3px solid #e52b2b;
                text-align: left;
            }

            tbody tr {
                border-bottom: 1px solid rgba(0, 0, 0, 0.03);
                transition: all 0.3s ease;
                position: relative;
            }

            tbody tr:hover {
                background: linear-gradient(90deg, #fff 0%, #fafafa 50%, #fff 100%);
                transform: translateY(-1px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            }

            tbody tr::after {
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

            tbody tr:hover::after {
                opacity: 1;
            }

            td {
                padding: 20px 15px;
                color: #555;
                font-size: 0.95rem;
                line-height: 1.6;
                vertical-align: top;
                border-bottom: 1px solid rgba(0, 0, 0, 0.03);
            }

            /* Cột đặc biệt */
            td:nth-child(1) { /* ID */
                font-weight: 600;
                color: #e52b2b;
                font-family: 'Courier New', monospace;
                font-size: 0.9rem;
            }

            td:nth-child(2) { /* Tên NCC */
                font-weight: 600;
                color: #333;
            }

            td:nth-child(6) { /* Hành động */
                white-space: nowrap;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 60px 40px;
                background: #fafafa;
                border-radius: 15px;
                margin: 20px 0;
            }

            .empty-state i {
                font-size: 3rem;
                color: #e52b2b;
                margin-bottom: 20px;
                opacity: 0.7;
            }

            .empty-state p {
                color: #666;
                font-size: 1.1rem;
                margin: 0;
            }

            /* Responsive */
            @media (max-width: 1400px) {
                .admin-container {
                    margin: 100px auto 40px;
                    padding: 0 30px;
                    grid-template-columns: 1fr;
                    gap: 30px;
                }

                .form-panel {
                    position: static;
                    order: 2;
                }

                .table-panel {
                    order: 1;
                }

                .page-header h1 {
                    font-size: 2.5rem;
                }
            }

            @media (max-width: 768px) {
                .admin-container {
                    margin: 100px auto 40px;
                    padding: 0 20px;
                    gap: 20px;
                }

                .form-panel,
                .table-panel {
                    padding: 25px;
                    border-radius: 15px;
                }

                .page-header h1 {
                    font-size: 2rem;
                    letter-spacing: 2px;
                }

                td, th {
                    padding: 15px 10px;
                    font-size: 0.9rem;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .btn-sm {
                    padding: 8px 15px;
                    font-size: 0.75rem;
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

            .form-panel,
            .table-panel {
                animation: fadeInUp 0.6s ease;
            }

            tbody tr {
                animation: fadeInUp 0.6s ease forwards;
                opacity: 0;
            }

            tbody tr:nth-child(1) {
                animation-delay: 0.1s;
            }
            tbody tr:nth-child(2) {
                animation-delay: 0.2s;
            }
            tbody tr:nth-child(3) {
                animation-delay: 0.3s;
            }
            tbody tr:nth-child(4) {
                animation-delay: 0.4s;
            }
            tbody tr:nth-child(5) {
                animation-delay: 0.5s;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" /> 

        <div class="admin-container">
            <div class="page-header">
                <h1>Quản lý Nhà Cung Cấp</h1>
            </div>

            <div class="form-panel">
                <div class="form-header">
                    <i class="fas fa-<c:if test="${empty supplierToEdit}">plus</c:if><c:if test="${not empty supplierToEdit}">edit</c:if>"></i>
                        <h3>
                        <c:if test="${empty supplierToEdit}">Thêm Nhà Cung Cấp</c:if>
                        <c:if test="${not empty supplierToEdit}">Sửa Nhà Cung Cấp (ID: ${supplierToEdit.supplierID})</c:if>
                        </h3>
                    </div>

                    <form action="SupplierServlet" method="POST">
                    <c:if test="${not empty supplierToEdit}">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="supplierID" value="${supplierToEdit.supplierID}">
                    </c:if>
                    <c:if test="${empty supplierToEdit}">
                        <input type="hidden" name="action" value="add">
                    </c:if>

                    <div class="form-group">
                        <label class="form-label">Tên Nhà Cung Cấp</label>
                        <input type="text" name="supplierName" value="${supplierToEdit.supplierName}" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Số Điện Thoại</label>
                        <input type="text" name="phoneNumber" value="${supplierToEdit.phoneNumber}" class="form-input">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" value="${supplierToEdit.email}" class="form-input">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Địa Chỉ</label>
                        <textarea name="address" rows="3" class="form-textarea">${supplierToEdit.address}</textarea>
                    </div>

                    <div class="btn-group-vertical">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-<c:if test="${empty supplierToEdit}">plus</c:if><c:if test="${not empty supplierToEdit}">save</c:if>"></i>
                            <c:if test="${empty supplierToEdit}">Thêm Nhà Cung Cấp</c:if>
                            <c:if test="${not empty supplierToEdit}">Cập Nhật Thông Tin</c:if>
                            </button>
                        <c:if test="${not empty supplierToEdit}">
                            <a href="SupplierServlet" class="btn btn-warning">
                                <i class="fas fa-times"></i> Hủy Sửa
                            </a>
                        </c:if>
                    </div>
                </form>
            </div>

            <div class="table-panel">
                <div class="table-header">
                    <i class="fas fa-list"></i>
                    <h3>Danh Sách Nhà Cung Cấp</h3>
                </div>

                <table class="supplier-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên NCC</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th>Địa Chỉ</th>
                            <th>Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="supplier" items="${supplierList}">
                            <tr>
                                <td>#${supplier.supplierID}</td>
                                <td>${supplier.supplierName}</td>
                                <td>${supplier.phoneNumber}</td>
                                <td>${supplier.email}</td>
                                <td>${supplier.address}</td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="SupplierServlet?action=edit&id=${supplier.supplierID}" class="btn btn-primary btn-sm">
                                            <i class="fas fa-edit"></i> Sửa
                                        </a>
                                        <a href="SupplierServlet?action=delete&id=${supplier.supplierID}" class="btn btn-danger btn-sm" 
                                           onclick="return confirm('Bạn chắc chắn muốn xóa NCC: ${supplier.supplierName}?');">
                                            <i class="fas fa-trash"></i> Xóa
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty supplierList}">
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state">
                                        <i class="fas fa-building"></i>
                                        <p>Chưa có nhà cung cấp nào</p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>