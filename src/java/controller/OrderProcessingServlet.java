/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Hong Ly
 */
@WebServlet(name = "OrderProcessingServlet", urlPatterns = {"/OrderProcessingServlet"})
public class OrderProcessingServlet extends HttpServlet {

    private static final String PAYMENT_STATUS_PAID = "Paid";
    private static final String PAYMENT_STATUS_PENDING = "Pending";

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet OrderProcessingServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OrderProcessingServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        processRequest(request, response);
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
        HttpSession session = request.getSession();

        String orderIdStr = request.getParameter("orderId");
        String userOtp = request.getParameter("otp");
        String amount = request.getParameter("amount"); // Dùng để hiển thị lại

        // Lấy OTP và Order ID đang chờ xử lý từ Session
        String sessionOtp = (String) session.getAttribute("generatedOtp");
        Integer pendingOrderId = (Integer) session.getAttribute("pendingOrderId");

        // Khởi tạo các giá trị cho việc chuyển hướng lại trang lỗi
        request.setAttribute("orderId", orderIdStr);
        request.setAttribute("amount", amount);

        // ✅ Kiểm tra: Thông tin Session có còn hợp lệ hay không?
        if (orderIdStr == null || sessionOtp == null || pendingOrderId == null) {
            request.setAttribute("error", "Không tìm thấy thông tin đơn hàng hoặc OTP đã hết hạn. Vui lòng thử lại quy trình đặt hàng.");
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            // ✅ So sánh OTP VÀ so sánh ID đơn hàng trong Session với ID gửi từ form
            if (userOtp != null && userOtp.equals(sessionOtp) && orderId == pendingOrderId.intValue()) {

                // Xóa các session liên quan để ngăn chặn tái sử dụng
                session.removeAttribute("generatedOtp");
                session.removeAttribute("pendingOrderId");

                // ✅ Cập nhật trạng thái thanh toán trong DB
                OrderDAO orderDAO = new OrderDAO();
                // Giả sử updateOrderStatus(orderId, status) có sẵn
                boolean isUpdated = orderDAO.updateOrderStatus(orderId, PAYMENT_STATUS_PAID);

                if (isUpdated) {
                    // Chuyển sang trang thành công
                    request.setAttribute("orderId", orderId);
                    request.setAttribute("amount", amount);
                    request.getRequestDispatcher("payment_success.jsp").forward(request, response);
                } else {
                    // Lỗi cập nhật DB
                    request.setAttribute("error", "Xác nhận thành công nhưng lỗi cập nhật cơ sở dữ liệu. Vui lòng liên hệ hỗ trợ.");
                    request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
                }

            } else {
                // ❌ OTP sai hoặc ID đơn hàng không khớp (dấu hiệu giả mạo)
                request.setAttribute("error", "Mã OTP không chính xác hoặc đơn hàng không hợp lệ. Vui lòng kiểm tra lại!");
                request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            // Lỗi khi parse orderIdStr
            request.setAttribute("error", "Mã đơn hàng không hợp lệ.");
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
        } catch (Exception e) {
            // Bắt các lỗi DAO hoặc lỗi khác
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("otp_verification.jsp").forward(request, response);
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
