/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import java.sql.*;
import javax.swing.JOptionPane;
/**
 *
 * @author Hong Ly
 */
public class DbOperations {
    public static void setDataOrDelete(String query, String msg){
        try(Connection con = Connect.getCon(); 
            Statement st = con.createStatement()) {
            
            st.executeUpdate(query);
            
            if(!msg.isEmpty()) 
                JOptionPane.showMessageDialog(null, msg);
        }
        catch(Exception e){
            JOptionPane.showMessageDialog(null, e, "Lỗi thực thi SQL", JOptionPane.ERROR_MESSAGE);
        }
    }

    public static void executePreparedUpdate(PreparedStatement ps, String msg){
        try{
            ps.executeUpdate();
            
            if(!msg.isEmpty())
                JOptionPane.showMessageDialog(null, msg);
        }
        catch(Exception e){
            JOptionPane.showMessageDialog(null, e, "Lỗi thực thi SQL (Prepared)", JOptionPane.ERROR_MESSAGE);
        }
        finally {
            try {
                if(ps != null) ps.close();
            } catch (SQLException e) {
                JOptionPane.showMessageDialog(null, e, "Lỗi đóng Prepared Statement", JOptionPane.ERROR_MESSAGE);
            }
        }
    }
    
    public static ResultSet getData(String query){
        try (Connection con = Connect.getCon(); 
             Statement st = con.createStatement()) {
            
            ResultSet rs = st.executeQuery(query);
            return rs;
        } 
        catch (Exception e) {
            JOptionPane.showMessageDialog(null, e, "Lỗi truy vấn SQL", JOptionPane.ERROR_MESSAGE);
            return null;
        }
    }
}