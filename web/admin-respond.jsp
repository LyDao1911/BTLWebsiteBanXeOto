<%@page import="dao.SupportRequestDAO"%>
<%@page import="model.SupportRequest"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    SupportRequest supportRequest = null;
    try {
        String supportIDStr = request.getParameter("supportID");
        if (supportIDStr != null) {
            int supportID = Integer.parseInt(supportIDStr);
            SupportRequestDAO dao = new SupportRequestDAO();
            supportRequest = dao.getSupportRequestById(supportID);
            request.setAttribute("supportRequest", supportRequest);
        }
    } catch (NumberFormatException e) {
        request.setAttribute("errorMessage", "ID yêu cầu không hợp lệ.");
    } catch (Exception e) {
        request.setAttribute("errorMessage", "Lỗi khi tải chi tiết yêu cầu: " + e.getMessage());
    }

    if (request.getParameter("success") != null) {
        request.setAttribute("successMessage", "Phản hồi đã được gửi và trạng thái đã được cập nhật!");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Phản hồi yêu cầu hỗ trợ | VELYRA AERO</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            /* ================================================= */
            /* 🚗 ADMIN RESPOND PAGE - LUXURY STYLE */
            /* ================================================= */

            body {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .respond-container {
                max-width: 1200px;
                margin: 120px auto 60px;
                padding: 0 40px;
            }

            /* Header sang trọng */
            .page-header {
                text-align: center;
                margin-bottom: 50px;
                position: relative;
            }

            .page-header h2 {
                font-size: 2.8rem;
                font-weight: 300;
                color: #1a1a1a;
                margin-bottom: 15px;
                letter-spacing: 2px;
                text-transform: uppercase;
            }

            .page-header h2 i {
                color: #e52b2b;
                margin-right: 20px;
                font-size: 2.5rem;
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

            /* Request Detail Card */
            .request-detail-card {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 15px 50px rgba(0, 0, 0, 0.1);
                padding: 40px;
                margin-bottom: 40px;
                border: 1px solid rgba(229, 43, 43, 0.1);
            }

            .detail-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 25px;
                margin-bottom: 30px;
            }

            .detail-item {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .detail-label {
                font-size: 0.85rem;
                color: #666;
                text-transform: uppercase;
                letter-spacing: 1px;
                font-weight: 600;
            }

            .detail-value {
                font-size: 1.1rem;
                color: #333;
                font-weight: 500;
            }

            /* Status Badge */
            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 8px 20px;
                border-radius: 25px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .status-pending {
                background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
                color: #f57c00;
                border: 1px solid #ffb74d;
            }

            .status-responded {
                background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                color: #388e3c;
                border: 1px solid #81c784;
            }

            .status-closed {
                background: linear-gradient(135deg, #f5f5f5 0%, #eeeeee 100%);
                color: #757575;
                border: 1px solid #bdbdbd;
            }

            /* Message Boxes */
            .message-box {
                padding: 25px;
                border-radius: 15px;
                margin: 25px 0;
                border-left: 4px solid;
                position: relative;
                overflow: hidden;
            }

            .customer-message {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border-left-color: #e52b2b;
            }

            .admin-response {
                background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
                border-left-color: #2196f3;
            }

            .message-box::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(45deg, transparent, rgba(255,255,255,0.3), transparent);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .message-box:hover::before {
                opacity: 1;
            }

            .message-header {
                font-size: 0.9rem;
                color: #666;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 10px;
                font-weight: 600;
            }

            .message-content {
                white-space: pre-wrap;
                line-height: 1.7;
                color: #444;
                font-size: 1rem;
            }

            /* Form Styling */
            .respond-form {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 15px 50px rgba(0, 0, 0, 0.1);
                padding: 40px;
                border: 1px solid rgba(229, 43, 43, 0.1);
            }

            .form-group {
                margin-bottom: 30px;
            }

            .form-label {
                display: block;
                font-size: 1rem;
                color: #333;
                margin-bottom: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .form-textarea {
                width: 100%;
                padding: 20px;
                border: 2px solid #e9ecef;
                border-radius: 12px;
                font-size: 1rem;
                line-height: 1.6;
                resize: vertical;
                transition: all 0.3s ease;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .form-textarea:focus {
                outline: none;
                border-color: #e52b2b;
                box-shadow: 0 0 0 3px rgba(229, 43, 43, 0.1);
            }

            .form-select {
                width: 100%;
                padding: 15px 20px;
                border: 2px solid #e9ecef;
                border-radius: 12px;
                font-size: 1rem;
                background: #fff;
                transition: all 0.3s ease;
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%23333' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 20px center;
            }

            .form-select:focus {
                outline: none;
                border-color: #e52b2b;
                box-shadow: 0 0 0 3px rgba(229, 43, 43, 0.1);
            }

            /* Buttons */
            .btn-group {
                display: flex;
                gap: 15px;
                align-items: center;
                flex-wrap: wrap;
            }

            .btn-submit {
                display: inline-flex;
                align-items: center;
                gap: 10px;
                padding: 16px 35px;
                background: linear-gradient(135deg, #e52b2b 0%, #b30000 100%);
                color: white;
                text-decoration: none;
                border-radius: 25px;
                font-size: 1rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                position: relative;
                overflow: hidden;
            }

            .btn-submit::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn-submit:hover::before {
                left: 100%;
            }

            .btn-submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(229, 43, 43, 0.3);
            }

            .btn-back {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 14px 25px;
                background: transparent;
                color: #666;
                text-decoration: none;
                border-radius: 25px;
                font-size: 0.9rem;
                font-weight: 500;
                transition: all 0.3s ease;
                border: 2px solid #e9ecef;
            }

            .btn-back:hover {
                background: #f8f9fa;
                color: #333;
                border-color: #ddd;
                transform: translateY(-1px);
            }

            /* Thông báo */
            .message {
                padding: 20px 25px;
                border-radius: 15px;
                margin-bottom: 30px;
                border-left: 4px solid;
                font-weight: 500;
                position: relative;
                overflow: hidden;
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

            /* Empty State */
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

            .empty-state h2 {
                color: #333;
                font-size: 1.8rem;
                margin-bottom: 15px;
                font-weight: 400;
            }

            .empty-state p {
                color: #666;
                font-size: 1.1rem;
                line-height: 1.6;
                margin-bottom: 25px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .respond-container {
                    margin: 100px auto 40px;
                    padding: 0 20px;
                }

                .page-header h2 {
                    font-size: 2.2rem;
                }

                .request-detail-card,
                .respond-form {
                    padding: 25px;
                    border-radius: 15px;
                }

                .detail-grid {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .btn-group {
                    flex-direction: column;
                    align-items: stretch;
                }

                .btn-submit,
                .btn-back {
                    justify-content: center;
                    text-align: center;
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

            .request-detail-card,
            .respond-form {
                animation: fadeInUp 0.6s ease;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="respond-container">
            <%-- Thông báo --%>
            <c:if test="${not empty errorMessage}">
                <div class="message error">
                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="message success">
                    <i class="fas fa-check-circle"></i> ${successMessage}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty supportRequest}">
                    <div class="page-header">
                        <h2><i class="fas fa-reply"></i> Phản hồi yêu cầu hỗ trợ #${supportRequest.supportID}</h2>
                    </div>

                    <%-- Chi tiết yêu cầu --%>
                    <div class="request-detail-card">
                        <div class="detail-grid">
                            <div class="detail-item">
                                <span class="detail-label">Trạng thái</span>
                                <c:choose>
                                    <c:when test="${supportRequest.status eq 'Pending'}">
                                        <span class="status-badge status-pending">
                                            <i class="fas fa-clock"></i> Chờ xử lý
                                        </span>
                                    </c:when>
                                    <c:when test="${supportRequest.status eq 'Responded'}">
                                        <span class="status-badge status-responded">
                                            <i class="fas fa-check-circle"></i> Đã phản hồi
                                        </span>
                                    </c:when>
                                    <c:when test="${supportRequest.status eq 'Closed'}">
                                        <span class="status-badge status-closed">
                                            <i class="fas fa-lock"></i> Đã đóng
                                        </span>
                                    </c:when>
                                </c:choose>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Khách hàng</span>
                                <span class="detail-value">${supportRequest.fullName}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Email</span>
                                <span class="detail-value">${supportRequest.email}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Điện thoại</span>
                                <span class="detail-value">${supportRequest.phoneNumber}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Ngày gửi</span>
                                <span class="detail-value">${supportRequest.createdAt}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Chủ đề</span>
                                <span class="detail-value">${supportRequest.subject}</span>
                            </div>
                        </div>

                        <%-- Nội dung khách hàng --%>
                        <div class="message-box customer-message">
                            <div class="message-header">
                                <i class="fas fa-user"></i> Nội dung từ khách hàng
                            </div>
                            <div class="message-content">${supportRequest.message}</div>
                        </div>

                        <%-- Phản hồi cũ --%>
                        <c:if test="${not empty supportRequest.response}">
                            <div class="message-box admin-response">
                                <div class="message-header">
                                    <i class="fas fa-headset"></i> Phản hồi trước đó
                                    <c:if test="${not empty supportRequest.respondentID}">
                                        <span style="float: right; font-size: 0.8rem;">
                                            Người phản hồi: #${supportRequest.respondentID}
                                        </span>
                                    </c:if>
                                </div>
                                <div class="message-content">${supportRequest.response}</div>
                            </div>
                        </c:if>
                    </div>

                    <%-- Form phản hồi --%>
                    <div class="respond-form">
                        <form action="RespondSupportServlet" method="post">
                            <input type="hidden" name="supportID" value="${supportRequest.supportID}">

                            <div class="form-group">
                                <label for="response" class="form-label">
                                    <i class="fas fa-edit"></i> Nội dung phản hồi
                                </label>
                                <textarea name="response" id="response" class="form-textarea" rows="8" required 
                                          placeholder="Nhập nội dung phản hồi cho khách hàng...">${supportRequest.response}</textarea>
                            </div>

                            <div class="form-group">
                                <label for="status" class="form-label">
                                    <i class="fas fa-sync-alt"></i> Cập nhật trạng thái
                                </label>
                                <select name="status" id="status" class="form-select" required>
                                    <option value="Pending" ${supportRequest.status eq 'Pending' ? 'selected' : ''}>Chờ xử lý (Pending)</option>
                                    <option value="Responded" ${supportRequest.status eq 'Responded' ? 'selected' : ''}>Đã Phản hồi (Responded)</option>
                                    <option value="Closed" ${supportRequest.status eq 'Closed' ? 'selected' : ''}>Đã đóng (Closed)</option>
                                </select>
                            </div>

                            <div class="btn-group">
                                <button type="submit" class="btn-submit">
                                    <i class="fas fa-paper-plane"></i> Gửi Phản hồi & Cập nhật
                                </button>
                                <a href="AdminSupportServlet" class="btn-back">
                                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                                </a>
                            </div>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-exclamation-triangle"></i>
                        <h2>Không tìm thấy Yêu cầu Hỗ trợ</h2>
                        <p>Yêu cầu hỗ trợ #${param.supportID} không tồn tại hoặc ID không hợp lệ.</p>
                        <a href="AdminSupportServlet" class="btn-back">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>