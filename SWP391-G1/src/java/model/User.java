package model;

import java.util.Date;

public class User {
    private int userID;
    private String username;
    private String passwordHash;
    private String fullName;
    private int roleID;   // Có thể thay bằng Role nếu bạn muốn quan hệ object
    private String email;
    private String phone;
    private Date createDate;

    public User() {
    }

    public User(int userID, String username, String passwordHash, String fullName,
                int roleID, String email, String phone, Date createDate) {
        this.userID = userID;
        this.username = username;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.roleID = roleID;
        this.email = email;
        this.phone = phone;
        this.createDate = createDate;
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

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public int getRoleID() {
        return roleID;
    }

    public void setRoleID(int roleID) {
        this.roleID = roleID;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    @Override
    public String toString() {
        return "User{" +
                "userID='" + userID + '\'' +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                ", roleID='" + roleID + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", createDate=" + createDate +
                '}';
    }
}
