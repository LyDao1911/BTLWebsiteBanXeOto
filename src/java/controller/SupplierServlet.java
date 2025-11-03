/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SupplierDAO;
import model.Supplier;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Hong Ly
 */
@WebServlet(name = "SupplierServlet", urlPatterns = {"/SupplierServlet"})
public class SupplierServlet extends HttpServlet {

    private final SupplierDAO supplierDAO = new SupplierDAO();

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
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if ("edit".equals(action) && idStr != null) {
            // Trường hợp Sửa: Lấy thông tin NCC và tải lại trang
            int id = Integer.parseInt(idStr);
            Supplier supplierToEdit = supplierDAO.getSupplierById(id);
            request.setAttribute("supplierToEdit", supplierToEdit);
            loadSupplierList(request, response); // Tải lại cả danh sách

        } else if ("delete".equals(action) && idStr != null) {
            // Trường hợp Xóa
            try {
                int id = Integer.parseInt(idStr);
                supplierDAO.deleteSupplier(id);
            } catch (Exception e) {
                // Xử lý lỗi (ví dụ: không xóa được do ràng buộc)
            }
            response.sendRedirect("SupplierServlet"); // Tải lại trang

        } else {
            // Mặc định: Hiển thị danh sách
            loadSupplierList(request, response);
        }
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
        request.setCharacterEncoding("UTF-8"); // Hỗ trợ tiếng Việt
        String action = request.getParameter("action");

        String supplierID = request.getParameter("supplierID");
        String supplierName = request.getParameter("supplierName");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String email = request.getParameter("email");

        Supplier supplier = new Supplier();
        supplier.setSupplierName(supplierName);
        supplier.setPhoneNumber(phoneNumber);
        supplier.setAddress(address);
        supplier.setEmail(email);

        if ("update".equals(action) && supplierID != null && !supplierID.isEmpty()) {
            // Cập nhật
            supplier.setSupplierID(Integer.parseInt(supplierID));
            supplierDAO.updateSupplier(supplier);
        } else {
            // Thêm mới
            supplierDAO.addSupplier(supplier);
        }

        response.sendRedirect("SupplierServlet");
    }

    private void loadSupplierList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Supplier> supplierList = supplierDAO.getAllSuppliers();
        request.setAttribute("supplierList", supplierList);
        request.getRequestDispatcher("quanlynhacungcap.jsp").forward(request, response);
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
