package controller;

import dao.CarDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.Car;

@WebServlet(name = "GioHangServlet", urlPatterns = {"/GioHangServlet"})
public class GioHangServlet extends HttpServlet {

    private final CarDAO carDAO = new CarDAO();

    // Giữ nguyên processRequest
    /**
     * Handles the HTTP <code>GET</code> method. Hiển thị nội dung giỏ hàng từ
     * Session.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
        response.setDateHeader("Expires", 0); // Proxies.
        HttpSession session = request.getSession();

        Map<Integer, Integer> cartQuantityMap
                = (Map<Integer, Integer>) session.getAttribute("cartQuantityMap");

        List<Car> carListWithQuantity = new ArrayList<>();

        if (cartQuantityMap != null && !cartQuantityMap.isEmpty()) {
            Set<Integer> carIDs = cartQuantityMap.keySet();

            for (int carID : carIDs) {
                Car car = carDAO.getCarById(carID);

                if (car != null) {
                    // LƯU Ý: car.getQuantity() ở đây là số lượng TỒN KHO THỰC TẾ từ DB.
                    // Chúng ta ghi đè nó bằng số lượng MUA TRONG GIỎ để hiển thị.
                    int quantityInCart = cartQuantityMap.get(carID);
                    car.setQuantity(quantityInCart);
                    carListWithQuantity.add(car);
                }
            }
        }
        request.setAttribute("cartList", carListWithQuantity);

        request.getRequestDispatcher("giohang.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method. Xử lý cả hai trường hợp: THÊM
     * mới (từ trang chi tiết) và CẬP NHẬT (từ giohang.jsp qua AJAX).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String carIDParam = request.getParameter("carID");
        String quantityParam = request.getParameter("quantity");
        String action = request.getParameter("action");

        if (carIDParam == null || quantityParam == null) {
            response.sendRedirect("HomeServlet");
            return;
        }

        // ⭐ ĐIỀU CHỈNH: Thiết lập response để trả về JSON cho mọi POST request
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int carID = Integer.parseInt(carIDParam);
            int quantityValue = Integer.parseInt(quantityParam);

            Map<Integer, Integer> cartQuantityMap
                    = (Map<Integer, Integer>) session.getAttribute("cartQuantityMap");

            if (cartQuantityMap == null) {
                cartQuantityMap = new HashMap<>();
            }

            Car car = carDAO.getCarById(carID);
            if (car == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\": false, \"message\": \"Không tìm thấy xe để thêm.\"}");
                out.flush();
                return;
            }
            int maxStockQuantity = car.getQuantity(); // Tồn kho thực tế

            int finalQuantity;
            String message = "";

            // === Xử lý CẬP NHẬT GIỎ HÀNG (AJAX từ giohang.jsp) ===
            if ("update".equals(action)) {
                finalQuantity = quantityValue;

                if (finalQuantity <= 0) {
                    cartQuantityMap.remove(carID);
                    finalQuantity = 0;
                    message = "Đã xóa sản phẩm " + car.getCarName() + " khỏi giỏ hàng.";
                } else if (finalQuantity > maxStockQuantity) {
                    finalQuantity = maxStockQuantity;
                    cartQuantityMap.put(carID, finalQuantity);
                    message = "Sản phẩm " + car.getCarName() + " chỉ còn " + maxStockQuantity + " chiếc. Đã giới hạn số lượng.";
                } else {
                    cartQuantityMap.put(carID, finalQuantity);
                    message = "Cập nhật số lượng sản phẩm " + car.getCarName() + " thành công.";
                }

                session.setAttribute("cartQuantityMap", cartQuantityMap);

                // ⭐ THÊM totalItems cho các request UPDATE
                int totalItemsInCart = cartQuantityMap.size();

                // Trả về JSON cho AJAX
                out.print("{\"success\": true, \"quantity\": " + finalQuantity + ", \"message\": \"" + message + "\", \"totalItems\": " + totalItemsInCart + "}");
                out.flush();
                return; // Dừng lại ở đây cho AJAX
            } // === Xử lý THÊM MỚI SẢN PHẨM VÀO GIỎ (Từ trang chi tiết) ===
            else {
                int quantityToAdd = quantityValue;
                int currentQuantityInCart = cartQuantityMap.getOrDefault(carID, 0);
                int newQuantity = currentQuantityInCart + quantityToAdd;

                if (newQuantity > maxStockQuantity) {
                    finalQuantity = maxStockQuantity;
                    cartQuantityMap.put(carID, finalQuantity);
                    message = "Đã thêm tối đa " + maxStockQuantity + " sản phẩm " + car.getCarName() + " vào giỏ hàng.";
                } else {
                    finalQuantity = newQuantity;
                    cartQuantityMap.put(carID, finalQuantity);
                    message = "Thêm " + quantityToAdd + " sản phẩm " + car.getCarName() + " vào giỏ hàng thành công!";
                }

                session.setAttribute("cartQuantityMap", cartQuantityMap);

                // ⭐ THAY THẾ REDIRECT BẰNG JSON RESPONSE
                int totalItemsInCart = cartQuantityMap.size();
                out.print("{\"success\": true, \"message\": \"" + message + "\", \"totalItems\": " + totalItemsInCart + "}");
                out.flush();
                return; // Dừng lại ở đây
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Dữ liệu gửi lên không hợp lệ.\"}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Đã xảy ra lỗi hệ thống khi thêm vào giỏ.\"}");
            out.flush();
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles adding to cart and updating quantities via POST/AJAX.";
    }
}
