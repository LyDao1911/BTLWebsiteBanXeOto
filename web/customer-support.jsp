<%-- 
    Document   : customer-support
    Created on : Oct 16, 2024, 8:00:00 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch sử Hỗ trợ</title>
        <link rel="stylesheet" href="../style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            .history-container {
                max-width: 1000px;
                margin: 20px auto;
                padding: 20px;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .request-card {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 15px;
                background: #fafafa;
            }
            
            .request-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
                padding-bottom: 10px;
                border-bottom: 1px solid #eee;
            }
            
            .request-id {
                font-weight: bold;
                color: #2c3e50;
            }
            
            .request-date {
                color: #7f8c8d;
                font-size: 14px;
            }
            
            .request-subject {
                font-weight: bold;
                color: #34495e;
                margin-bottom: 8px;
            }
            
            .request-message {
                color: #555;
                margin-bottom: 10px;
                line-height: 1.5;
            }
            
            .request-response {
                background: #e8f4fd;
                padding: 15px;
                border-radius: 5px;
                margin-top: 10px;
                border-left: 4px solid #3498db;
            }
            
            .response-label {
                font-weight: bold;
                color: #2980b9;
                margin-bottom: 5px;
            }
            
            .status-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: bold;
            }
            
            .status-pending {
                background: #ffeaa7;
                color: #e17055;
            }
            
            .status-resolved {
                background: #55efc4;
                color: #00b894;
            }
            
            .no-requests {
                text-align: center;
                padding: 40px;
                color: #7f8c8d;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        
        <div class="history-container">
            <h1><i class="fas fa-history"></i> Lịch sử Yêu cầu Hỗ trợ</h1>
            
            <c:if test="${empty myRequests}">
                <div class="no-requests">
                    <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 20px;"></i>
                    <h3>Chưa có yêu cầu hỗ trợ nào</h3>
                    <p>Bạn có thể gửi yêu cầu hỗ trợ mới <a href="../hotro.jsp">tại đây</a>.</p>
                </div>
            </c:if>
            
            <c:forEach items="${myRequests}" var="request">
                <div class="request-card">
                    <div class="request-header">
                        <span class="request-id">Yêu cầu #${request.supportID}</span>
                        <span class="request-date">${request.createdAt}</span>
                        <span class="status-badge ${request.status == 'Pending' ? 'status-pending' : 'status-resolved'}">
                            <c:choose>
                                <c:when test="${request.status == 'Pending'}">⏳ Đang chờ</c:when>
                                <c:when test="${request.status == 'Resolved'}">✅ Đã giải quyết</c:when>
                                <c:otherwise>${request.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    
                    <div class="request-subject">${request.subject}</div>
                    <div class="request-message">${request.message}</div>
                    
                    <c:if test="${not empty request.response}">
                        <div class="request-response">
                            <div class="response-label">Phản hồi từ hỗ trợ viên:</div>
                            <div>${request.response}</div>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
        
        <jsp:include page="footer.jsp" />
    </body>
</html>