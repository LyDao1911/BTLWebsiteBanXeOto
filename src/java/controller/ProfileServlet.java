/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import model.UserAccount;
import model.Customer;
import java.io.IOException;
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
@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet"})
public class ProfileServlet extends HttpServlet {

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
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("userAccount");

        if (user == null) {
            response.sendRedirect("dangnhap.jsp");
            return;
        }

        CustomerDAO custDAO = new CustomerDAO();
        Customer customerProfile = custDAO.getCustomerByUsername(user.getUsername());

        request.setAttribute("customer", customerProfile);
        request.getRequestDispatcher("hoso.jsp").forward(request, response);
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
        UserAccount user = (UserAccount) session.getAttribute("userAccount");

        if (user == null) {
            response.sendRedirect("dangnhap.jsp");
            return;
        }

        try {
            // 1. Lấy dữ liệu từ form (Đã xóa Ngày sinh)
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // 2. Chuẩn bị đối tượng Customer để cập nhật
            Customer updatedCustomer = new Customer();
            updatedCustomer.setUserName(user.getUsername());
            updatedCustomer.setFullName(fullName);
            updatedCustomer.setEmail(email);
            updatedCustomer.setPhoneNumber(phone);
            updatedCustomer.setAddress(address);
            // Đã xóa setNgaySinh

            // 3. Gọi DAO để cập nhật
            CustomerDAO custDAO = new CustomerDAO();
            boolean success = custDAO.updateCustomerProfile(updatedCustomer);

            if (success) {
                request.setAttribute("message", "Cập nhật hồ sơ thành công!");
            } else {
                request.setAttribute("errorMessage", "Cập nhật thất bại. Vui lòng thử lại.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
        }

        // 4. Tải lại trang (gọi lại doGet để lấy data mới nhất)
        doGet(request, response);
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
