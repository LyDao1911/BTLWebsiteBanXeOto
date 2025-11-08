<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Hỗ trợ - Admin | VELYRA AERO</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            /* ================================================= */
            /* 🚗 ADMIN SUPPORT MANAGEMENT - LUXURY STYLE */
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
            }

            /* Header sang trọng */
            .page-header {
                text-align: center;
                margin-bottom: 60px;
                position: relative;
            }

            .page-header h1 {
                font-size: 3.2rem;
                font-weight: 300;
                color: #1a1a1a;
                margin-bottom: 15px;
                letter-spacing: 3px;
                text-transform: uppercase;
            }

            .page-header h1 i {
                color: #e52b2b;
                margin-right: 20px;
                font-size: 2.8rem;
            }

            .page-header::after {
                content: '';
                display: block;
                width: 100px;
                height: 3px;
                background: linear-gradient(90deg, #e52b2b, #b30000);
                margin: 25px auto;
                border-radius: 2px;
            }

            /* Bảng hiện đại */
            .table-container {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                border: 1px solid rgba(229, 43, 43, 0.1);
                margin-bottom: 60px;
                position: relative;
            }

            .support-table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
            }

            /* Header bảng */
            thead {
                background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            }

            thead th {
                padding: 25px 20px;
                color: #fff;
                font-weight: 500;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                border-bottom: 3px solid #e52b2b;
                position: relative;
                overflow: hidden;
            }

            thead th::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(229, 43, 43, 0.2), transparent);
                transition: left 0.6s;
            }

            thead th:hover::before {
                left: 100%;
            }

            /* Dòng dữ liệu */
            tbody tr {
                border-bottom: 1px solid rgba(0, 0, 0, 0.03);
                transition: all 0.3s ease;
                position: relative;
            }

            tbody tr:hover {
                background: linear-gradient(90deg, #fff 0%, #fafafa 50%, #fff 100%);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
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
                padding: 22px 20px;
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

            td:nth-child(2) { /* Khách hàng */
                font-weight: 600;
                color: #333;
                min-width: 200px;
            }

            td:nth-child(4) { /* Nội dung */
                max-width: 300px;
                word-wrap: break-word;
                line-height: 1.6;
            }

            td:nth-child(5) { /* Ngày gửi */
                color: #888;
                font-size: 0.9rem;
                font-weight: 300;
                white-space: nowrap;
            }

            /* Status badges hiện đại */
            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 10px 20px;
                border-radius: 25px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                position: relative;
                overflow: hidden;
                transition: all 0.3s ease;
            }

            .status-badge::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
                transition: left 0.5s;
            }

            .status-badge:hover::before {
                left: 100%;
            }

            .status-pending {
                background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
                color: #f57c00;
                border: 1px solid #ffb74d;
            }

            .status-resolved {
                background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                color: #388e3c;
                border: 1px solid #81c784;
            }

            /* Nút hành động */
            .btn-respond {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 12px 24px;
                background: linear-gradient(135deg, #e52b2b 0%, #b30000 100%);
                color: white;
                text-decoration: none;
                border-radius: 25px;
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                position: relative;
                overflow: hidden;
            }

            .btn-respond::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn-respond:hover::before {
                left: 100%;
            }

            .btn-respond:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(229, 43, 43, 0.3);
            }

            /* Thông báo */
            .message {
                padding: 20px;
                border-radius: 12px;
                margin-bottom: 30px;
                border-left: 4px solid;
                font-weight: 500;
            }

            .message.success {
                background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
                color: #155724;
                border-left-color: #28a745;
            }

            .message.error {
                background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
                color: #721c24;
                border-left-color: #dc3545;
            }

            .message.info {
                background: linear-gradient(135deg, #d1ecf1 0%, #bee5eb 100%);
                color: #0c5460;
                border-left-color: #17a2b8;
                text-align: center;
                padding: 40px;
            }

            /* Empty state */
            .empty-state {
                text-align: center;
                padding: 80px 40px;
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.08);
                margin: 40px 0;
            }

            .empty-state i {
                font-size: 4rem;
                color: #e52b2b;
                margin-bottom: 20px;
                opacity: 0.7;
            }

            .empty-state h3 {
                color: #333;
                font-size: 1.5rem;
                margin-bottom: 15px;
                font-weight: 400;
            }

            .empty-state p {
                color: #666;
                font-size: 1.1rem;
                line-height: 1.6;
            }

            /* Customer info */
            .customer-info {
                line-height: 1.5;
            }

            .customer-name {
                font-weight: 600;
                color: #333;
                margin-bottom: 4px;
            }

            .customer-email {
                font-size: 0.85rem;
                color: #666;
                font-weight: 300;
            }

            /* Responsive */
            @media (max-width: 1400px) {
                .admin-container {
                    margin: 100px auto 40px;
                    padding: 0 30px;
                }
                
                .page-header h1 {
                    font-size: 2.8rem;
                }
            }

            @media (max-width: 768px) {
                .table-container {
                    border-radius: 15px;
                    margin: 0 -20px 40px;
                }
                
                .page-header h1 {
                    font-size: 2.2rem;
                    letter-spacing: 2px;
                }
                
                td, th {
                    padding: 18px 15px;
                    font-size: 0.9rem;
                }
                
                .status-badge, .btn-respond {
                    padding: 8px 16px;
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

            tbody tr {
                animation: fadeInUp 0.6s ease forwards;
                opacity: 0;
            }

            tbody tr:nth-child(1) { animation-delay: 0.1s; }
            tbody tr:nth-child(2) { animation-delay: 0.2s; }
            tbody tr:nth-child(3) { animation-delay: 0.3s; }
            tbody tr:nth-child(4) { animation-delay: 0.4s; }
            tbody tr:nth-child(5) { animation-delay: 0.5s; }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="admin-container">
            <div class="page-header">
                <h1><i class="fas fa-headset"></i> Quản lý Yêu cầu Hỗ trợ</h1>
            </div>

            <%-- Thông báo --%>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="message success">
                    <i class="fas fa-check-circle"></i> ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="message error">
                    <i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <c:choose>
                <c:when test="${empty supportList}">
                    <div class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <h3>Không có yêu cầu hỗ trợ</h3>
                        <p>Hiện tại không có yêu cầu hỗ trợ nào cần xử lý.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table class="support-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Khách hàng</th>
                                    <th>Chủ đề</th>
                                    <th>Nội dung</th>
                                    <th>Ngày gửi</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${supportList}" var="request">
                                    <tr>
                                        <td>#${request.supportID}</td>
                                        <td>
                                            <div class="customer-info">
                                                <div class="customer-name">${request.fullName}</div>
                                                <div class="customer-email">${request.email}</div>
                                                <div style="font-size: 0.8rem; color: #888; margin-top: 4px;">
                                                    ID: ${request.customerID}
                                                </div>
                                            </div>
                                        </td>
                                        <td>${request.subject}</td>
                                        <td>
                                            <div style="max-height: 60px; overflow: hidden; line-height: 1.5;">
                                                ${request.message}
                                            </div>
                                        </td>
                                        <td>${request.createdAt}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${request.status == 'Pending'}">
                                                    <span class="status-badge status-pending">
                                                        <i class="fas fa-clock"></i> Chờ xử lý
                                                    </span>
                                                </c:when>
                                                <c:when test="${request.status == 'Resolved'}">
                                                    <span class="status-badge status-resolved">
                                                        <i class="fas fa-check-circle"></i> Đã giải quyết
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge" style="background: #f5f5f5; color: #666;">
                                                        ${request.status}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${request.status == 'Pending' || request.status == 'Resolved'}">
                                                <a href="admin-respond.jsp?supportID=${request.supportID}" class="btn-respond">
                                                    <i class="fas fa-reply"></i> 
                                                    ${request.status == 'Pending' ? 'Phản hồi' : 'Xem/Sửa'}
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>