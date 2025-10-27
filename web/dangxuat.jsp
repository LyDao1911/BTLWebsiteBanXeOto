<%-- 
    Document   : dangxuat
<<<<<<< Updated upstream
    Created on : Oct 19, 2025, 10:40:36 AM
    Author     : Admin
=======
    Created on : Oct 19, 2025, 11:21:12 AM
    Author     : Hong Ly
>>>>>>> Stashed changes
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    session.invalidate(); // Xóa toàn bộ session
    response.sendRedirect("HomeServlet"); // Quay về trang chủ
%>
%>

