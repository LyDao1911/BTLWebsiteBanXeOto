/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Hong Ly
 */
public class UserAccount {
    private int userID;
    private String username;
    private String password; // Lưu ý: Trong thực tế, cần hash mật khẩu!
    private String fullName;
    private String role;     // Ví dụ: "Admin", "Customer"
    private String status;

    public UserAccount() {
    }

    public UserAccount(int userID, String username, String password, String fullName, String role, String status) {
        this.userID = userID;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
        this.status = status;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "UserAccount{" + "userID=" + userID + ", username=" + username + ", password=" + password + ", fullName=" + fullName + ", role=" + role + ", status=" + status + '}';
    }
    
}
