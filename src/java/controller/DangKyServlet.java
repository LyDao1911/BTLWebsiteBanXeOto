/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserAccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.UserAccount;
/**
 *
 * @author Hong Ly
 */
@WebServlet(name = "DangKyServlet", urlPatterns = {"/DangKyServlet"})
public class DangKyServlet extends HttpServlet {

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
            out.println("<title>Servlet DangKyServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DangKyServlet at " + request.getContextPath() + "</h1>");
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
        
        // 1. Lấy tất cả dữ liệu từ form
        String fullname = request.getParameter("fullname");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String repassword = request.getParameter("repassword");
        // Tớ bỏ qua 'dob' (Ngày sinh) vì nó chưa có trong CSDL của cậu
        
        // 2. Kiểm tra mật khẩu nhập lại
        if (!password.equals(repassword)) {
            request.setAttribute("errorMessage", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("dangky.jsp").forward(request, response);
            return; // Dừng xử lý
        }
        
        // 3. Khởi tạo DAO và kiểm tra username tồn tại
        UserAccountDAO dao = new UserAccountDAO();
        UserAccount existingUser = dao.findByUsername(username);
        
        if (existingUser != null) {
            // 4a. Nếu tồn tại: Gửi lỗi về trang đăng ký
            request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại!");
            request.getRequestDispatcher("dangky.jsp").forward(request, response);
        } else {
            // 4b. Nếu chưa tồn tại: Tạo đối tượng
            UserAccount user = new UserAccount();
            user.setUsername(username);
            user.setPassword(password); // Cần mã hóa (hash) mật khẩu này trong thực tế!
            user.setFullName(fullname);
            
            Customer customer = new Customer();
            customer.setFullName(fullname);
            customer.setEmail(email);
            customer.setPhoneNumber(phone);
            customer.setAddress(address);
            customer.setUserName(username); // Dùng username làm khóa ngoại

            // 5. Lưu vào CSDL
            boolean success = dao.registerUser(user, customer);
            
            if (success) {
                // 6. Chuyển hướng đến trang đăng nhập nếu thành công
                response.sendRedirect("dangnhap.jsp");
            } else {
                // 7. Báo lỗi nếu CSDL bị lỗi
                request.setAttribute("errorMessage", "Đã xảy ra lỗi máy chủ, vui lòng thử lại!");
                request.getRequestDispatcher("dangky.jsp").forward(request, response);
            }
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
