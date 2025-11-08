<%-- 
    Document   : hotro
    Created on : Oct 15, 2025, 10:14:14 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="model.UserAccount" %>
<%@page import="dao.CustomerDAO" %>
<%@page import="model.Customer" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hỗ trợ - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <!-- Font Awesome --> 
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            /* Giữ nguyên CSS cũ của bạn */
            body{
                 background: url('image/tt.jpg') ; 
            }
            
            .contact-section {
                display: flex;
                justify-content: space-between;
                max-width: 1200px;
                margin: 40px auto;
                padding: 0 20px;
                gap: 40px;
            }

            .contact-left {
                flex: 1;
                background-color: #f9f9f9;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .contact-form {
                flex: 1;
                background-color: #f9f9f9;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .contact-left h2 {
                color: #333;
                margin-bottom: 20px;
                border-bottom: 2px solid #e74c3c;
                padding-bottom: 10px;
            }

            .contact-left p {
                margin-bottom: 15px;
                line-height: 1.6;
            }

            .contact-info {
                background: white;
                padding: 20px;
                border-radius: 8px;
                margin-top: 20px;
                border-left: 4px solid #e74c3c;
            }

            .contact-info h3 {
                color: #e74c3c;
                margin-bottom: 15px;
            }

            .contact-info-item {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }

            .contact-info-item i {
                color: #e74c3c;
                margin-right: 10px;
                width: 20px;
            }

            .contact-form label {
                display: block;
                margin-bottom: 8px;
                font-weight: bold;
                color: #333;
            }

            .contact-form .required::after {
                content: " *";
                color: #e74c3c;
            }

            .contact-form input, .contact-form textarea, .contact-form select {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 16px;
                box-sizing: border-box;
                font-family: inherit;
                margin-bottom: 15px;
            }

            .contact-form input:focus, .contact-form textarea:focus, .contact-form select:focus {
                border-color: #e74c3c;
                outline: none;
                box-shadow: 0 0 5px rgba(231, 76, 60, 0.3);
            }

            .contact-form textarea {
                height: 150px;
                resize: vertical;
            }

            .contact-form button {
                background-color: #e74c3c;
                color: white;
                border: none;
                padding: 12px 25px;
                font-size: 16px;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.3s;
                width: 100%;
                font-weight: bold;
            }

            .contact-form button:hover {
                background-color: #c0392b;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }

            .message {
                padding: 15px;
                margin: 20px 0;
                border-radius: 4px;
                text-align: center;
                font-weight: bold;
            }

            .success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .warning {
                background-color: #fff3cd;
                color: #856404;
                border: 1px solid #ffeaa7;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .login-prompt {
                background: #e8f4ff;
                padding: 15px;
                border-radius: 6px;
                margin-bottom: 20px;
                border-left: 4px solid #3498db;
            }

            .login-prompt a {
                color: #3498db;
                text-decoration: none;
                font-weight: bold;
            }

            .login-prompt a:hover {
                text-decoration: underline;
            }

            .user-info {
                background: #e8f5e8;
                padding: 15px;
                border-radius: 6px;
                margin-bottom: 20px;
                border-left: 4px solid #4CAF50;
            }

            @media (max-width: 768px) {
                .contact-section {
                    flex-direction: column;
                    gap: 20px;
                }

                .contact-left, .contact-form {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <%
            // DEBUG SESSION IN JSP
            System.out.println("=== DEBUG SESSION IN HOTRO.JSP ===");
            HttpSession userSession = request.getSession(false);
            if (userSession != null) {
                System.out.println("Session ID: " + userSession.getId());
                java.util.Enumeration<String> attrNames = userSession.getAttributeNames();
                while (attrNames.hasMoreElements()) {
                    String name = attrNames.nextElement();
                    Object value = userSession.getAttribute(name);
                    System.out.println(name + " = " + value);
                }
            } else {
                System.out.println("No session in JSP");
            }

            String message = "";
            String messageType = "";

            // Xử lý thông báo từ Servlet
            String result = request.getParameter("message");
            if ("success".equals(result)) {
                message = "✅ Yêu cầu hỗ trợ của bạn đã được gửi thành công! Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất.";
                messageType = "success";
            } else if ("error".equals(result)) {
                String detail = request.getParameter("detail");
                message = "❌ Có lỗi xảy ra khi gửi yêu cầu. " + (detail != null ? detail : "Vui lòng thử lại hoặc liên hệ trực tiếp qua số điện thoại 1800 6061!");
                messageType = "error";
            } else if ("validation_error".equals(result)) {
                message = "⚠️ Vui lòng điền đầy đủ các trường bắt buộc!";
                messageType = "error";
            }

            // Lấy thông tin user từ session
            UserAccount userAccount = (UserAccount) session.getAttribute("userAccount");
            String username = (String) session.getAttribute("username");
            boolean isLoggedIn = userAccount != null;
            
            // Lấy thông tin Customer từ database
            Customer customer = null;
            String customerName = "";
            String customerEmail = "";
            String customerPhone = "";
            String customerAddress = "";
            
            if (isLoggedIn) {
                CustomerDAO customerDAO = new CustomerDAO();
                customer = customerDAO.getCustomerByUsername(userAccount.getUsername());
                
                if (customer != null) {
                    customerName = customer.getFullName();
                    customerEmail = customer.getEmail();
                    customerPhone = customer.getPhoneNumber();
                    customerAddress = customer.getAddress();
                }
            }
        %>

        <section class="contact-section">
            <div class="contact-left">
                <h2>LIÊN HỆ HỖ TRỢ</h2>
                <p>Chúng tôi luôn sẵn sàng hỗ trợ bạn mọi lúc, mọi nơi. Đội ngũ chăm sóc khách hàng của Velyra Aero sẽ giải đáp mọi thắc mắc và hỗ trợ bạn nhanh chóng, hiệu quả nhất.</p>

                <div class="contact-info">
                    <h3><i class="fas fa-headset"></i> Thông tin liên hệ</h3>

                    <div class="contact-info-item">
                        <i class="fas fa-phone"></i>
                        <div>
                            <strong>Tổng đài hỗ trợ: 1800 6061</strong><br>
                            <small>Miễn phí từ 9h - 11h, 13h - 17h (Thứ 2 - Thứ 6)</small>
                        </div>
                    </div>

                    <div class="contact-info-item">
                        <i class="fas fa-envelope"></i>
                        <div>
                            <strong>Email: support@velyraaero.com</strong><br>
                            <small>Phản hồi trong vòng 24 giờ</small>
                        </div>
                    </div>

                    <div class="contact-info-item">
                        <i class="fas fa-clock"></i>
                        <div>
                            <strong>Thời gian làm việc</strong><br>
                            <small>Thứ 2 - Thứ 6: 9h00 - 11h00 & 13h00 - 17h00</small>
                        </div>
                    </div>

                    <div class="contact-info-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <div>
                            <strong>Văn phòng chính</strong><br>
                            <small>Số 123, Đường ABC, Quận XYZ, TP. Hồ Chí Minh</small>
                        </div>
                    </div>
                </div>

                <div style="margin-top: 25px; padding: 15px; background: #f8f9fa; border-radius: 6px;">
                    <h4 style="color: #2c3e50; margin-bottom: 10px;"><i class="fas fa-lightbulb"></i> Lưu ý khi gửi yêu cầu</h4>
                    <ul style="color: #555; line-height: 1.6; padding-left: 20px;">
                        <li>Vui lòng cung cấp thông tin chính xác để chúng tôi có thể liên hệ lại</li>
                        <li>Mô tả chi tiết vấn đề bạn gặp phải</li>
                        <li>Thời gian phản hồi: 1-2 ngày làm việc</li>
                    </ul>
                </div>
            </div>

            <div class="contact-form">
                <h2>GỬI YÊU CẦU HỖ TRỢ</h2>

                <!-- Hiển thị trạng thái đăng nhập -->
                <div class="<%= isLoggedIn ? "user-info" : "login-prompt"%>">
                    <%
                        if (isLoggedIn) {
                    %>
                        <strong>✅ Đã đăng nhập:</strong> <%= username != null ? username : "User" %> 
                        <% if (customer != null) { %>
                            (CustomerID: <%= customer.getCustomerID() %>)
                        <% } %>
                    <%
                        } else {
                    %>
                        <strong>🔐 Vui lòng đăng nhập:</strong> Bạn cần <a href="dangnhap.jsp">đăng nhập</a> để gửi yêu cầu hỗ trợ.
                    <%
                        }
                    %>
                </div>

                <% if (!message.isEmpty()) {%>
                <div class="message <%= messageType%>">
                    <%= message%>
                </div>
                <% }%>

                <!-- Form gửi đến HotroServlet -->
                <form action="HotroServlet" method="post" id="supportForm" <%= !isLoggedIn ? "onsubmit=\"return checkLogin();\"" : "" %>>
                    <div class="form-group">
                        <label for="hoten" class="required">Họ tên</label>
                        <input type="text" name="hoten" id="hoten" required 
                               placeholder="Nhập họ và tên đầy đủ"
                               value="<%= isLoggedIn ? customerName : ""%>"
                               <%= !isLoggedIn ? "readonly" : "" %>>
                    </div>

                    <div class="form-group">
                        <label for="email" class="required">Email</label>
                        <input type="email" name="email" id="email" required 
                               placeholder="Nhập địa chỉ email"
                               value="<%= isLoggedIn ? customerEmail : ""%>"
                               <%= !isLoggedIn ? "readonly" : "" %>>
                    </div>

                    <div class="form-group">
                        <label for="sdt" class="required">Số điện thoại</label>
                        <input type="text" name="sdt" id="sdt" required 
                               placeholder="Nhập số điện thoại"
                               value="<%= isLoggedIn ? customerPhone : ""%>"
                               pattern="[0-9]{10,11}" 
                               title="Số điện thoại phải có 10-11 chữ số"
                               <%= !isLoggedIn ? "readonly" : "" %>>
                    </div>

                    <div class="form-group">
                        <label for="diachi">Địa chỉ</label>
                        <input type="text" name="diachi" id="diachi" 
                               placeholder="Nhập địa chỉ (không bắt buộc)"
                               value="<%= isLoggedIn ? customerAddress : ""%>"
                               <%= !isLoggedIn ? "readonly" : "" %>>
                    </div>

                    <div class="form-group">
                        <label for="subject" class="required">Tiêu đề yêu cầu</label>
                        <select name="subject" id="subject" required <%= !isLoggedIn ? "disabled" : "" %>>
                            <option value="">-- Chọn loại hỗ trợ --</option>
                            <option value="Hỗ trợ đặt hàng">Hỗ trợ đặt hàng</option>
                            <option value="Tư vấn sản phẩm">Tư vấn sản phẩm</option>
                            <option value="Khiếu nại dịch vụ">Khiếu nại dịch vụ</option>
                            <option value="Hỗ trợ kỹ thuật">Hỗ trợ kỹ thuật</option>
                            <option value="Bảo hành, bảo trì">Bảo hành, bảo trì</option>
                            <option value="Hợp tác kinh doanh">Hợp tác kinh doanh</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="noidung" class="required">Nội dung cần hỗ trợ</label>
                        <textarea name="noidung" id="noidung" required 
                                  placeholder="Mô tả chi tiết vấn đề bạn gặp phải..."
                                  <%= !isLoggedIn ? "readonly" : "" %>></textarea>
                    </div>

                    <button type="submit" <%= !isLoggedIn ? "disabled" : "" %>>
                        <i class="fas fa-paper-plane"></i> 
                        <%= isLoggedIn ? "GỬI YÊU CẦU HỖ TRỢ" : "VUI LÒNG ĐĂNG NHẬP" %>
                    </button>
                </form>
            </div>
        </section>

        <jsp:include page="footer.jsp" />

        <script>
            // Kiểm tra đăng nhập trước khi gửi form
            function checkLogin() {
                const isLoggedIn = <%= isLoggedIn %>;
                if (!isLoggedIn) {
                    alert('Vui lòng đăng nhập để gửi yêu cầu hỗ trợ!');
                    window.location.href = 'dangnhap.jsp?redirect=hotro';
                    return false;
                }
                return true;
            }

            // JavaScript để xử lý form
            document.getElementById('supportForm')?.addEventListener('submit', function (e) {
                const isLoggedIn = <%= isLoggedIn %>;
                
                if (!isLoggedIn) {
                    e.preventDefault();
                    alert('Vui lòng đăng nhập để gửi yêu cầu hỗ trợ!');
                    window.location.href = 'dangnhap.jsp?redirect=hotro';
                    return false;
                }

                // Validate số điện thoại
                const phoneInput = document.getElementById('sdt');
                const phoneRegex = /^[0-9]{10,11}$/;

                if (!phoneRegex.test(phoneInput.value)) {
                    alert('Số điện thoại không hợp lệ! Vui lòng nhập 10-11 chữ số.');
                    phoneInput.focus();
                    e.preventDefault();
                    return false;
                }

                // Validate email
                const emailInput = document.getElementById('email');
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                if (!emailRegex.test(emailInput.value)) {
                    alert('Email không hợp lệ! Vui lòng kiểm tra lại.');
                    emailInput.focus();
                    e.preventDefault();
                    return false;
                }

                // Hiển thị loading
                const submitBtn = this.querySelector('button[type="submit"]');
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ĐANG GỬI...';
                submitBtn.disabled = true;
            });

            // Kích hoạt các field nếu đã đăng nhập
            window.addEventListener('load', function () {
                const isLoggedIn = <%= isLoggedIn %>;
                if (isLoggedIn) {
                    console.log('Thông tin user đã được tự động điền');
                    
                    // Kích hoạt select nếu bị disabled
                    const subjectSelect = document.getElementById('subject');
                    if (subjectSelect && subjectSelect.disabled) {
                        subjectSelect.disabled = false;
                    }
                    
                    // Kích hoạt textarea nếu bị readonly
                    const textarea = document.getElementById('noidung');
                    if (textarea && textarea.readOnly) {
                        textarea.readOnly = false;
                    }
                }
            });
        </script>
    </body>
</html>