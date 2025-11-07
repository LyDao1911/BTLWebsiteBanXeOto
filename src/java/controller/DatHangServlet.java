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
import model.OrderDetail;

@WebServlet(name = "DatHangServlet", urlPatterns = {"/DatHangServlet"})
public class DatHangServlet extends HttpServlet {

    private final CarDAO carDAO = new CarDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final OrderDAO orderDAO = new OrderDAO();

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
        Map<Integer, Integer> cartQuantityMap = (Map<Integer, Integer>) session.getAttribute("cartQuantityMap");

        List<Integer> idsToClear = new ArrayList<>();

        boolean needCartUpdate = false;
        String stockUpdateMessage = "";

        // 2. Thanh toán từ giỏ hàng (nhiều sản phẩm)
        String carIDsParam = request.getParameter("carIDs");
        if (carIDsParam != null && !carIDsParam.isEmpty() && cartQuantityMap != null) {
            List<String> idStrings = new ArrayList<>(Arrays.asList(carIDsParam.split(",")));

            for (int i = idStrings.size() - 1; i >= 0; i--) {
                String idStr = idStrings.get(i);
                try {
                    int carID = Integer.parseInt(idStr.trim());
                    Integer quantityInCart = cartQuantityMap.get(carID);

                    if (quantityInCart != null && quantityInCart > 0) {
                        Car car = carDAO.getCarById(carID);

                        if (car != null) {
                            int availableQuantity = car.getQuantity();

                            // Validation tồn kho
                            if (quantityInCart > availableQuantity) {
                                stockUpdateMessage += "Sản phẩm " + car.getCarName() + " chỉ còn " + availableQuantity + " chiếc. ";

                                if (availableQuantity <= 0) {
                                    cartQuantityMap.remove(carID);
                                    stockUpdateMessage += "Đã xóa khỏi giỏ hàng.\n";
                                    idStrings.remove(i);
                                } else {
                                    cartQuantityMap.put(carID, availableQuantity);
                                    quantityInCart = availableQuantity;
                                    stockUpdateMessage += "Đã giới hạn số lượng trong giỏ.\n";
                                }
                                needCartUpdate = true;
                            }

                            if (quantityInCart > 0) {
                                car.setQuantity(quantityInCart);
                                itemsToCheckout.add(car);
                                idsToClear.add(carID);
                            }
                        }
                    }
                } catch (NumberFormatException ignored) {
                }
            }

            // CHUYỂN HƯỚNG QUAY LẠI GIOHANGSERVELET NẾU CÓ THAY ĐỔI
            if (needCartUpdate) {
                session.setAttribute("toastMessage", stockUpdateMessage.trim());
                session.setAttribute("cartQuantityMap", cartQuantityMap);
                response.sendRedirect("GioHangServlet");
                return;
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
                        if (quantity > car.getQuantity()) {
                            quantity = car.getQuantity();
                            session.setAttribute("toastMessage", "Sản phẩm " + car.getCarName() + " chỉ còn " + car.getQuantity() + " chiếc.");
                        }
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
            request.setAttribute("idsToClear", idsToClear);

            request.getRequestDispatcher("dathang.jsp").forward(request, response);
        } else {
            // ✅ SỬA LỖI: Dùng forward thay vì sendRedirect để giữ thông báo lỗi
            request.setAttribute("errorMessage", "Không có sản phẩm nào để thanh toán.");
            request.getRequestDispatcher("GioHangServlet").forward(request, response);
        }
    }

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
        if (customer == null || customer.getCustomerID() == 0) {
            session.setAttribute("toastMessage", "Thông tin khách hàng không hợp lệ. Vui lòng đăng nhập lại.");
            response.sendRedirect("dangnhap.jsp");
            return;
        }

        String receiverName = request.getParameter("fullname");
        String receiverPhone = request.getParameter("phone");
        String receiverAddress = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");

        String[] carIDsStr = request.getParameterValues("carID");
        String[] quantitiesStr = request.getParameterValues("quantity");
        String[] idsToClearStr = request.getParameterValues("idsToClear");

        List<Car> itemsToCheckout = new ArrayList<>();
        BigDecimal finalTotalAmount = BigDecimal.ZERO;

        boolean hasError = false;
        String stockErrorMessage = null;

