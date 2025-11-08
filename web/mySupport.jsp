<%-- 
    Document   : mySupport
    Created on : Nov 8, 2025, 7:23:37 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="model.SupportRequest"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<style>
    /* ================================================= */
    /* 🚗 MY SUPPORT PAGE - LUXURY CAR DEALER STYLE */
    /* ================================================= */

    body {
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        min-height: 100vh;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    /* Container chính */
    .support-container {
        max-width: 1400px;
        margin: 120px auto 60px;
        padding: 0 30px;
    }

    /* Tiêu đề sang trọng */
    .page-header {
        text-align: center;
        margin-bottom: 60px;
        position: relative;
    }

    .page-header h2 {
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
        width: 80px;
        height: 3px;
        background: linear-gradient(90deg, #e52b2b, #b30000);
        margin: 20px auto;
        border-radius: 2px;
    }

    .page-subtitle {
        color: #666;
        font-size: 1.1rem;
        font-weight: 300;
        letter-spacing: 1px;
    }

    /* Bảng hiện đại */
    .support-table-container {
        background: #fff;
        border-radius: 20px;
        box-shadow: 0 15px 50px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        border: 1px solid rgba(229, 43, 43, 0.1);
        margin-bottom: 60px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
    }

    /* Header bảng */
    thead {
        background: linear-gradient(135deg, #1a1a1a 0%, #333 100%);
    }

    thead th {
        padding: 25px 20px;
        color: #fff;
        font-weight: 500;
        font-size: 0.9rem;
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
        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        transition: all 0.3s ease;
        position: relative;
    }

    tbody tr:hover {
        background: linear-gradient(90deg, #fff 0%, #f8f9fa 50%, #fff 100%);
        transform: translateY(-2px);
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
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
    td:nth-child(1) { /* Mã yêu cầu */
        font-weight: 600;
        color: #e52b2b;
        font-family: 'Courier New', monospace;
        font-size: 0.9rem;
    }

    td:nth-child(2) { /* Chủ đề */
        font-weight: 600;
        color: #333;
    }

    td:nth-child(3), td:nth-child(6) { /* Nội dung và phản hồi */
        max-width: 350px;
        word-wrap: break-word;
        white-space: normal;
        line-height: 1.7;
    }

    td:nth-child(4) { /* Ngày gửi */
        color: #888;
        font-size: 0.9rem;
        font-weight: 300;
    }

    /* Status badges hiện đại */
    .status-badge {
        display: inline-block;
        padding: 8px 20px;
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

    .status-completed {
        background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
        color: #388e3c;
        border: 1px solid #81c784;
    }

    .status-default {
        background: linear-gradient(135deg, #f5f5f5 0%, #eeeeee 100%);
        color: #757575;
        border: 1px solid #bdbdbd;
    }

    /* Phản hồi admin */
    .admin-response {
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-left: 4px solid #e52b2b;
        padding: 18px;
        border-radius: 12px;
        position: relative;
        margin: 0;
        font-style: italic;
        color: #555;
        line-height: 1.7;
        box-shadow: inset 0 2px 10px rgba(0,0,0,0.03);
    }

    .admin-response::before {
        content: '"';
        font-size: 3rem;
        color: #e52b2b;
        opacity: 0.3;
        position: absolute;
        top: 5px;
        left: 10px;
        font-family: serif;
    }

    .no-response {
        color: #999;
        font-style: italic;
        text-align: center;
        padding: 15px;
        background: rgba(0,0,0,0.02);
        border-radius: 8px;
        border: 1px dashed #ddd;
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

    /* Responsive */
    @media (max-width: 1200px) {
        .support-container {
            margin: 100px auto 40px;
            padding: 0 20px;
        }
        
        .page-header h2 {
            font-size: 2.5rem;
        }
    }

    @media (max-width: 768px) {
        .support-table-container {
            border-radius: 15px;
            margin: 0 -10px 40px;
        }
        
        .page-header h2 {
            font-size: 2rem;
            letter-spacing: 2px;
        }
        
        td, th {
            padding: 15px 12px;
            font-size: 0.9rem;
        }
        
        .status-badge {
            padding: 6px 15px;
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
<html>
    <head>
        <title>Yêu Cầu Hỗ Trợ Của Tôi - VELYRA AERO</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        
        <div class="support-container">
            <div class="page-header">
                <h2>Yêu Cầu Hỗ Trợ Của Bạn</h2>
                <p class="page-subtitle">Theo dõi và quản lý các yêu cầu hỗ trợ của bạn</p>
            </div>

            <c:if test="${not empty error}">
                <div style="background: #ffebee; color: #c62828; padding: 15px; border-radius: 10px; margin-bottom: 30px; border-left: 4px solid #c62828;">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty supportRequests}">
                    <div class="empty-state">
                        <i class="fas fa-headset"></i>
                        <h3>Chưa có yêu cầu hỗ trợ nào</h3>
                        <p>Bạn chưa gửi bất kỳ yêu cầu hỗ trợ nào. <br>Hãy liên hệ với chúng tôi nếu bạn cần hỗ trợ.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="support-table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Mã Yêu Cầu</th>
                                    <th>Chủ Đề</th>
                                    <th>Nội Dung</th>
                                    <th>Ngày Gửi</th>
                                    <th>Trạng Thái</th>
                                    <th>Phản Hồi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="req" items="${supportRequests}">
                                    <tr>
                                        <td>#${req.supportID}</td>
                                        <td>${req.subject}</td>
                                        <td>${req.message}</td>
                                        <td>${req.createdAt}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${req.status eq 'Pending'}">
                                                    <span class="status-badge status-pending">
                                                        <i class="fas fa-clock"></i> Đang Chờ
                                                    </span>
                                                </c:when>
                                                <c:when test="${req.status eq 'Completed'}">
                                                    <span class="status-badge status-completed">
                                                        <i class="fas fa-check-circle"></i> Đã Hoàn Thành
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-default">
                                                        ${req.status}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${empty req.response}">
                                                <div class="no-response">
                                                    <i class="far fa-comment-dots"></i><br>
                                                    Đang chờ phản hồi
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty req.response}">
                                                <div class="admin-response">
                                                    ${req.response}
                                                </div>
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