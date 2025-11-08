package controller;

import dao.SupportRequestDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; 
import model.SupportRequest;

@WebServlet(name = "AdminSupportServlet", urlPatterns = {"/AdminSupportServlet"})
public class AdminSupportServlet extends HttpServlet {

    // Không cần dùng processRequest vì doPost chỉ gọi doGet
    // protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    //         throws ServletException, IOException {
    //     response.setContentType("text/html;charset=UTF-8");
    // }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🔍 DEBUG - AdminSupportServlet doGet called");
        
        // ⭐ BỎ QUA: Không cần lấy và chuyển thông báo từ Session sang Request ở đây.
        // Hãy để JSP xử lý trực tiếp (session.removeAttribute("successMessage") bị xóa khỏi đây)
        HttpSession session = request.getSession();

        try {
            SupportRequestDAO dao = new SupportRequestDAO();
            List<SupportRequest> supportList = dao.getAllSupportRequests();

            System.out.println("🔍 DEBUG - Found " + supportList.size() + " support requests");

            request.setAttribute("supportList", supportList);
            
            // Chuyển tiếp tới trang danh sách hiển thị
            request.getRequestDispatcher("admin-support.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            
            // ⭐ Tinh chỉnh: Lưu thông báo lỗi vào Request Scope hoặc Session (nếu muốn chuyển hướng)
            // Trong trường hợp này, vì dùng forward, dùng Request Scope là đủ
            request.setAttribute("errorMessage", "❌ Lỗi khi tải danh sách hỗ trợ: " + e.getMessage());
            
            // Đảm bảo vẫn chuyển tiếp đến trang JSP để hiển thị thông báo lỗi
            request.getRequestDispatcher("admin-support.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Gọi doGet để đảm bảo cả GET và POST đều hiển thị danh sách
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Support Management Servlet";
    }
}