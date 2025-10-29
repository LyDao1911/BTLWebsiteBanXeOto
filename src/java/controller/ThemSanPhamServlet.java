/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import dao.BrandDAO;
import model.Car;
import model.CarImage;
import model.CarStock;
import model.Brand;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import org.apache.commons.fileupload2.core.FileItem;
import org.apache.commons.fileupload2.core.DiskFileItemFactory;
import org.apache.commons.fileupload2.jakarta.servlet6.JakartaServletFileUpload;

/**
 *
 * @author Hong Ly
 */
@WebServlet(name = "ThemSanPhamServlet", urlPatterns = {"/ThemSanPhamServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class ThemSanPhamServlet extends HttpServlet {

    private final BrandDAO brandDAO = new BrandDAO();
    private final CarDAO carDAO = new CarDAO();
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
        request.setAttribute("brandList", brandList);
        request.getRequestDispatcher("themsanpham.jsp").forward(request, response);
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
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        Car car = new Car();
        CarStock stock = new CarStock();
        FileItem mainImageItem = null;
        List<FileItem> thumbItems = new ArrayList<>();

        // 2. Khởi tạo Factory cho việc upload
        DiskFileItemFactory factory = DiskFileItemFactory.builder()
                .setPath(Paths.get(System.getProperty("java.io.tmpdir")))
                .get();

        JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);

        try {
            // 3. Phân tích (parse) request
            List<FileItem> formItems = upload.parseRequest(request);

            // 4. Lặp qua các phần (text và file)
            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    // Nếu là trường text (Tên, Giá, Màu...)
                    processFormField(item, car, stock);
                } else {
                    // Nếu là trường file (Ảnh chính, Ảnh phụ)
                    if ("mainImage".equals(item.getFieldName())) {
                        mainImageItem = item;
                    } else if ("thumbs".equals(item.getFieldName())) {
                        thumbItems.add(item);
                    }
                }
            }

            // 5. Gán các giá trị đã xử lý
            car.setStatus("Available"); // Set giá trị mặc định
            stock.setLastUpdated(LocalDateTime.now()); // Set thời gian

            // 6. LƯU VÀO CSDL (Dùng Transaction của cậu)
            // 6a. Lưu Car và Stock, lấy về CarID mới
            int newCarId = carDAO.insertCarAndStock(car, stock);

            if (newCarId != -1) {
                // 6b. Lưu Ảnh Chính (nếu có)
                if (mainImageItem != null && mainImageItem.getSize() > 0) {
                    String mainImageName = saveFile(mainImageItem, request);
                    CarImage mainImg = new CarImage(0, newCarId, mainImageName, true);
                    carDAO.insertCarImage(mainImg);
                }

                // 6c. Lưu các Ảnh Phụ (thumbs) nếu có
                if (thumbItems != null && !thumbItems.isEmpty()) {
                    for (FileItem thumbItem : thumbItems) {
                        if (thumbItem.getSize() > 0) {
                            String thumbName = saveFile(thumbItem, request); // dùng lại hàm saveFile()
                            CarImage thumbImg = new CarImage(0, newCarId, thumbName, false);
                            carDAO.insertCarImage(thumbImg);
                        }
                    }
                }
            } else {
                throw new Exception("Lỗi khi gọi insertCarAndStock, không nhận được CarID.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi (ví dụ: gửi thông báo lỗi về JSP)
        }

        // 7. Tải lại trang (bằng cách gọi lại doGet để load lại Brand)
        response.sendRedirect("ThemSanPhamServlet");
    }

    private void processFormField(FileItem item, Car car, CarStock stock) throws IOException {
        String fieldName = item.getFieldName();
        String value = item.getString();

        switch (fieldName) {
            case "brandID": // Sửa từ "brand"
                car.setBrandID(Integer.parseInt(value));
                break;
            case "carName": // Sửa từ "name"
                car.setCarName(value);
                break;
            case "price":
                // Bỏ dấu chấm, chỉ lấy số
                String giaClean = value.replaceAll("\\.", "");
                car.setPrice(new BigDecimal(giaClean));
                break;
            case "color":
                car.setColor(value);
                break;
            case "quantity":
                stock.setQuantity(Integer.parseInt(value));
                break;
            case "description":
                car.setDescription(value);
                break;
        }
    }

    /**
     * Hàm phụ: Lưu file (giống hệt hàm của BrandServlet)
     */
    private String saveFile(FileItem item, HttpServletRequest request) throws IOException {
        if (item == null || item.getSize() == 0) {
            return null; // Không có file
        }

        String fileName = Paths.get(item.getName()).getFileName().toString();
        // Cậu phải tạo thư mục "uploads" trong Web Pages (image_e3a783.png)
        String uploadPath = request.getServletContext().getRealPath("") + UPLOAD_DIR;
        Path uploadDirPath = Paths.get(uploadPath);

        if (!Files.exists(uploadDirPath)) {
            Files.createDirectories(uploadDirPath);
        }

        try (InputStream input = item.getInputStream()) {
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
