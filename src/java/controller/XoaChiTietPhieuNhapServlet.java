package controller;

import dao.PurchaseInvoiceDetailDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "XoaChiTietPhieuNhapServlet", urlPatterns = {"/XoaChiTietPhieuNhapServlet"})
public class XoaChiTietPhieuNhapServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String detailIdParam = request.getParameter("detailId");
            
            if (detailIdParam == null || detailIdParam.trim().isEmpty()) {
                response.sendRedirect("DanhSachPhieuNhapServlet?error=missing_id");
                return;
            }
            
            int detailId = Integer.parseInt(detailIdParam.trim());
            PurchaseInvoiceDetailDAO dao = new PurchaseInvoiceDetailDAO();
            boolean success = dao.deleteInvoiceDetail(detailId);

            if (success) {
                response.sendRedirect("DanhSachPhieuNhapServlet?success=delete_single");
            } else {
                response.sendRedirect("DanhSachPhieuNhapServlet?error=delete_failed");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("DanhSachPhieuNhapServlet?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("DanhSachPhieuNhapServlet?error=server_error");
        }
    }
}