<%-- 
    Document   : danhmuc
    Created on : Oct 19, 2025, 5:47:35 PM
    Author     : Hong Ly
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Brand"%>

<!DOCTYPE html>
<style>
/* ======================================= */
/* ====== TRANG QUẢN LÝ DANH MỤC (.JSP) ====== */
/* ======================================= */

.container {
    display: flex; /* Bố cục hai cột */
    max-width: 1300px;
    margin: 50px auto; /* Canh giữa và tạo khoảng cách với header/footer */
    padding: 20px;
    gap: 30px; /* Khoảng cách giữa hai panel */
    align-items: flex-start; /* Canh trên cùng */
    flex-wrap: wrap; /* Cho phép xuống dòng trên màn hình nhỏ */
}

/* -------------------- */
/* --- CỘT TRÁI (LEFT PANEL) --- */
/* -------------------- */

.left-panel {
    flex: 0 0 350px; /* Chiếm cố định 350px */
    background-color: #fff;
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    position: sticky; /* Giữ panel lại khi cuộn */
    top: 100px;
}

.left-panel img#preview {
    width: 100%;
    height: 200px;
    object-fit: cover;
    border: 2px solid #ddd;
    border-radius: 8px;
    margin-bottom: 15px;
    background-color: #f7f7f7;
}

.form-group label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
    color: #333;
}

.left-panel input[type="text"] {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-sizing: border-box;
    font-size: 16px;
    transition: border-color 0.3s;
}

.left-panel input[type="file"].form-control {
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 8px;
    cursor: pointer;
    background-color: #f9f9f9;
}

/* -------------------- */
/* --- BUTTONS --- */
/* -------------------- */

/* Điều chỉnh lại style cho các button (dựa trên class Bootstrap) */
.btn {
    display: block;
    width: 100%;
    padding: 12px 20px;
    margin-bottom: 15px;
    font-size: 16px;
    font-weight: bold;
    text-align: center;
    border-radius: 6px;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.1s;
    border: none;
    color: #fff;
    text-decoration: none;
}

.btn-group-vertical {
    display: flex;
    flex-direction: column;
    margin-top: 20px;
}

/* Màu sắc theo theme */
.btn-success {
    background-color: #0d6efd; /* Blue */
}

.btn-warning {
    background-color: #ffc107; /* Yellow */
    color: #212529;
}

.btn-danger {
    background-color: #dc3545; /* Red */
}

.btn-success:hover {
    background-color: #0b5ed7;
}
.btn-warning:hover {
    background-color: #ffcd39;
}
.btn-danger:hover {
    background-color: #c9303c;
}


/* -------------------- */
/* --- CỘT PHẢI (RIGHT PANEL - TABLE) --- */
/* -------------------- */

.right-panel {
    flex: 1; /* Chiếm phần còn lại của không gian */
    padding: 25px;
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.right-panel h3 {
    color: #d60000; /* Màu đỏ chủ đạo */
    margin-bottom: 20px;
    font-size: 22px;
    border-bottom: 2px solid #eee;
    padding-bottom: 10px;
}
/* --- TABLE STYLING --- */

.table {
    width: 100%;
    border-collapse: collapse; /* Loại bỏ khoảng cách giữa các cell */
    text-align: left;
    font-size: 15px;
}

.table-dark th {
    background-color: #212529; /* Nền đen cho header */
    color: #fff;
    padding: 15px 15px;
    border: 1px solid #3a3f44;
}

.table-bordered th, .table-bordered td {
    border: 1px solid #dee2e6;
    padding: 12px 15px;
}

.table tbody tr:nth-child(even) {
    background-color: #f8f9fa; /* Màu xen kẽ cho dễ nhìn */
}

.table-hover tbody tr:hover {
    background-color: #ffe0e0; /* Hover nhẹ màu đỏ hồng */
    cursor: pointer;
}

.table img {
    display: block;
    max-width: 100%;
    height: auto;
    border-radius: 4px;
    border: 1px solid #eee;
}
</style>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh mục - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    </head>
    <body>

        <jsp:include page="header.jsp" />

        <div class="container">

            <div class="left-panel">

                <form action="BrandServlet" method="post" enctype="multipart/form-data">

                    <input type="hidden" name="brandID" id="brandID_input">

                    <img id="preview" src="image/default.jpg" alt="Ảnh thương hiệu">
                    <input type="file" name="brandImage" accept="image/*" class="form-control mb-3" onchange="previewImage(event)">

                    <div class="form-group">
                        <label>Tên hãng xe:</label>
                        <input type="text" name="brandName" id="brandName_input">
                    </div><br><br>

                    <div class="btn-group-vertical w-100">
                        <button type="submit" class="btn btn-success" name="action" value="add">➕ Thêm</button>
                        <button type="submit" class="btn btn-warning" name="action" value="update">✏️ Sửa</button>
                        <button type="submit" class="btn btn-danger" name="action" value="delete">🗑️ Xóa</button>
                    </div>
                </form>
            </div>

            <div class="right-panel">
                <h3 class="text-center mb-4">Danh sách thương hiệu</h3>
                <table class="table table-bordered table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>BrandID</th>
                            <th>BrandName</th>
                            <th>LogoURL</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Brand> brandList = (List<Brand>) request.getAttribute("brandList");
                            if (brandList != null && !brandList.isEmpty()) {
                                for (Brand b : brandList) {
                        %>
                       <tr onclick="fillForm('<%= b.getBrandID()%>', '<%= b.getBrandName()%>', '<%= request.getContextPath() %>/uploads/<%= b.getLogoURL()%>')">
                            <td><%= b.getBrandID()%></td>
                            <td><%= b.getBrandName()%></td>
                            <td>
                                <% if (b.getLogoURL() != null && !b.getLogoURL().isEmpty()) {%>
                                <img src="<%= request.getContextPath() %>/uploads/logos/<%= b.getLogoURL()%>" alt="Logo" width="80" height="60">
                                <% } else { %>
                                Không có ảnh
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr><td colspan="3">Không có dữ liệu thương hiệu</td></tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <script>
            // Xem trước ảnh chọn từ máy
            function previewImage(event) {
                const reader = new FileReader();
                reader.onload = function () {
                    document.getElementById('preview').src = reader.result;
                }
                reader.readAsDataURL(event.target.files[0]);
            }

            // THÊM SCRIPT NÀY: Điền form khi nhấn vào bảng
            function fillForm(id, name, logoUrl) {
                document.getElementById('brandID_input').value = id;
                document.getElementById('brandName_input').value = name;
                document.getElementById('preview').src = logoUrl;
            }
        </script>
        <jsp:include page="footer.jsp" />

    </body>
</html>