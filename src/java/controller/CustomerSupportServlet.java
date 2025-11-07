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
import jakarta.servlet.http.HttpSession;
import model.SupportRequest;
import model.Customer;

@WebServlet(name = "CustomerSupportServlet", urlPatterns = {"/CustomerSupportServlet"})
public class CustomerSupportServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        
        if (customer == null) {
            response.sendRedirect("dangnhap.jsp");
            return;
        }
        
        try {
            SupportRequestDAO dao = new SupportRequestDAO();
            List<SupportRequest> myRequests = dao.getSupportRequestsByCustomer(customer.getCustomerID());
            
            request.setAttribute("myRequests", myRequests);
            request.getRequestDispatcher("customer/customer-support.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Lỗi khi tải lịch sử hỗ trợ");
            request.getRequestDispatcher("customer/customer-support.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Customer Support History Servlet";
    }
}
