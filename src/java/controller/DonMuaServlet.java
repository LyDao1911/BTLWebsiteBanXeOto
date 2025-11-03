package controller;

import dao.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Order;

@WebServlet(name = "DonMuaServlet", urlPatterns = {"/DonMuaServlet"})
public class DonMuaServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null || username.isEmpty()) {
            response.sendRedirect("dangnhap.jsp");
            return;
        }

        // ✅ THÊM XỬ LÝ THAM SỐ ORDER SUCCESS
        String orderSuccess = request.getParameter("orderSuccess");
        String orderId = request.getParameter("orderId");
        
        if ("true".equals(orderSuccess) && orderId != null) {
            request.setAttribute("successMessage", "✅ Đặt hàng thành công! Mã đơn hàng #" + orderId);
        }

        int customerId = orderDAO.getCustomerIDByUsername(username);
        List<Order> orders = new ArrayList<>();

        if (customerId > 0) {
            String tab = request.getParameter("tab");

            if (tab == null || "all".equals(tab)) {
                orders = orderDAO.getAllOrdersByCustomerId(customerId);
                request.setAttribute("currentTab", "all");
            } else if ("paid".equals(tab)) {
                orders = orderDAO.getOrdersByCustomerIdAndPaymentStatus(customerId, "Đã thanh toán");
                request.setAttribute("currentTab", "paid");
            } else if ("unpaid".equals(tab)) {
                orders = orderDAO.getOrdersByCustomerIdAndPaymentStatus(customerId, "Chưa thanh toán");
                request.setAttribute("currentTab", "unpaid");
            } else if ("completed".equals(tab)) {
                orders = orderDAO.getCompletedOrdersByCustomerId(customerId);
                request.setAttribute("currentTab", "completed");
            } else {
                orders = orderDAO.getAllOrdersByCustomerId(customerId);
                request.setAttribute("currentTab", "all");
            }
        }

        request.setAttribute("ordersAll", orders);
        request.getRequestDispatcher("donmua.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị danh sách đơn hàng theo trạng thái";
    }
}