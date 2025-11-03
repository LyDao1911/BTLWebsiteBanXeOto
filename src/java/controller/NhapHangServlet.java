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
import java.sql.Timestamp;
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

    /**
     * doGet: tải danh sách nhà cung cấp + xe
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Supplier> supplierList = supplierDAO.getAllSuppliers();
            List<Car> carList = carDAO.getAllCarsWithStock(); // Giả sử hàm này tồn tại

            request.setAttribute("supplierList", supplierList);
            request.setAttribute("carList", carList);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải dữ liệu: " + e.getMessage());
        }
        request.getRequestDispatcher("nhaphang.jsp").forward(request, response);
    }

    /**
     * doPost: Xử lý lưu hóa đơn
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1️⃣ Lấy dữ liệu từ form (PHIÊN BẢN SỬA LỖI)
            String supplierIDStr = request.getParameter("supplierID");
            String totalAmountStr = request.getParameter("totalAmount");

            // ✅✅ BẮT LỖI (SỬA Ở ĐÂY) ✅✅
            // Kiểm tra xem supplierID có rỗng hoặc null không
            if (supplierIDStr == null || supplierIDStr.isEmpty()) {
                // Đây chính là lỗi "For input string: """
                System.err.println("❌ LỖI SERVLET: supplierID bị rỗng!");
                request.setAttribute("errorMessage", "Lỗi dữ liệu: Vui lòng chọn nhà cung cấp.");
                doGet(request, response); // Tải lại trang với thông báo lỗi
                return; // Dừng lại
            }

            // Nếu không rỗng, mới chuyển đổi
            int supplierID = Integer.parseInt(supplierIDStr);
            BigDecimal totalAmount = new BigDecimal(totalAmountStr);

            // 2️⃣ Tạo đối tượng Hóa đơn
            PurchaseInvoice invoice = new PurchaseInvoice();
            invoice.setSupplierID(supplierID); // Đã an toàn
            invoice.setTotalAmount(totalAmount);
            invoice.setInvoiceDate(LocalDateTime.now()); // Ngày giờ hiện tại

            // 3️⃣ Lấy dữ liệu chi tiết
            String[] carIds = request.getParameterValues("carId");
            String[] quantities = request.getParameterValues("quantity");
            String[] importPrices = request.getParameterValues("importPrice");

            // Kiểm tra nếu không có chi tiết (dù JS đã chặn nhưng server vẫn nên check)
            if (carIds == null || carIds.length == 0) {
                request.setAttribute("errorMessage", "Lỗi: Phiếu nhập không có sản phẩm nào.");
                doGet(request, response);
                return;
            }

            List<PurchaseInvoiceDetail> detailsList = new ArrayList<>();
            for (int i = 0; i < carIds.length; i++) {
                int carID = Integer.parseInt(carIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                BigDecimal importPrice = new BigDecimal(importPrices[i]);
                BigDecimal subtotal = importPrice.multiply(new BigDecimal(quantity));

                PurchaseInvoiceDetail detail = new PurchaseInvoiceDetail();
                detail.setCarID(carID);
                detail.setQuantity(quantity);
                detail.setImportPrice(importPrice);
                detail.setSubtotal(subtotal);
                detailsList.add(detail);
            }

            // 4️⃣ Gọi DAO để lưu (vẫn giữ nguyên)
            int newInvoiceID = purchaseDAO.addInvoiceAndDetails(invoice, detailsList);
            System.out.println("Kết quả thêm hóa đơn: " + newInvoiceID);

            // 5️⃣ Cập nhật kho (vẫn giữ nguyên)
            if (newInvoiceID > 0) {
                boolean allStockUpdated = true;
                
                // Lấy thông tin car (BrandID) để cập nhật kho
                Map<Integer, Integer> carBrandMap = carDAO.getAllCarsWithStock().stream()
                        .collect(Collectors.toMap(Car::getCarID, Car::getBrandID));
                
                for (PurchaseInvoiceDetail detail : detailsList) {
                    int brandID = carBrandMap.getOrDefault(detail.getCarID(), -1); // Lấy brandID
                    
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
                        System.err.println("⚠️ CẢNH BÁO: Lưu HĐ " + newInvoiceID
                                + " nhưng lỗi cập nhật kho cho CarID " + detail.getCarID());
                    }
                }

                // 6️⃣ Chuyển hướng theo kết quả (vẫn giữ nguyên)
                if (allStockUpdated) {
                    response.sendRedirect("SanPhamServlet?purchaseSuccess=true");
                } else {
                    response.sendRedirect("SanPhamServlet?purchaseWarning=true");
                }

            } else {
                // Lỗi khi lưu hóa đơn (vẫn giữ nguyên)
                request.setAttribute("errorMessage", "Lỗi khi lưu hóa đơn. Vui lòng thử lại.");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ LỖI SERVLET NHẬP HÀNG: " + e.getMessage());
            // Lỗi này sẽ hiển thị nếu totalAmount hoặc carId, quantity bị rỗng
            request.setAttribute("errorMessage", "Lỗi dữ liệu: " + e.getMessage());
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý nhập hàng (lưu hóa đơn và cập nhật kho)";
    }
}