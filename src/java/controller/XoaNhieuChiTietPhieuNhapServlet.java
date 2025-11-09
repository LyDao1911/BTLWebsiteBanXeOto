package controller;

import dao.PurchaseInvoiceDetailDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "XoaNhieuChiTietPhieuNhapServlet", urlPatterns = {"/XoaNhieuChiTietPhieuNhapServlet"})
public class XoaNhieuChiTietPhieuNhapServlet extends HttpServlet {

    private final PurchaseInvoiceDetailDAO purchaseInvoiceDetailDAO = new PurchaseInvoiceDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        
        try {
            // Lấy danh sách ID từ parameter
            String detailIdsParam = request.getParameter("detailIds");
            
            if (detailIdsParam == null || detailIdsParam.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Không có chi tiết nào được chọn để xóa.");
                response.sendRedirect("QuanLyPhieuNhapServlet");
                return;
            }
            
            // Chuyển đổi chuỗi ID thành List<Integer>
            List<Integer> detailIds = Arrays.stream(detailIdsParam.split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
            
            if (detailIds.isEmpty()) {
                session.setAttribute("errorMessage", "Danh sách ID chi tiết không hợp lệ.");
                response.sendRedirect("QuanLyPhieuNhapServlet");
                return;
            }
            
            System.out.println("DEBUG: Đang xóa các chi tiết với IDs: " + detailIds);
            
            // Thực hiện xóa nhiều chi tiết
            boolean deleteSuccess = purchaseInvoiceDetailDAO.deleteMultipleDetails(detailIds);
            
            if (deleteSuccess) {
                session.setAttribute("successMessage", "Đã xóa thành công " + detailIds.size() + " chi tiết phiếu nhập.");
                System.out.println("DEBUG: Xóa thành công " + detailIds.size() + " chi tiết.");
            } else {
                session.setAttribute("errorMessage", "Có lỗi xảy ra khi xóa chi tiết phiếu nhập. Vui lòng thử lại.");
                System.out.println("DEBUG: Xóa thất bại.");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Lỗi định dạng số: " + e.getMessage());
            session.setAttribute("errorMessage", "Lỗi định dạng dữ liệu. Vui lòng thử lại.");
        } catch (Exception e) {
            System.err.println("Lỗi hệ thống khi xóa nhiều chi tiết: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }
        
        // Quay lại trang quản lý phiếu nhập
        response.sendRedirect("DanhSachPhieuNhapServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Gọi doGet để xử lý
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý xóa nhiều chi tiết phiếu nhập";
    }
}