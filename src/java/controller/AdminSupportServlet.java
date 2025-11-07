/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SupportRequestDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SupportRequest;

@WebServlet(name = "AdminSupportServlet", urlPatterns = {"/AdminSupportServlet"})
public class AdminSupportServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("🔍 DEBUG - AdminSupportServlet doGet called");
        
        try {
            SupportRequestDAO dao = new SupportRequestDAO();
            List<SupportRequest> supportList = dao.getAllSupportRequests();
            
            System.out.println("🔍 DEBUG - Found " + supportList.size() + " support requests");
            
            request.setAttribute("supportList", supportList);
            request.getRequestDispatcher("admin/admin-support.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Lỗi khi tải danh sách hỗ trợ: " + e.getMessage());
            request.getRequestDispatcher("admin/admin-support.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Support Management Servlet";
    }
}