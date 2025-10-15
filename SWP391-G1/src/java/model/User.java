package model;

import java.sql.Timestamp;
import java.sql.Date;

public class User {
    private int userID;
    private String username;
    private String passwordHash;
    private String fullName;
    private int roleID;
    private String email;
    private String phone;
    private Timestamp createDate;
    private boolean isActive;
    private Date startDate; // NEW

    public User() {}

    public User(int userID, String username, String passwordHash, String fullName, int roleID, String email, String phone, Timestamp createDate, boolean isActive, Date startDate) {
        this.userID = userID;
        this.username = username;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.roleID = roleID;
        this.email = email;
        this.phone = phone;
        this.createDate = createDate;
        this.isActive = isActive;
        this.startDate = startDate;
    }

    // getters/setters
    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public int getRoleID() { return roleID; }
    public void setRoleID(int roleID) { this.roleID = roleID; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Timestamp getCreateDate() { return createDate; }
    public void setCreateDate(Timestamp createDate) { this.createDate = createDate; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
}
