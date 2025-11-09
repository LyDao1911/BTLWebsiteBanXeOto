/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import model.Car;

/**
 *
 * @author Admin
 */
@WebServlet(name = "TimKiemServlet", urlPatterns = {"/TimKiemServlet"})
public class TimKiemServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet TimKiemServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TimKiemServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đảm bảo request dùng UTF-8
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy và Chuẩn hóa Tham số Đầu vào
        String keyword = request.getParameter("keyword");
        String[] brandParams = request.getParameterValues("brand");
        String[] colorParams = request.getParameterValues("color");

        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        // Chuyển List<String> cho phương thức searchCarsWithFilters
        List<String> selectedBrands = (brandParams != null) ? Arrays.asList(brandParams) : new ArrayList<>();
        List<String> selectedColors = (colorParams != null) ? Arrays.asList(colorParams) : new ArrayList<>();

        // Chuyển Double cho phương thức DAO
        Double minPrice = null, maxPrice = null;
        try {
            if (minPriceStr != null && !minPriceStr.isEmpty()) {
                // Đảm bảo không có dấu phẩy khi parse
                minPrice = Double.parseDouble(minPriceStr.replace(",", ""));
            }
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                // Đảm bảo không có dấu phẩy khi parse
                maxPrice = Double.parseDouble(maxPriceStr.replace(",", ""));
            }
        } catch (NumberFormatException e) {
            System.out.println("Lỗi parse giá: " + e.getMessage());
        }

        // 2. Gọi DAO và Thực hiện logic
        CarDAO carDAO = new CarDAO();

        // 🟢 Logic Sửa lỗi: Khi lấy AVAILABLE brands, ta chỉ nên truyền KEYWORD, COLOR và PRICE
        // (Không truyền BRAND đang được chọn, vì ta muốn biết các brand khác CÓ CÒN xe
        // nào phù hợp với các bộ lọc kia không)
        List<String> availableBrands = carDAO.getAvailableBrands(keyword,
                colorParams, minPrice, maxPrice); // BrandParams KHÔNG được truyền

        // 🟢 Logic Sửa lỗi: Tương tự, khi lấy AVAILABLE colors, ta chỉ nên truyền
        // KEYWORD, BRAND và PRICE
        List<String> availableColors = carDAO.getAvailableColors(keyword,
                brandParams, minPrice, maxPrice); // ColorParams KHÔNG được truyền

        // ✅ Lấy kết quả tìm kiếm (Sử dụng List<String> cho selectedBrands và selectedColors)
        List<Car> searchResults = carDAO.searchCarsWithFilters(keyword, selectedBrands, selectedColors,
                minPrice, maxPrice, sortBy, sortOrder);

        // ✅ Lấy giá cao nhất để hiển thị slider (nếu cần)
        double maxPriceInSystem = carDAO.getMaxPrice();

        // 3. Gửi Dữ liệu sang JSP
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("selectedBrands", selectedBrands);
        request.setAttribute("selectedColors", selectedColors);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("maxPriceInSystem", maxPriceInSystem);

        request.setAttribute("availableBrands", availableBrands);
        request.setAttribute("availableColors", availableColors);
        request.setAttribute("searchResults", searchResults);

        // Debug thông tin
        System.out.println("=== THÔNG TIN TÌM KIẾM ===");
        System.out.println("Keyword: " + keyword);
        System.out.println("Brands selected: " + selectedBrands);
        System.out.println("Colors selected: " + selectedColors);
        System.out.println("MinPrice: " + minPrice);
        System.out.println("MaxPrice: " + maxPrice);
        System.out.println("Available Brands (Sau lọc): " + availableBrands);
        System.out.println("Available Colors (Sau lọc): " + availableColors);
        System.out.println("Số kết quả: " + (searchResults != null ? searchResults.size() : 0));

        // Chuyển trang
        RequestDispatcher dispatcher = request.getRequestDispatcher("timkiem.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý tìm kiếm và lọc xe";
    }
}