        // 1. Tải lại dữ liệu sản phẩm, TÍNH TOÁN LẠI TỔNG TIỀN, và KIỂM TRA TỒN KHO
        if (carIDsStr != null && quantitiesStr != null && carIDsStr.length == quantitiesStr.length) {
            for (int i = 0; i < carIDsStr.length; i++) {
                try {
                    int carID = Integer.parseInt(carIDsStr[i]);
                    int quantity = Integer.parseInt(quantitiesStr[i]);

                    if (quantity <= 0) {
                        hasError = true;
                        continue;
                    }

                    Car car = carDAO.getCarById(carID);
                    if (car == null) {
                        hasError = true;
                        continue;
                    }

                    // KIỂM TRA TỒN KHO THỰC TẾ
                    if (quantity > car.getQuantity()) {
                        stockErrorMessage = "Sản phẩm " + car.getCarName() + " chỉ còn " + car.getQuantity() + " chiếc trong kho. Vui lòng giảm số lượng!";
                        hasError = true;
                        // ⭐ Sửa lỗi: KHÔNG break để tiếp tục kiểm tra các sản phẩm khác
                    }

                    // Tính toán tổng tiền an toàn (CHỈ SỬ DỤNG GIÁ TRỊ TỪ DB)
                    if (!hasError) {
                        BigDecimal subTotal = car.getPrice().multiply(new BigDecimal(quantity));
                        finalTotalAmount = finalTotalAmount.add(subTotal);

                        // Tạo đối tượng Car mới cho checkout
                        Car checkoutCar = new Car();
                        checkoutCar.setCarID(car.getCarID());
                        checkoutCar.setCarName(car.getCarName());
                        checkoutCar.setPrice(car.getPrice());
                        checkoutCar.setQuantity(quantity);
                        checkoutCar.setMainImageURL(car.getMainImageURL());

                        itemsToCheckout.add(checkoutCar);
                    }
                    if (!hasError) {
                        BigDecimal taxRate = new BigDecimal("0.10"); // Thuế 10%
                        BigDecimal taxAmount = finalTotalAmount.multiply(taxRate);
                        finalTotalAmount = finalTotalAmount.add(taxAmount);}

                    }catch (NumberFormatException e) {
                    System.out.println("DEBUG: LỖI định dạng số ID hoặc Quantity.");
                    e.printStackTrace();
                    hasError = true;
                }
                }
            }else {
            hasError = true;
            stockErrorMessage = "Thông tin sản phẩm không hợp lệ.";
        }

            // 2. Bắt lỗi Validation (FORWARD)
            if (itemsToCheckout.isEmpty() || hasError) {
                String message = stockErrorMessage != null ? stockErrorMessage : "Không có sản phẩm nào hợp lệ để đặt hàng.";
                request.setAttribute("errorMessage", message);

                // Cần set lại các thuộc tính để dathang.jsp hiển thị lại
                request.setAttribute("itemsToCheckout", itemsToCheckout);
                request.setAttribute("customer", customer);
                request.setAttribute("idsToClear", idsToClearStr != null ? Arrays.asList(idsToClearStr) : new ArrayList<>());

                request.getRequestDispatcher("dathang.jsp").forward(request, response);
                return;
            }

            // Kiểm tra thiếu thông tin người nhận
            if (receiverName == null || receiverName.trim().isEmpty()
                    || receiverAddress == null || receiverAddress.trim().isEmpty()
                    || receiverPhone == null || receiverPhone.trim().isEmpty()) {

                request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ Họ tên, Địa chỉ và Số điện thoại.");

                request.setAttribute("itemsToCheckout", itemsToCheckout);
                request.setAttribute("customer", customer);
                request.setAttribute("idsToClear", idsToClearStr != null ? Arrays.asList(idsToClearStr) : new ArrayList<>());

                request.getRequestDispatcher("dathang.jsp").forward(request, response);
                return;
            }

            // CHUYỂN ĐỔI List<Car> SANG List<OrderDetail>
            List<OrderDetail> orderDetails = new ArrayList<>();
            for (Car car : itemsToCheckout) {
                OrderDetail detail = new OrderDetail();
                detail.setCarID(car.getCarID());
                detail.setQuantity(car.getQuantity());
                detail.setPrice(car.getPrice());

                BigDecimal subtotal = car.getPrice().multiply(new BigDecimal(car.getQuantity()));
                detail.setSubtotal(subtotal);
                detail.setUserName(username);

                orderDetails.add(detail);
            }

