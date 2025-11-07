<%-- 
    Document   : admin-respond
    Created on : Oct 16, 2024, 8:00:00 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String supportID = request.getParameter("supportID");
    if (supportID == null || supportID.trim().isEmpty()) {
        response.sendRedirect("admin-support.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Phản hồi Hỗ trợ - Admin</title>
        <link rel="stylesheet" href="../style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            .respond-container {
                max-width: 800px;
                margin: 20px auto;
                padding: 30px;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                color: #333;
            }
            
            textarea {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-family: inherit;
                font-size: 14px;
                resize: vertical;
                min-height: 150px;
            }
            
            textarea:focus {
                outline: none;
                border-color: #3498db;
                box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
            }
            
            .btn-submit {
                background: #27ae60;
                color: white;
                padding: 12px 30px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                font-weight: bold;
            }
            
            .btn-submit:hover {
                background: #219a52;
            }
            
            .btn-back {
                background: #95a5a6;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                margin-right: 10px;
            }
            
            .btn-back:hover {
                background: #7f8c8d;
            }
            
            .request-info {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                border-left: 4px solid #3498db;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        
        <div class="respond-container">
            <h1><i class="fas fa-reply"></i> Phản hồi Yêu cầu Hỗ trợ</h1>
            
            <div class="request-info">
                <p><strong>Yêu cầu ID:</strong> #<%= supportID %></p>
                <p><small>Vui lòng viết phản hồi chi tiết và chuyên nghiệp cho khách hàng.</small></p>
            </div>
            
            <form action="../RespondSupportServlet" method="post">
                <input type="hidden" name="supportID" value="<%= supportID %>">
                
                <div class="form-group">
                    <label for="response">Nội dung phản hồi:</label>
                    <textarea id="response" name="response" 
                              placeholder="Nhập nội dung phản hồi cho khách hàng..." 
                              required></textarea>
                </div>
                
                <div class="form-group">
                    <a href="admin-support.jsp" class="btn-back">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-paper-plane"></i> Gửi phản hồi
                    </button>
                </div>
            </form>
        </div>
        
        <jsp:include page="footer.jsp" />
    </body>
</html>