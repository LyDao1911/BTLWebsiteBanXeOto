/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.ReportDAO;
import model.ReportDTO;
import model.ProductReportDTO;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ReportServlet", urlPatterns = {"/ReportServlet"})
public class ReportServlet extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate, endDate;

        try {
            // Đặt ngày mặc định (7 ngày qua) nếu người dùng chưa chọn
            if (startDateStr == null || startDateStr.isEmpty() || endDateStr == null || endDateStr.isEmpty()) {
                Calendar cal = Calendar.getInstance();
                endDate = cal.getTime(); // Hôm nay
                cal.add(Calendar.DAY_OF_MONTH, -6); // 7 ngày trước
                startDate = cal.getTime();

                // Gửi ngày mặc định ra JSP để hiển thị
                startDateStr = sdf.format(startDate);
                endDateStr = sdf.format(endDate);
            } else {
                startDate = sdf.parse(startDateStr);
                endDate = sdf.parse(endDateStr);
            }

            // Đặt endDate 23:59:59 để bao gồm cả ngày cuối cùng
            Calendar calEnd = Calendar.getInstance();
            calEnd.setTime(endDate);
            calEnd.set(Calendar.HOUR_OF_DAY, 23);
            calEnd.set(Calendar.MINUTE, 59);
            calEnd.set(Calendar.SECOND, 59);
            endDate = calEnd.getTime();

            // Gọi cả 3 hàm DAO
            List<ReportDTO> reportList = reportDAO.getProfitLossReport(startDate, endDate);
            List<ProductReportDTO> bestSellingList = reportDAO.getBestSellingProducts(startDate, endDate, 5);
            List<ProductReportDTO> worstSellingList = reportDAO.getWorstSellingProducts(startDate, endDate, 5);

            // Gửi cả 3 list ra JSP
            request.setAttribute("reportList", reportList);
            request.setAttribute("bestSellingList", bestSellingList);
            request.setAttribute("worstSellingList", worstSellingList);

            // Gửi lại ngày đã chọn
            request.setAttribute("startDate", startDateStr);
            request.setAttribute("endDate", endDateStr);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi định dạng ngày tháng hoặc lỗi tải báo cáo: " + e.getMessage());
        }

        request.getRequestDispatcher("baocao.jsp").forward(request, response);
    }
}
