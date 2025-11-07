package controller;

import dao.CarDAO;
import dao.SupplierDAO;
import dao.PurchaseDAO;
import model.Car;
import model.Supplier;
import model.PurchaseInvoice;
import model.PurchaseInvoiceDetail;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "NhapHangServlet", urlPatterns = {"/NhapHangServlet"})
public class NhapHangServlet extends HttpServlet {

    private final SupplierDAO supplierDAO = new SupplierDAO();
    private final CarDAO carDAO = new CarDAO();
    private final PurchaseDAO purchaseDAO = new PurchaseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Supplier> supplierList = supplierDAO.getAllSuppliers();
            List<Car> carList = carDAO.getAllCarsWithStock(); // Sửa thành getAllCars() nếu getAllCarsWithStock() không tồn tại

            request.setAttribute("supplierList", supplierList);
            request.setAttribute("carList", carList);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải dữ liệu: " + e.getMessage());
        }
        request.getRequestDispatcher("nhaphang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // DEBUG: In tất cả parameters
            System.out.println("=== DEBUG PARAMETERS ===");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String[] paramValues = request.getParameterValues(paramName);
                System.out.println(paramName + ": " + java.util.Arrays.toString(paramValues));
            }
            System.out.println("=== END DEBUG ===");

            // 1. Lấy dữ liệu từ form
            String supplierIDStr = request.getParameter("supplierID");
            String totalAmountStr = request.getParameter("totalAmount");

            // Kiểm tra dữ liệu đầu vào KỸ HƠN
            if (supplierIDStr == null || supplierIDStr.trim().isEmpty() || supplierIDStr.equals("")) {
                System.err.println("❌ LỖI: supplierID bị rỗng!");
                request.setAttribute("errorMessage", "Lỗi: Vui lòng chọn nhà cung cấp.");
                doGet(request, response);
                return;
            }

            if (totalAmountStr == null || totalAmountStr.trim().isEmpty() || totalAmountStr.equals("0")) {
                System.err.println("❌ LỖI: totalAmount bị rỗng hoặc bằng 0!");
                request.setAttribute("errorMessage", "Lỗi: Tổng tiền không hợp lệ.");
                doGet(request, response);
                return;
            }

            int supplierID = Integer.parseInt(supplierIDStr.trim());
            BigDecimal totalAmount = new BigDecimal(totalAmountStr.trim());

            // 2. Tạo đối tượng Hóa đơn
            PurchaseInvoice invoice = new PurchaseInvoice();
            invoice.setSupplierID(supplierID);
            invoice.setTotalAmount(totalAmount);
            invoice.setInvoiceDate(LocalDateTime.now());

            // 3. Lấy dữ liệu chi tiết
            String[] carIds = request.getParameterValues("carId");
            String[] quantities = request.getParameterValues("quantity");
            String[] importPrices = request.getParameterValues("importPrice");

            // Kiểm tra chi tiết KỸ HƠN
            if (carIds == null || quantities == null || importPrices == null
                    || carIds.length == 0 || quantities.length == 0 || importPrices.length == 0) {
                System.err.println("❌ LỖI: Không có chi tiết sản phẩm!");
                request.setAttribute("errorMessage", "Lỗi: Không có sản phẩm nào trong phiếu nhập.");
                doGet(request, response);
                return;
            }

            List<PurchaseInvoiceDetail> detailsList = new ArrayList<>();

            // Xử lý từng chi tiết với KIỂM TRA LỖI
            for (int i = 0; i < carIds.length; i++) {
                // Kiểm tra từng tham số có null hoặc rỗng không
                if (carIds[i] == null || carIds[i].trim().isEmpty()
                        || quantities[i] == null || quantities[i].trim().isEmpty()
                        || importPrices[i] == null || importPrices[i].trim().isEmpty()) {
                    System.err.println("❌ LỖI: Dữ liệu chi tiết tại vị trí " + i + " bị rỗng!");
                    continue;
                }

                try {
                    int carID = Integer.parseInt(carIds[i].trim());
                    int quantity = Integer.parseInt(quantities[i].trim());
                    BigDecimal importPrice = new BigDecimal(importPrices[i].trim());

                    // Kiểm tra giá trị hợp lệ
                    if (quantity <= 0) {
                        System.err.println("❌ LỖI: Số lượng không hợp lệ tại vị trí " + i);
                        continue;
                    }
                    if (importPrice.compareTo(BigDecimal.ZERO) <= 0) {
                        System.err.println("❌ LỖI: Đơn giá không hợp lệ tại vị trí " + i);
                        continue;
                    }

                    BigDecimal subtotal = importPrice.multiply(new BigDecimal(quantity));

                    PurchaseInvoiceDetail detail = new PurchaseInvoiceDetail();
                    detail.setCarID(carID);
                    detail.setQuantity(quantity);
                    detail.setImportPrice(importPrice);
                    detail.setSubtotal(subtotal);
                    detailsList.add(detail);

                    System.out.println("✅ Đã thêm chi tiết: CarID=" + carID + ", Qty=" + quantity + ", Price=" + importPrice);

                } catch (NumberFormatException e) {
                    System.err.println("❌ LỖI: Định dạng số không hợp lệ tại vị trí " + i + ": " + e.getMessage());
                }
            }

            // Kiểm tra xem có chi tiết hợp lệ nào không
            if (detailsList.isEmpty()) {
                System.err.println("❌ LỖI: Không có chi tiết hợp lệ nào!");
                request.setAttribute("errorMessage", "Lỗi: Không có sản phẩm hợp lệ nào để nhập hàng.");
                doGet(request, response);
                return;
            }

            System.out.println("✅ Số lượng chi tiết hợp lệ: " + detailsList.size());

            // 4. Gọi DAO để lưu
            int newInvoiceID = purchaseDAO.addInvoiceAndDetails(invoice, detailsList);
            System.out.println("✅ Kết quả thêm hóa đơn: " + newInvoiceID);

            // 5. Cập nhật kho
            if (newInvoiceID > 0) {
                boolean allStockUpdated = true;

                // Lấy thông tin brandID từ database - SỬA LẠI PHẦN NÀY
                Map<Integer, Integer> carBrandMap;
                try {
                    carBrandMap = carDAO.getAllCarsWithStock().stream()
                            .collect(Collectors.toMap(Car::getCarID, Car::getBrandID));
                } catch (Exception e) {
                    System.err.println("❌ LỖI: Không thể lấy thông tin brand từ database");
                    carBrandMap = java.util.Collections.emptyMap();
                }

                for (PurchaseInvoiceDetail detail : detailsList) {
                    int brandID = carBrandMap.getOrDefault(detail.getCarID(), -1);

                    if (brandID == -1) {
                        System.err.println("⚠️ CẢNH BÁO: Không tìm thấy BrandID cho CarID " + detail.getCarID());
                        allStockUpdated = false;
                        continue;
                    }

                    Car car = new Car();
                    car.setCarID(detail.getCarID());
                    car.setBrandID(brandID);

                    boolean stockSuccess = purchaseDAO.updateStock(car, detail.getQuantity());

                    if (!stockSuccess) {
                        allStockUpdated = false;
                        System.err.println("⚠️ CẢNH BÁO: Lưu HĐ " + newInvoiceID + " nhưng lỗi cập nhật kho cho CarID " + detail.getCarID());
                    } else {
                        System.out.println("✅ Đã cập nhật kho cho CarID " + detail.getCarID() + ", thêm " + detail.getQuantity() + " sản phẩm");
                    }
                }

                // 6. Chuyển hướng theo kết quả
                if (allStockUpdated) {
                    System.out.println("✅ Hoàn tất nhập hàng thành công! Chuyển hướng...");
                    response.sendRedirect("SanPhamServlet?purchaseSuccess=true");
                } else {
                    System.out.println("⚠️ Hoàn tất nhập hàng với cảnh báo! Chuyển hướng...");
                    response.sendRedirect("SanPhamServlet?purchaseWarning=true");
                }

            } else {
                System.err.println("❌ LỖI: Không thể lưu hóa đơn!");
                request.setAttribute("errorMessage", "Lỗi khi lưu hóa đơn. Vui lòng thử lại.");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ LỖI ĐỊNH DẠNG SỐ: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi định dạng dữ liệu: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            System.err.println("❌ LỖI SERVLET NHẬP HÀNG: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý nhập hàng";
    }
}
