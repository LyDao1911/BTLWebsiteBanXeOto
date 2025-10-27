/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
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
@WebServlet(name = "XoaXeServlet", urlPatterns = {"/XoaXeServlet"})
public class XoaXeServlet extends HttpServlet {

    private final CarDAO dao = new CarDAO();

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
            out.println("<title>Servlet XoaXeServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet XoaXeServlet at " + request.getContextPath() + "</h1>");
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
        String carIdParam = request.getParameter("carId");

        if (carIdParam == null || carIdParam.isEmpty()) {
            response.sendRedirect("SanPhamServlet?msg=invalid_id");
            return;
        }

        try {
            int carId = Integer.parseInt(carIdParam);

            // 2. Gọi phương thức xóa trong DAO
            boolean deleted = dao.deleteCar(carId);

            // 3. Xử lý kết quả và chuyển hướng
            if (deleted) {
                // Xóa thành công
                response.sendRedirect("SanPhamServlet?msg=delete_success");
            } else {
                // Xóa thất bại (do CarID không tồn tại hoặc đã có trong OrderDetail)
                response.sendRedirect("SanPhamServlet?msg=delete_fail");
            }

        } catch (NumberFormatException nfe) {
            System.err.println("Lỗi NumberFormatException: " + carIdParam + " không phải là số.");
            response.sendRedirect("SanPhamServlet?msg=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            // Lỗi hệ thống, lỗi kết nối DB, v.v.
            response.sendRedirect("SanPhamServlet?msg=error");
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
