<%-- 
    Document   : dangxuat
    Created on : Oct 19, 2025, 10:40:36 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    session.invalidate(); // Xóa toàn bộ session
    response.sendRedirect("trangchu.jsp"); // Quay về trang chủ
%>
