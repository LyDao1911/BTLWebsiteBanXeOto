/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BrandDAO;
import model.Brand;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

/**
 *
 * @author Hong Ly
 */
@WebServlet(name = "BrandServlet", urlPatterns = {"/BrandServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)

public class BrandServlet extends HttpServlet {

    private final BrandDAO brandDAO = new BrandDAO();

    private static final String UPLOAD_DIR = "uploads";

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Brand> brandList = brandDAO.getAllBrands();

        // Gửi danh sách này qua trang JSP
        request.setAttribute("brandList", brandList);

        // Chuyển tiếp đến trang JSP
        request.getRequestDispatcher("danhmuc.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Lấy hành động (add, update, delete) từ tên của nút submit
        String action = request.getParameter("action");
        if (action == null) {
            action = ""; // Mặc định
        }

        try {
            // Lấy dữ liệu từ form
            String brandName = request.getParameter("brandName");
            String brandIDStr = request.getParameter("brandID"); // Dùng cho Sửa/Xóa
            Part filePart = request.getPart("brandImage"); // Lấy file upload

            // 1. Lưu file ảnh (nếu có)
            String fileName = saveFile(filePart, request); // "fileName" sẽ là null nếu không upload

            // 2. Chuẩn bị đối tượng Brand
            Brand brand = new Brand();
            if (brandIDStr != null && !brandIDStr.isEmpty()) {
                brand.setBrandID(Integer.parseInt(brandIDStr));
            }
            brand.setBrandName(brandName);
            if (fileName != null) { // Chỉ cập nhật tên file nếu có upload file mới
                brand.setLogoURL(fileName);
            }

            // 3. Thực hiện hành động
            switch (action) {
                case "add":
                    brandDAO.addBrand(brand);
                    break;
                case "update":
                    if (fileName != null) {
                        // Nếu user CÓ tải ảnh mới
                        brand.setLogoURL(fileName);
                        brandDAO.updateBrandWithLogo(brand);
                    } else {
                        // Nếu user KHÔNG tải ảnh mới (chỉ sửa tên)
                        brandDAO.updateBrandNoLogo(brand);
                    }
                    break;
                case "delete":
                    brandDAO.deleteBrand(brand.getBrandID());
                    // (Cậu nên thêm code xóa file ảnh cũ trong thư mục uploads ở đây)
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi (ví dụ: gửi thông báo lỗi)
        }

        // 4. Quan trọng: Tải lại trang (bằng cách gọi lại doGet)
        response.sendRedirect("BrandServlet");
    }

    /**
     * Hàm phụ: Lưu file upload vào thư mục "uploads" Trả về tên file nếu thành
     * công, trả về null nếu không có file
     */
    private String saveFile(Part part, HttpServletRequest request) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null; // Không có file
        }

        // Lấy tên file gốc
        String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

        // Lấy đường dẫn tuyệt đối của thư mục "uploads"
        // (Thư mục "uploads" phải được tạo thủ công trong "Web Pages" (web))
        String uploadPath = request.getServletContext().getRealPath("") + UPLOAD_DIR;

        // Tạo thư mục nếu chưa có
        Path uploadDirPath = Paths.get(uploadPath);
        if (!Files.exists(uploadDirPath)) {
            Files.createDirectories(uploadDirPath);
        }

        // Ghi file
        try (InputStream input = part.getInputStream()) {
            Path filePath = uploadDirPath.resolve(fileName);
            Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        return fileName;
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
