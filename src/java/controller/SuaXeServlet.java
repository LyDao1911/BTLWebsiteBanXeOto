/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.math.BigDecimal;
import java.nio.file.Paths;
import model.Car;

/**
 *
 * @author Admin
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
@WebServlet(name = "SuaXeServlet", urlPatterns = {"/SuaXeServlet"})
public class SuaXeServlet extends HttpServlet {

    private final CarDAO dao = new CarDAO();

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SuaXeServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SuaXeServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        String carIdParam = request.getParameter("carId");
        if (carIdParam == null) {
            carIdParam = request.getParameter("carID"); // fallback
        }
        try {
            int carID = Integer.parseInt(carIdParam);
            Car car = dao.getCarById(carID);
            if (car != null) {
                request.setAttribute("car", car);
                request.getRequestDispatcher("suaxe.jsp").forward(request, response);
                return;
            } else {
                response.getWriter().println("Không tìm thấy xe có ID: " + carID);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi lấy thông tin xe: " + e.getMessage());
            return;
        }
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

        try {
            // Lấy carId (chấp nhận cả "carId" và "carID")
            String carIdParam = request.getParameter("carId");
            if (carIdParam == null) {
                carIdParam = request.getParameter("carID");
            }
            int carId = Integer.parseInt(carIdParam);

            // Lấy các tham số khác (tên tham số phải trùng với name trong form JSP)
            String carName = request.getParameter("carName");
            String brandIdParam = request.getParameter("brandID");
            if (brandIdParam == null) {
                brandIdParam = request.getParameter("brandId");
            }
            int brandId = Integer.parseInt(brandIdParam);

            String priceRaw = request.getParameter("price");
            if (priceRaw == null) {
                priceRaw = "0";
            }

            // BẮT ĐẦU SỬA LỖI PRICE PARSING
            // Loại bỏ CẢ dấu chấm (.) và dấu phẩy (,) để xử lý mọi định dạng phân nhóm
            String priceStr = priceRaw.replace(".", "").replace(",", "").trim();
            BigDecimal price = new BigDecimal(priceStr);
            // KẾT THÚC SỬA LỖI PRICE PARSING

            String color = request.getParameter("color");
            String quantityParam = request.getParameter("quantity");
            if (quantityParam == null) {
                quantityParam = "0";
            }
            int quantity = Integer.parseInt(quantityParam);

            String description = request.getParameter("description");
            String status = request.getParameter("status");

            // ... (Giữ nguyên logic xử lý ảnh và tạo đối tượng Car) ...
            // Xử lý ảnh chính - lưu file nếu có
            Part mainPart = null;
            try {
                mainPart = request.getPart("mainImage");
            } catch (IllegalStateException ex) {
                // multipart có thể gây lỗi nếu config server khác, cho qua
                mainPart = null;
            }

            String oldMain = request.getParameter("oldImage"); // tên hidden input chứa đường dẫn cũ
            String mainImagePath;
            if (mainPart != null && mainPart.getSize() > 0) {
                String fileName = Paths.get(mainPart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("/images");
                mainPart.write(uploadPath + "/" + fileName);
                mainImagePath = "images/" + fileName;
            } else {
                mainImagePath = oldMain;
            }

            // Xử lý ảnh mô tả (thumbs)
            String[] oldThumbs = request.getParameterValues("oldThumbs");
            java.util.Collection<Part> parts = request.getParts();
            java.util.List<String> newThumbs = new java.util.ArrayList<>();
            String uploadPath = getServletContext().getRealPath("/images");
            for (Part part : parts) {
                // đảm bảo name của input file mô tả là "thumbs"
                if ("thumbs".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    part.write(uploadPath + "/" + fileName);
                    newThumbs.add("images/" + fileName);
                }
            }

            java.util.List<String> finalThumbs = new java.util.ArrayList<>();
            if (!newThumbs.isEmpty()) {
                finalThumbs.addAll(newThumbs);
            } else if (oldThumbs != null) {
                finalThumbs.addAll(java.util.Arrays.asList(oldThumbs));
            }

            // Tạo object Car (đảm bảo constructor và setter trùng với model của bạn)
            Car car = new Car(carId, carName, brandId, price, color, description, status);
            car.setMainImageURL(mainImagePath);
            car.setThumbs(finalThumbs);

            // Debugging log (Giữ nguyên để kiểm tra dữ liệu)
            System.out.println(">>> [DEBUG] Chuẩn bị cập nhật xe:");
            System.out.println("    CarID: " + carId);
            System.out.println("    Tên xe: " + carName);
            System.out.println("    BrandID: " + brandId);
            System.out.println("    Giá: " + price);
            System.out.println("    Màu: " + color);
            System.out.println("    Mô tả: " + description);
            System.out.println("    Trạng thái: " + status);
            System.out.println("    Số lượng tồn: " + quantity);
            System.out.println("    Ảnh chính: " + mainImagePath);
            System.out.println("    Ảnh mô tả: " + finalThumbs);

            // Gọi đúng phương thức trong CarDAO 
            boolean updated = dao.updateCarWithStock(car, quantity);

            if (updated) {
                response.sendRedirect("SanPhamServlet?msg=success");
            } else {
                // Trường hợp update thất bại ở đây, cần kiểm tra DAO
                System.err.println("Update thất bại cho CarID=" + carId + ". KIỂM TRA LẠI CARDAO VÀ SQL.");
                response.sendRedirect("SanPhamServlet?msg=fail");
            }

        } catch (NumberFormatException nfe) {
            // Lỗi nếu không parse được CarID, BrandID, Price, hoặc Quantity
            nfe.printStackTrace();
            response.sendRedirect("SanPhamServlet?msg=invalid_input");
        } catch (Exception e) {
            // Lỗi chung: Thường là IOException hoặc ServletException
            e.printStackTrace();
            response.sendRedirect("SanPhamServlet?msg=error");
        }
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
