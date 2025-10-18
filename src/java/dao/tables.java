/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import javax.swing.JOptionPane;
/**
 *
 * @author Hong Ly
 */
public class tables {
    public static void main(String[] args) {
        try {
            
            
            // THỨ TỰ TẠO BẢNG CƠ BẢN (CHỈ CÁC BẢNG CHA):
            
            // 1. BRAND TABLE (Không tham chiếu ai)
           String brandTable = "CREATE TABLE IF NOT EXISTS brand ("
                   + "BrandID INT AUTO_INCREMENT PRIMARY KEY,"
                   + "BrandName VARCHAR(100) NOT NULL UNIQUE,"
                    + "LogoURL VARCHAR(255)"
                    + ")";
            
            // 2. CAR TABLE (Chỉ tham chiếu BrandID)
            String carTable = "CREATE TABLE IF NOT EXISTS car ("
                    + "CarID INT AUTO_INCREMENT PRIMARY KEY,"
                    + "CarName VARCHAR(200) NOT NULL,"
                    + "BrandID INT NOT NULL,"
                    + "Price DECIMAL(18, 2) NOT NULL,"
                    + "Color VARCHAR(50),"
                    + "Description TEXT,"
                    + "Status VARCHAR(50),"
                    + "Warehouse VARCHAR(100),"
                    + "FOREIGN KEY (BrandID) REFERENCES brand(BrandID)"
                    + ")";
            
            // 3. USERACCOUNT TABLE (Không tham chiếu ai)
            String userAccountTable = "CREATE TABLE IF NOT EXISTS useraccount ("
                    + "UserID INT AUTO_INCREMENT PRIMARY KEY,"
                    + "Username VARCHAR(100) NOT NULL UNIQUE,"
                    + "Password VARCHAR(200) NOT NULL,"
                    + "FullName VARCHAR(200),"
                    + "Role VARCHAR(50) NOT NULL,"
                    + "Status VARCHAR(50) NOT NULL"
                    + ")";
            
            // 4. CUSTOMER TABLE (Tham chiếu Username tới useraccount)
            String customerTable = "CREATE TABLE IF NOT EXISTS customer ("
                    + "CustomerID INT AUTO_INCREMENT PRIMARY KEY,"
                    + "FullName VARCHAR(200),"
                    + "Email VARCHAR(200) UNIQUE,"
                    + "PhoneNumber VARCHAR(15),"
                    + "Address VARCHAR(255),"
                    + "Username VARCHAR(100) UNIQUE," // Phải là UNIQUE để làm Khóa ngoại
                    + "FOREIGN KEY (Username) REFERENCES useraccount(Username)"
                    + ")";
            
            // BẮT ĐẦU TẠO CÁC BẢNG CON:
            
            // 5. CARIMAGE TABLE (Tham chiếu CarID)
            String carImageTable = "CREATE TABLE IF NOT EXISTS carimage ("
                    + "ImageID INT AUTO_INCREMENT PRIMARY KEY,"
                    + "CarID INT NOT NULL,"
                    + "ImageURL VARCHAR(255) NOT NULL,"
                    + "IsMain TINYINT(1)," // Dùng TINYINT(1) cho BOOLEAN trong MySQL
                    + "FOREIGN KEY (CarID) REFERENCES car(CarID) ON DELETE CASCADE"
                    + ")";
            
            // 6. CARSTOCK TABLE (Tham chiếu BrandID và CarID)
            String carStockTable = "CREATE TABLE IF NOT EXISTS carstock ("
                    + "StockID INT AUTO_INCREMENT PRIMARY KEY,"
                    + "BrandID INT NOT NULL,"
                    + "CarID INT NOT NULL UNIQUE,"
                    + "Quantity INT NOT NULL,"
                    + "LastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," // Dùng DATETIME
                    + "FOREIGN KEY (BrandID) REFERENCES brand(BrandID),"
                    + "FOREIGN KEY (CarID) REFERENCES car(CarID) ON DELETE CASCADE"
                    + ")";
            
            // 7. ORDER TABLE (Tham chiếu CustomerID)
            String orderTable = "CREATE TABLE IF NOT EXISTS `order` ("
                    + "OrderID INT AUTO_INCREMENT PRIMARY KEY,"
                    + "CustomerID INT NOT NULL,"
                    + "OrderDate DATETIME NOT NULL,"
                    + "TotalAmount DECIMAL(18, 2) NOT NULL,"
                    + "PaymentStatus VARCHAR(50),"
                    + "DeliveryStatus VARCHAR(50),"
                    + "Note TEXT,"
                    + "FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID)"
                    + ")";
            
            // 8. ORDERDETAIL TABLE (Tham chiếu OrderID và CarID)
            String orderDetailTable = "CREATE TABLE IF NOT EXISTS orderdetail ("
                    + "OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,"
                    + "OrderID INT NOT NULL,"
                    + "CarID INT NOT NULL,"
                    + "Quantity INT NOT NULL,"
                    + "UserName VARCHAR(100),"
                    + "Price DECIMAL(18, 2) NOT NULL,"
                    + "Subtotal DECIMAL(18, 2) NOT NULL,"
                    + "FOREIGN KEY (OrderID) REFERENCES `order`(OrderID) ON DELETE CASCADE,"
                    + "FOREIGN KEY (CarID) REFERENCES car(CarID)"
                    + ")";
            
            // 9. PAYMENT TABLE (Tham chiếu OrderID)
            String paymentTable = "CREATE TABLE IF NOT EXISTS payment ("
                    + "PaymentID INT AUTO_INCREMENT PRIMARY KEY,"
                    + "OrderID INT NOT NULL UNIQUE,"
                    + "PaymentMethod VARCHAR(100),"
                    + "PaymentDate DATETIME NOT NULL,"
                    + "Amount DECIMAL(18, 2) NOT NULL,"
                    + "Status VARCHAR(50),"
                    + "FOREIGN KEY (OrderID) REFERENCES `order`(OrderID) ON DELETE CASCADE"
                    + ")";
            
            // 10. SUPPORTREQUEST TABLE (Tham chiếu CustomerID và RespondentID)
            String supportRequestTable = "CREATE TABLE IF NOT EXISTS supportrequest ("
                    + "SupportID INT AUTO_INCREMENT PRIMARY KEY,"
                    + "CustomerID INT NOT NULL,"
                    + "Subject VARCHAR(255),"
                    + "Message TEXT,"
                    + "CreatedAt DATETIME NOT NULL,"
                    + "Status VARCHAR(50),"
                    + "Response TEXT,"
                    + "RespondentID INT,"
                    + "FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID),"
                    + "FOREIGN KEY (RespondentID) REFERENCES useraccount(UserID)"
                    + ")";
            
            // INSERT ADMIN DETAILS (Tài khoản quản trị viên mẫu)
            String adminAccountDetails = "INSERT INTO useraccount(Username, Password, FullName, Role, Status) VALUES('admin', 'adminpass', 'Quản trị viên', 'Admin', 'Active')";
            
            // Thực thi tạo bảng theo đúng thứ tự cha - con:
            DbOperations.setDataOrDelete(brandTable, "Bảng Brand đã được tạo thành công!");
            DbOperations.setDataOrDelete(carTable, "Bảng Car đã được tạo thành công!");
            DbOperations.setDataOrDelete(userAccountTable, "Bảng UserAccount đã được tạo thành công!");
            DbOperations.setDataOrDelete(customerTable, "Bảng Customer đã được tạo thành công!");
            
            DbOperations.setDataOrDelete(carImageTable, "Bảng CarImage đã được tạo thành công!");
            DbOperations.setDataOrDelete(carStockTable, "Bảng CarStock đã được tạo thành công!");
            DbOperations.setDataOrDelete(orderTable, "Bảng Order đã được tạo thành công!");
            DbOperations.setDataOrDelete(orderDetailTable, "Bảng OrderDetail đã được tạo thành công!");
            DbOperations.setDataOrDelete(paymentTable, "Bảng Payment đã được tạo thành công!");
            DbOperations.setDataOrDelete(supportRequestTable, "Bảng SupportRequest đã được tạo thành công!");
            
            // Chèn dữ liệu ADMIN sau khi bảng UserAccount đã được tạo
            DbOperations.setDataOrDelete(adminAccountDetails, "Thông tin quản trị viên được thêm thành công!");

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, e);
        }
    }
}
