/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SupportRequestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name = "RespondSupportServlet", urlPatterns = {"/RespondSupportServlet"})
public class RespondSupportServlet extends HttpServlet {

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
            out.println("<title>Servlet RespondSupportServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RespondSupportServlet at " + request.getContextPath() + "</h1>");
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
        try {
            // Lấy tham số từ request
            int supportID = Integer.parseInt(request.getParameter("supportID"));
            String responseText = request.getParameter("response");

            // Kiểm tra dữ liệu đầu vào
            if (responseText == null || responseText.trim().isEmpty()) {
                request.setAttribute("message", "❌ Nội dung phản hồi không được để trống!");
                request.getRequestDispatcher("AdminHotroServlet").forward(request, response);
                return;
            }

            SupportRequestDAO dao = new SupportRequestDAO();
            boolean success = dao.updateResponse(supportID, responseText);

            if (success) {
                request.setAttribute("message", "✅ Đã phản hồi yêu cầu #" + supportID);
            } else {
                request.setAttribute("message", "❌ Phản hồi thất bại!");
            }

            // Quay lại danh sách yêu cầu hỗ trợ
            request.getRequestDispatcher("AdminSupportServlet").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("message", "❌ ID yêu cầu hỗ trợ không hợp lệ!");
            request.getRequestDispatcher("AdminHotroServlet").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Đã xảy ra lỗi hệ thống!");
            request.getRequestDispatcher("AdminHotroServlet").forward(request, response);
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
