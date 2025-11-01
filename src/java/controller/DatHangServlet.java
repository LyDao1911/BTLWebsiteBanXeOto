/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import dao.CustomerDAO;
import dao.OrderDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import model.Car;
import model.Customer;
import model.Order;

/**
 *
 * @author Hong Ly
 */
@WebServlet(name = "DatHangServlet", urlPatterns = {"/DatHangServlet"})
public class DatHangServlet extends HttpServlet {

    private final CarDAO carDAO = new CarDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

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
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        // 1. Kiểm tra đăng nhập
        String username = (String) session.getAttribute("username");
        if (username == null) {
            session.setAttribute("redirectUrl", request.getRequestURI() + "?" + request.getQueryString());
            response.sendRedirect("dangnhap.jsp");
            return;
        }

        Customer customer = customerDAO.getCustomerByUsername(username);
        List<Car> itemsToCheckout = new ArrayList<>();

        // Lấy thông tin giỏ hàng
        Map<Integer, Integer> cartQuantityMap
                = (Map<Integer, Integer>) session.getAttribute("cartQuantityMap");

        // 2. Thanh toán từ giỏ hàng (nhiều sản phẩm)
        String carIDsParam = request.getParameter("carIDs");
        if (carIDsParam != null && !carIDsParam.isEmpty() && cartQuantityMap != null) {
            List<String> idStrings = Arrays.asList(carIDsParam.split(","));
            for (String idStr : idStrings) {
                try {
                    int carID = Integer.parseInt(idStr.trim());
                    Integer quantity = cartQuantityMap.get(carID);
                    if (quantity != null && quantity > 0) {
                        Car car = carDAO.getCarById(carID);
                        if (car != null) {
                            car.setQuantity(quantity);
                            itemsToCheckout.add(car);
                        }
                    }
                } catch (NumberFormatException ignored) {
                }
            }
        } // 3. Mua ngay (1 sản phẩm)
        else {
            String carIDParam = request.getParameter("carID");
            String quantityParam = request.getParameter("quantity");

            if (carIDParam != null && !carIDParam.isEmpty()) {
                try {
                    int carID = Integer.parseInt(carIDParam);
                    int quantity = (quantityParam != null && !quantityParam.isEmpty())
                            ? Integer.parseInt(quantityParam) : 1;
                    if (quantity < 1) {
                        quantity = 1;
                    }

                    Car car = carDAO.getCarById(carID);
                    if (car != null) {
                        car.setQuantity(quantity);
                        itemsToCheckout.add(car);
                    }
                } catch (NumberFormatException ignored) {
                }
            }
        }

