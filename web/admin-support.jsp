<%-- 
    Document   : admin-support
    Created on : Oct 16, 2024, 8:00:00 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Hỗ trợ - Admin</title>
        <link rel="stylesheet" href="../style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            .support-container {
                max-width: 1200px;
                margin: 20px auto;
                padding: 20px;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .support-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            
            .support-table th, .support-table td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            
            .support-table th {
                background: #f8f9fa;
                font-weight: bold;
            }
            
            .status-pending {
                color: #e74c3c;
                font-weight: bold;
            }
            
            .status-resolved {
                color: #27ae60;
                font-weight: bold;
            }
            
            .btn-respond {
                background: #3498db;
                color: white;
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
            }
            
            .btn-respond:hover {
                background: #2980b9;
            }
            
            .message {
                padding: 10px;
                margin: 10px 0;
                border-radius: 5px;
            }
            
            .success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            
            .error {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        
        <div class="support-container">
            <h1><i class="fas fa-headset"></i> Quản lý Yêu cầu Hỗ trợ</h1>
            
            <c:if test="${not empty message}">
                <div class="message ${message.startsWith('✅') ? 'success' : 'error'}">
                    ${message}
                </div>
            </c:if>
            
            <c:if test="${empty supportList}">
                <div class="message">
                    <p>📝 Không có yêu cầu hỗ trợ nào.</p>
                </div>
            </c:if>
            
            <c:if test="${not empty supportList}">
                <table class="support-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Khách hàng ID</th>
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
                                <td>${request.customerID}</td>
                                <td>${request.subject}</td>
                                <td>
                                    <div style="max-width: 200px; overflow: hidden; text-overflow: ellipsis;">
                                        ${request.message}
                                    </div>
                                </td>
                                <td>${request.createdAt}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${request.status == 'Pending'}">
                                            <span class="status-pending">⏳ Chờ xử lý</span>
                                        </c:when>
                                        <c:when test="${request.status == 'Resolved'}">
                                            <span class="status-resolved">✅ Đã giải quyết</span>
                                        </c:when>
                                        <c:otherwise>
                                            ${request.status}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${request.status == 'Pending'}">
                                        <a href="admin-respond.jsp?supportID=${request.supportID}" class="btn-respond">
                                            <i class="fas fa-reply"></i> Phản hồi
                                        </a>
                                    </c:if>
                                    <c:if test="${request.status == 'Resolved'}">
                                        <span style="color: #27ae60;">Đã phản hồi</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
        
        <jsp:include page="footer.jsp" />
    </body>
</html>