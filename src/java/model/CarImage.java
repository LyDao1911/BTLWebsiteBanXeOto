/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Hong Ly
 */
public class CarImage {
    private int imageID;
    private int carID;          // Khóa ngoại liên kết tới Car.java
    private String imageURL;
    private boolean isMain;

    public CarImage() {
    }

    public CarImage(int imageID, int carID, String imageURL, boolean isMain) {
        this.imageID = imageID;
        this.carID = carID;
        this.imageURL = imageURL;
        this.isMain = isMain;
    }

    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public int getCarID() {
        return carID;
    }

    public void setCarID(int carID) {
        this.carID = carID;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public boolean isIsMain() {
        return isMain;
    }

    public void setIsMain(boolean isMain) {
        this.isMain = isMain;
    }

    @Override
    public String toString() {
        return "CarImage{" + "imageID=" + imageID + ", carID=" + carID + ", imageURL=" + imageURL + ", isMain=" + isMain + '}';
    }
    
}
