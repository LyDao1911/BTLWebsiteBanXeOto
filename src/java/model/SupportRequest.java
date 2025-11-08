package model;

import java.time.LocalDateTime;

public class SupportRequest {
    // Thuộc tính
    private int supportID;
    private int customerID;      // Người tạo yêu cầu
    
    // THUỘC TÍNH ĐÃ THÊM VÀ SỬA LỖI
    private String fullName;
    private String email;
    private String phoneNumber;
    private String address;
    // END: THUỘC TÍNH ĐÃ THÊM
    
    private String subject;
    private String message;
    private LocalDateTime createdAt; // Sử dụng LocalDateTime
    private String status;
    private String response;
    private int respondentID;

    public SupportRequest() {
    }

    // Constructor đầy đủ
    public SupportRequest(int supportID, int customerID, String fullName, String email, String phoneNumber, String address, String subject, String message, LocalDateTime createdAt, String status, String response, int respondentID) {
        this.supportID = supportID;
        this.customerID = customerID;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.subject = subject;
        this.message = message;
        this.createdAt = createdAt;
        this.status = status;
        this.response = response;
        this.respondentID = respondentID;
    }
    
    // Getters và Setters Đã Sửa Lỗi

    // FullName
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    // Email
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    // PhoneNumber
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    // Address
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    // Các Getters/Setters khác (Giữ nguyên)
    public int getSupportID() { return supportID; }
    public void setSupportID(int supportID) { this.supportID = supportID; }

    public int getCustomerID() { return customerID; }
    public void setCustomerID(int customerID) { this.customerID = customerID; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getResponse() { return response; }
    public void setResponse(String response) { this.response = response; }

    public int getRespondentID() { return respondentID; }
    public void setRespondentID(int respondentID) { this.respondentID = respondentID; }

    @Override
    public String toString() {
        return "SupportRequest{" + "supportID=" + supportID + ", customerID=" + customerID + ", fullName=" + fullName + ", email=" + email + ", phoneNumber=" + phoneNumber + ", address=" + address + ", subject=" + subject + ", message=" + message + ", createdAt=" + createdAt + ", status=" + status + ", response=" + response + ", respondentID=" + respondentID + '}';
    }
}