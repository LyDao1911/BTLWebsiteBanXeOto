/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;

/**
 *
 * @author Hong Ly
 */
public class Connect {

    public static Connection getCon() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/sellingcar?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC",
                    "root",
                    ""
            );

            System.out.println("Kết nối CSDL thành công!"); // Bổ sung log thành công
            return con;
        } catch (Exception e) {
            System.err.println("Lỗi kết nối CSDL: " + e.getMessage()); // ✅ IN RA LỖI THẬT
            // e.printStackTrace(); // Có thể dùng thêm để in toàn bộ stack trace
            return null;

        }
    }
}
