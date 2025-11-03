<%-- 
    Document   : danhmuc
    Created on : Oct 19, 2025, 5:47:35 PM
    Author     : Hong Ly
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Brand"%>



<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh mục - Velyra Aero</title>
        <link rel="stylesheet" href="style.css" />
        <!-- Font Awesome --> 
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