            // 3. Tiến hành tạo Order
            try {
                String noteContent = String.format(
                        "PTTT: %s | Người nhận: %s | SĐT: %s | Địa chỉ: %s",
                        paymentMethod, receiverName, receiverPhone, receiverAddress
                );

                Order order = new Order();
                order.setCustomerID(customer.getCustomerID());
                order.setOrderDate(LocalDateTime.now());
                order.setTotalAmount(finalTotalAmount);
                order.setPaymentStatus("Chưa thanh toán");
                order.setDeliveryStatus("Chờ xử lý");
                order.setNote(noteContent);

                System.out.println("DEBUG: Đang gọi OrderDAO.createOrderWithDetails...");
                int newOrderId = orderDAO.createOrderWithDetails(order, orderDetails);

                if (newOrderId > 0) {
                    System.out.println("DEBUG: Tạo Order ID #" + newOrderId + " thành công.");

                    // 4. CẬP NHẬT SỐ LƯỢNG TỒN KHO
                    boolean stockUpdated = true;
                    for (Car car : itemsToCheckout) {
                        boolean updated = carDAO.updateCarQuantity(car.getCarID(), car.getQuantity());
                        if (!updated) {
                            stockUpdated = false;
                            System.err.println("Lỗi cập nhật tồn kho cho sản phẩm ID: " + car.getCarID());
                        }
                    }

                    if (!stockUpdated) {
                        System.err.println("CẢNH BÁO: Có lỗi khi cập nhật tồn kho cho đơn hàng #" + newOrderId);
                    }

                    // 5. Xóa các sản phẩm đã mua khỏi giỏ hàng
                    Map<Integer, Integer> cartQuantityMap = (Map<Integer, Integer>) session.getAttribute("cartQuantityMap");
                    if (cartQuantityMap != null && idsToClearStr != null) {
                        for (String idStr : idsToClearStr) {
                            try {
                                int carID = Integer.parseInt(idStr.trim());
                                cartQuantityMap.remove(carID);
                            } catch (NumberFormatException ignored) {
                            }
                        }
                        session.setAttribute("cartQuantityMap", cartQuantityMap);
                    }

                    // 6. Sinh OTP và chuyển sang trang xác nhận OTP
                    String generatedOtp = String.format("%06d", (int) (Math.random() * 1000000));
                    long expireTime = System.currentTimeMillis() + (5 * 60 * 1000);
                    session.setAttribute("amount", finalTotalAmount);
                    session.setAttribute("generatedOtp", generatedOtp);
                    session.setAttribute("otp_verificationExpireTime", expireTime);
                    session.setAttribute("pendingOrderId", newOrderId);

                    // ✅ SỬA LỖI: Không cần set attribute vì sẽ forward
                    System.out.println("DEBUG: Chuyển hướng đến otp_verification.jsp. OTP là: " + generatedOtp);
                    request.setAttribute("pendingOrderId", newOrderId);
                    // ✅ SỬA LỖI: Dùng forward thay vì redirect để giữ session attributes
                    RequestDispatcher rd = request.getRequestDispatcher("otp_verification.jsp");
                    rd.forward(request, response);
                    return;
                } else {
                    System.err.println("DEBUG: Đặt hàng thất bại. OrderDAO.createOrderWithDetails trả về 0.");
                    request.setAttribute("errorMessage", "Đặt hàng thất bại. Đã xảy ra lỗi trong quá trình ghi vào Database.");
                    request.setAttribute("itemsToCheckout", itemsToCheckout);
                    request.setAttribute("customer", customer);
                    request.getRequestDispatcher("dathang.jsp").forward(request, response);
                    return;
                }

            } catch (Exception e) {
                System.err.println("LỖI HỆ THỐNG KHI TẠO ĐƠN HÀNG: " + e.getMessage());
                e.printStackTrace();

                request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau: " + e.getMessage());
                request.setAttribute("itemsToCheckout", itemsToCheckout);
                request.setAttribute("customer", customer);
                request.setAttribute("idsToClear", idsToClearStr != null ? Arrays.asList(idsToClearStr) : new ArrayList<>());

                request.getRequestDispatcher("dathang.jsp").forward(request, response);
                return;
            }
        }

        @Override
        public String getServletInfo
        
            () {
        return "Xử lý đặt hàng";
        }
    }
