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
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.Car;

/**
 *
 * @author Hong Ly
 */
@WebServlet(name = "GioHangServlet", urlPatterns = {"/GioHangServlet"})
public class GioHangServlet extends HttpServlet {

    private final CarDAO carDAO = new CarDAO();
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
            out.println("<title>Servlet GioHangServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GioHangServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();

        // 1. Lấy Map số lượng từ Session (Key=CarID, Value=Quantity)
        Map<Integer, Integer> cartQuantityMap
                = (Map<Integer, Integer>) session.getAttribute("cartQuantityMap");

        List<Car> carListWithQuantity = new ArrayList<>();

        if (cartQuantityMap != null && !cartQuantityMap.isEmpty()) {
            // 2. Lặp qua các CarID trong Map
            Set<Integer> carIDs = cartQuantityMap.keySet();

            for (int carID : carIDs) {
                // 3. Lấy thông tin chi tiết xe từ DB bằng CarDAO instance
                Car car = carDAO.getCarById(carID);

                if (car != null) {
                    // 4. "Mượn" thuộc tính quantity của Car để lưu trữ số lượng trong giỏ
                    car.setQuantity(cartQuantityMap.get(carID));
                    carListWithQuantity.add(car);
                }
            }
        }
        request.setAttribute("cartList", carListWithQuantity);

        request.getRequestDispatcher("giohang.jsp").forward(request, response);

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

        // 1. Lấy thông tin sản phẩm và số lượng
        String carIDParam = request.getParameter("carID");
        String quantityParam = request.getParameter("quantity");

        if (carIDParam == null || quantityParam == null) {
            response.sendRedirect("HomeServlet");
            return;
        }

        try {
            int carID = Integer.parseInt(carIDParam);
            int quantityToAdd = Integer.parseInt(quantityParam);

            HttpSession session = request.getSession();

            // Lấy Map giỏ hàng từ Session
            Map<Integer, Integer> cartQuantityMap
                    = (Map<Integer, Integer>) session.getAttribute("cartQuantityMap");

            if (cartQuantityMap == null) {
                cartQuantityMap = new HashMap<>();
            }

            // 2. Cập nhật hoặc thêm số lượng
            int currentQuantity = cartQuantityMap.getOrDefault(carID, 0);

            int newQuantity = currentQuantity + quantityToAdd;

            // Xử lý logic giỏ hàng (không cho số lượng âm)
            if (newQuantity <= 0) {
                cartQuantityMap.remove(carID); // Loại bỏ nếu số lượng về 0 hoặc âm
            } else {
                // TODO: CẦN THÊM logic kiểm tra tồn kho tối đa tại đây
                cartQuantityMap.put(carID, newQuantity);
            }

            // 3. Lưu lại Map số lượng vào Session
            session.setAttribute("cartQuantityMap", cartQuantityMap);

            // 4. Chuyển hướng người dùng đến trang giỏ hàng
            response.sendRedirect("GioHangServlet");

        } catch (NumberFormatException e) {
            response.sendRedirect("HomeServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("HomeServlet");
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
