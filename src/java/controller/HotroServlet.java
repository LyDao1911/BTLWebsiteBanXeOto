package controller;

import dao.CustomerDAO;
import dao.SupportRequestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import model.SupportRequest;
import model.Customer;
import model.UserAccount;

@WebServlet(name = "HotroServlet", urlPatterns = {"/HotroServlet"})
public class HotroServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet HotroServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HotroServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("hotro.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String hoten = request.getParameter("hoten");
        String email = request.getParameter("email");
        String sdt = request.getParameter("sdt");
        String diachi = request.getParameter("diachi");
        String noidung = request.getParameter("noidung");

        System.out.println("🔍 DEBUG - Dữ liệu nhận được:");
        System.out.println("Họ tên: " + hoten);
        System.out.println("Email: " + email);
        System.out.println("SĐT: " + sdt);
        System.out.println("Địa chỉ: " + diachi);
        System.out.println("Nội dung: " + noidung);

        try {
            HttpSession session = request.getSession();
            UserAccount loggedInUser = (UserAccount) session.getAttribute("user");
            int customerID = 0;
            String username = "";

            if (loggedInUser != null) {
                // Nếu user đã đăng nhập
                customerID = loggedInUser.getUserID();
                username = loggedInUser.getUsername();
                System.out.println("✅ Sử dụng user đã đăng nhập ID: " + customerID);
            } else {
                // Nếu chưa đăng nhập, tìm hoặc tạo customer
                CustomerDAO cdao = new CustomerDAO();
                Customer existingCustomer = cdao.getCustomerByEmail(email);

                if (existingCustomer != null) {
                    customerID = existingCustomer.getCustomerID();
                    username = existingCustomer.getUserName();
                    System.out.println("✅ Tìm thấy customer có ID: " + customerID);
                } else {
                    // Tạo customer mới
                    Customer newCustomer = new Customer();
                    newCustomer.setFullName(hoten);
                    newCustomer.setEmail(email);
                    newCustomer.setPhoneNumber(sdt);
                    newCustomer.setAddress(diachi);
                    newCustomer.setUserName(email);
                    
                    customerID = cdao.insertCustomer(newCustomer);
                    username = email;
                    
                    if (customerID != -1) {
                        System.out.println("✅ Tạo mới customer có ID: " + customerID);
                    } else {
                        System.out.println("❌ Tạo mới customer thất bại");
                    }
                }
            }

            if (customerID == -1) {
                request.setAttribute("message", "❌ Không thể lưu thông tin khách hàng!");
                request.getRequestDispatcher("hotro.jsp").forward(request, response);
                return;
            }

            // Tạo yêu cầu hỗ trợ
            SupportRequest sr = new SupportRequest();
            sr.setCustomerID(customerID);
            sr.setFullName(hoten);
            sr.setEmail(email);
            sr.setPhoneNumber(sdt);
            sr.setAddress(diachi);
            sr.setSubject("Yêu cầu hỗ trợ từ: " + hoten);
            sr.setMessage(noidung);
            sr.setCreatedAt(LocalDateTime.now());
            sr.setStatus("Pending");
            sr.setResponse("");
            sr.setRespondentID(0);

            SupportRequestDAO sdao = new SupportRequestDAO();
            boolean success = sdao.insertSupportRequest(sr);

            System.out.println("🔍 DEBUG - Kết quả insert SupportRequest: " + success);

            if (success) {
                request.setAttribute("message", "✅ Yêu cầu của bạn đã được gửi thành công! Chúng tôi sẽ phản hồi trong thời gian sớm nhất.");
            } else {
                request.setAttribute("message", "❌ Gửi yêu cầu thất bại. Vui lòng thử lại.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ Lỗi trong HotroServlet: " + e.getMessage());
            request.setAttribute("message", "❌ Đã xảy ra lỗi hệ thống: " + e.getMessage());
        }

        request.getRequestDispatcher("hotro.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}