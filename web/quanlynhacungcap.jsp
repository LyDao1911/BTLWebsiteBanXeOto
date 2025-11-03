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
        <title>Quản lý Nhà Cung Cấp</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <--<!-- comment <style>
            /* CSS cho layout 2 cột (giống danhmuc.jsp) */
            .container {
                display: flex;
                max-width: 1300px;
                margin: 50px auto;
                gap: 30px;
                align-items: flex-start;
            }
            .left-panel {
                flex: 0 0 350px;
                background-color: #fff;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                position: sticky;
                top: 100px;
            }
            .right-panel {
                flex: 1;
                background-color: #fff;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            /* ... (sao chép các CSS khác từ danhmuc.jsp nếu cần: .btn, .table, .form-group) ... */
        </style>-->
    </head>
    <body>
        <%-- (Copy Header của cậu vào đây) --%>
        <jsp:include page="header.jsp" /> 

        <main class="container">

            <div class="left-panel">
                <h3 class="mb-4">
                    <c:if test="${empty supplierToEdit}">Thêm Nhà Cung Cấp</c:if>
                    <c:if test="${not empty supplierToEdit}">Sửa Nhà Cung Cấp (ID: ${supplierToEdit.supplierID})</c:if>
                    </h3>

                    <form action="SupplierServlet" method="POST">

                    <c:if test="${not empty supplierToEdit}">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="supplierID" value="${supplierToEdit.supplierID}">
                    </c:if>
                    <c:if test="${empty supplierToEdit}">
                        <input type="hidden" name="action" value="add">
                    </c:if>

                    <div class="form-group">
                        <label>Tên Nhà Cung Cấp</label>
                        <input type="text" name="supplierName" value="${supplierToEdit.supplierName}" class="input" required>
                    </div>
                    <div class="form-group">
                        <label>Số Điện Thoại</label>
                        <input type="text" name="phoneNumber" value="${supplierToEdit.phoneNumber}" class="input">
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="${supplierToEdit.email}" class="input">
                    </div>
                    <div class="form-group">
                        <label>Địa Chỉ</label>
                        <textarea name="address" rows="3" class="input">${supplierToEdit.address}</textarea>
                    </div>

                    <div class="btn-group-vertical">
                        <button type="submit" class="btn btn-success">
                            <c:if test="${empty supplierToEdit}">➕ Thêm</c:if>
                            <c:if test="${not empty supplierToEdit}">✏️ Cập Nhật</c:if>
                            </button>
                        <c:if test="${not empty supplierToEdit}">
                            <a href="SupplierServlet" class="btn btn-warning">Hủy Sửa</a>
                        </c:if>
                    </div>
                </form>
            </div>

            <div class="right-panel">
                <h3 class="mb-4">Danh Sách Nhà Cung Cấp</h3>
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
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
                                <td>${supplier.supplierID}</td>
                                <td>${supplier.supplierName}</td>
                                <td>${supplier.phoneNumber}</td>
                                <td>${supplier.email}</td>
                                <td>${supplier.address}</td>
                                <td>
                                    <a href="SupplierServlet?action=edit&id=${supplier.supplierID}" class="btn btn-warning btn-sm">Sửa</a>
                                    <a href="SupplierServlet?action=delete&id=${supplier.supplierID}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn chắc chắn muốn xóa NCC: ${supplier.supplierName}?');">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty supplierList}">
                            <tr><td colspan="6">Chưa có nhà cung cấp nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>

        <%-- (Copy Footer của cậu vào đây) --%>
        <jsp:include page="footer.jsp" />
    </body>
</html>
