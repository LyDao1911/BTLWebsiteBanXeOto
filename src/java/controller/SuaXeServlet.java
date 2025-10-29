/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import dao.BrandDAO;
import model.Brand;
import model.Car;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

/**
 *
 * @author Admin
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
@WebServlet(name = "SuaXeServlet", urlPatterns = {"/SuaXeServlet"})
public class SuaXeServlet extends HttpServlet {

    private final CarDAO carDAO = new CarDAO();
    private final BrandDAO brandDAO = new BrandDAO();

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
        try {
            String carIdParam = request.getParameter("carId");
            if (carIdParam == null) {
                carIdParam = request.getParameter("carID");
            }

            int carId = Integer.parseInt(carIdParam);
            Car car = carDAO.getCarById(carId);

            if (car != null) {
                // Lấy thêm ảnh phụ
                car.setThumbs(carDAO.getCarThumbs(carId));

                List<Brand> brandList = brandDAO.getAllBrands();
                request.setAttribute("brandList", brandList);
                request.setAttribute("car", car);

                RequestDispatcher rd = request.getRequestDispatcher("suaxe.jsp");
                rd.forward(request, response);
            } else {
                response.getWriter().println("Không tìm thấy xe có ID = " + carId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi lấy thông tin xe: " + e.getMessage());
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
            // 1️⃣ LẤY THÔNG TIN CƠ BẢN
            int carId = Integer.parseInt(request.getParameter("carId"));
            String carName = request.getParameter("carName");
            int brandId = Integer.parseInt(request.getParameter("brandID"));
            String priceStr = request.getParameter("price").replace(".", "").replace(",", "").trim();
            BigDecimal price = new BigDecimal(priceStr);
            String color = request.getParameter("color");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            
            // 2️⃣ XỬ LÝ ẢNH CHÍNH
            Part mainPart = request.getPart("mainImage");
            String oldMainImage = request.getParameter("oldImage");
            String uploadPath = getServletContext().getRealPath("/uploads");
            String mainImagePath = oldMainImage;

            if (mainPart != null && mainPart.getSize() > 0) {
                String fileName = Paths.get(mainPart.getSubmittedFileName()).getFileName().toString();
                mainPart.write(uploadPath + "/" + fileName);
                mainImagePath = fileName;
            }

            // 3️⃣ XỬ LÝ ẢNH PHỤ
            String[] oldThumbs = request.getParameterValues("oldThumbs");
            List<String> thumbs = new ArrayList<>();
            for (Part part : request.getParts()) {
                if ("thumbs".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    part.write(uploadPath + "/" + fileName);
                    thumbs.add(fileName);
                }
            }

            // Nếu không upload ảnh phụ mới, giữ lại ảnh cũ
            if (thumbs.isEmpty() && oldThumbs != null) {
                thumbs.addAll(Arrays.asList(oldThumbs));
            }

            // 4️⃣ TẠO OBJECT CAR
            Car car = new Car(carId, carName, brandId, price, color, description, status);
            car.setMainImageURL(mainImagePath);
            car.setThumbs(thumbs);

            // 5️⃣ CẬP NHẬT DATABASE
            boolean updated = carDAO.updateCarWithStock(car, quantity);

            if (updated) {
                response.sendRedirect("SanPhamServlet?msg=success");
            } else {
                System.err.println("❌ Update thất bại cho CarID=" + carId);
                response.sendRedirect("SanPhamServlet?msg=fail");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("SanPhamServlet?msg=invalid_input");
        } catch (Exception e) {
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
