/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.time.LocalDateTime;
/**
 *
 * @author Hong Ly
 */
public class SupportRequest {
    private int supportID;
    private int customerID;     // Người tạo yêu cầu
    private String subject;
    private String message;
    private LocalDateTime createdAt; // Sử dụng LocalDateTime
    private String status;
    private String response;
    private int respondentID;

    public SupportRequest() {
    }

    public SupportRequest(int supportID, int customerID, String subject, String message, LocalDateTime createdAt, String status, String response, int respondentID) {
        this.supportID = supportID;
        this.customerID = customerID;
        this.subject = subject;
        this.message = message;
        this.createdAt = createdAt;
        this.status = status;
        this.response = response;
        this.respondentID = respondentID;
    }

    public int getSupportID() {
        return supportID;
    }

    public void setSupportID(int supportID) {
        this.supportID = supportID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public int getRespondentID() {
        return respondentID;
    }

    public void setRespondentID(int respondentID) {
        this.respondentID = respondentID;
    }

    @Override
    public String toString() {
        return "SupportRequest{" + "supportID=" + supportID + ", customerID=" + customerID + ", subject=" + subject + ", message=" + message + ", createdAt=" + createdAt + ", status=" + status + ", response=" + response + ", respondentID=" + respondentID + '}';
    }
    
}