        if (!itemsToCheckout.isEmpty()) {
            request.setAttribute("itemsToCheckout", itemsToCheckout);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("dathang.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Không có sản phẩm nào để thanh toán.");
            response.sendRedirect("HomeServlet");
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
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        String username = (String) session.getAttribute("username");
        if (username == null) {
            response.sendRedirect("dangnhap.jsp");
            return;
        }

        Customer customer = customerDAO.getCustomerByUsername(username);
        if (customer == null) {
            response.sendRedirect("dangnhap.jsp");
            return;
        }

        // Lấy thông tin người nhận từ form
        String receiverName = request.getParameter("fullname");
        String receiverPhone = request.getParameter("phone");
        String receiverAddress = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");
        String totalAmountParam = request.getParameter("totalAmount");

        String[] carIDsStr = request.getParameterValues("carID");
        String[] quantitiesStr = request.getParameterValues("quantity");

        List<Car> itemsToCheckout = new ArrayList<>(); // Dùng để forward lại trang
        OrderDAO orderDAO = new OrderDAO();
        BigDecimal totalAmount = BigDecimal.ZERO;

        boolean hasError = false;

        // 1. Tải lại dữ liệu sản phẩm (để forward về dathang.jsp nếu có lỗi)
        if (carIDsStr != null && quantitiesStr != null && carIDsStr.length == quantitiesStr.length) {
            try {
                for (int i = 0; i < carIDsStr.length; i++) {
                    int carID = Integer.parseInt(carIDsStr[i]);
                    int quantity = Integer.parseInt(quantitiesStr[i]);
                    Car car = carDAO.getCarById(carID);
                    if (quantity > 0 && car != null) {
                        car.setQuantity(quantity);
                        itemsToCheckout.add(car); // Lấy lại danh sách sản phẩm
                    }
                }
            } catch (NumberFormatException e) {
                System.out.println("LỖI: Lỗi định dạng số ID hoặc Quantity.");
                hasError = true;
            }
        }

        // 2. Bắt lỗi Validation (SỬ DỤNG FORWARD)
        if (itemsToCheckout.isEmpty() || hasError) {
            request.setAttribute("errorMessage", "Không có sản phẩm nào hợp lệ để đặt hàng.");
            request.getRequestDispatcher("dathang.jsp").forward(request, response);
            return;
        }

        // Kiểm tra thiếu thông tin người nhận
        if (receiverName == null || receiverName.trim().isEmpty()
                || receiverAddress == null || receiverAddress.trim().isEmpty()
                || receiverPhone == null || receiverPhone.trim().isEmpty()) {

            System.out.println("LỖI: Thông tin khách hàng bị thiếu.");
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ Họ tên, Địa chỉ và Số điện thoại.");

            // ✅ KHẮC PHỤC: Sử dụng FORWARD để giữ lại danh sách sản phẩm và thông tin khách hàng
            request.setAttribute("itemsToCheckout", itemsToCheckout);
            request.setAttribute("customer", customer);

            request.getRequestDispatcher("dathang.jsp").forward(request, response);
            return;
        }

        // 3. Tiến hành tạo Order
        List<Car> purchasedItems = new ArrayList<>();

        try {
            // Tính toán lại Total Amount từ DB
            for (Car car : itemsToCheckout) {
                totalAmount = totalAmount.add(car.getPrice().multiply(new BigDecimal(car.getQuantity())));
                purchasedItems.add(car);
            }

            // Xử lý Tổng tiền gửi từ hidden field (Đã chuẩn hóa để tránh lỗi)
            BigDecimal finalTotalAmount = totalAmount;
            if (totalAmountParam != null && !totalAmountParam.isEmpty()) {
                try {
                    String cleaned = totalAmountParam.replaceAll("[^\\d]", "");
                    if (!cleaned.isEmpty()) {
                        finalTotalAmount = new BigDecimal(cleaned);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Lỗi chuyển đổi tổng tiền: " + e.getMessage());
                }
            }

            // Tạo Note sử dụng DỮ LIỆU MỚI TỪ FORM (Đảm bảo cột Note đủ dài trong DB)
            String noteContent = String.format(
                    "PTTT: %s | Người nhận: %s | SĐT: %s | Địa chỉ: %s",
                    paymentMethod, receiverName, receiverPhone, receiverAddress
            );

            // Tạo đối tượng Order
            Order order = new Order();
            order.setCustomerID(customer.getCustomerID());
            order.setOrderDate(LocalDateTime.now());
            order.setTotalAmount(finalTotalAmount);
            order.setPaymentStatus("Pending");
            order.setDeliveryStatus("Pending");
            order.setNote(noteContent);

            // Tạo đơn hàng và chi tiết (DAO cần đảm bảo transaction)
            int newOrderId = orderDAO.createOrderWithDetails(order, purchasedItems);

            if (newOrderId > 0) {
                // Xóa các sản phẩm đã mua khỏi giỏ hàng
                Map<Integer, Integer> cartQuantityMap = (Map<Integer, Integer>) session.getAttribute("cartQuantityMap");
                if (cartQuantityMap != null) {
                    for (Car car : purchasedItems) {
                        cartQuantityMap.remove(car.getCarID());
                    }
                    session.setAttribute("cartQuantityMap", cartQuantityMap);
                }

                // Sinh OTP và lưu vào session
                String generatedOtp = String.format("%06d", (int) (Math.random() * 1000000));
                session.setAttribute("generatedOtp", generatedOtp);
                session.setAttribute("pendingOrderId", newOrderId);

                // Chuyển sang trang xác nhận OTP
                request.setAttribute("orderId", newOrderId);
                request.setAttribute("amount", finalTotalAmount);
                request.setAttribute("generatedOtp", generatedOtp); // Truyền để kích hoạt alert

                RequestDispatcher rd = request.getRequestDispatcher("otp_verification.jsp");
                rd.forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Đặt hàng thất bại. Vui lòng thử lại.");
                // Trường hợp lỗi DAO, FORWARD lại trang dathang.jsp
                request.setAttribute("itemsToCheckout", itemsToCheckout);
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("dathang.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Lỗi hệ thống, FORWARD lại trang đặt hàng
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống trong quá trình đặt hàng: " + e.getMessage());
            request.setAttribute("itemsToCheckout", itemsToCheckout);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("dathang.jsp").forward(request, response);
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
