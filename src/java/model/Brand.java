package model;

import java.util.Objects;

public class Brand {

    private int brandID;
    private String brandName;
    private String logoURL;

    public Brand() {
    }

    public Brand(int brandID, String brandName, String logoURL) {
        this.brandID = brandID;
        this.brandName = brandName;
        this.logoURL = logoURL;
    }

    // ✅ Chỉ giữ một phiên bản duy nhất của hashCode và equals
    @Override
    public int hashCode() {
        return Objects.hash(brandID);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        Brand other = (Brand) obj;
        return this.brandID == other.brandID;
    }

    // --- Getters và Setters ---
    public int getBrandID() {
        return brandID;
    }

    public void setBrandID(int brandID) {
        this.brandID = brandID;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getLogoURL() {
        return logoURL;
    }

    public void setLogoURL(String logoURL) {
        this.logoURL = logoURL;
    }

    @Override
    public String toString() {
        return "Brand{" + "brandID=" + brandID + ", brandName=" + brandName + ", logoURL=" + logoURL + '}';
    }
}
