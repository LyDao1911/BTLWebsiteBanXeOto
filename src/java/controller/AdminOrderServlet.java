package controller;

import dao.OrderDAO;
import model.Order;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/AdminOrderServlet"})
public class AdminOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    /**
     * doGet: Tải danh sách đơn hàng và hiển thị ra JSP
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // ⭐ SỬA LỖI 1: Thêm 2 dòng này để doGet hiển thị UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            List<Order> orderList = orderDAO.getAllOrders();
            request.setAttribute("orderList", orderList);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Không thể tải danh sách đơn hàng: " + e.getMessage());
        }
        
        request.getRequestDispatcher("quanlydonhang.jsp").forward(request, response);
    }

    /**
     * doPost: Xử lý khi Admin nhấn nút "Hoàn thành"
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // ⭐ SỬA LỖI 2: Thêm dòng này để doPost nhận UTF-8 (chữ "Hoàn thành")
        request.setCharacterEncoding("UTF-8");
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("newStatus"); // Sẽ là "Hoàn thành"

            if (newStatus != null && !newStatus.isEmpty()) {
                boolean success = orderDAO.updateDeliveryStatus(orderId, newStatus);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Cập nhật trạng thái đơn hàng #" + orderId + " thành công!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Cập nhật thất bại!");
                }
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        
        // Quay lại trang danh sách đơn hàng
        response.sendRedirect("AdminOrderServlet");
    }
}