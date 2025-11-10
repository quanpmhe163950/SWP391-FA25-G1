package dal;

import model.User;
import java.sql.*;
import java.util.*;

public class AccountDAO {

    // ❌ Không dùng connection truyền từ ngoài nữa
    public AccountDAO() {}

    private Connection getConnection() throws SQLException {
        return DBContext.getConnection();
    }

    // ======================================================
    // GET ALL CUSTOMERS
    // ======================================================
    public List<User> getAllCustomers(String phoneFilter) {
        List<User> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder("SELECT * FROM [User] WHERE RoleID = 2");

        if (phoneFilter != null && !phoneFilter.trim().isEmpty()) {
            sb.append(" AND Phone LIKE ?");
        }
        sb.append(" ORDER BY CreateDate DESC");

        try (Connection c = getConnection();
             PreparedStatement st = c.prepareStatement(sb.toString())) {

            if (phoneFilter != null && !phoneFilter.trim().isEmpty()) {
                st.setString(1, "%" + phoneFilter.trim() + "%");
            }

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setUsername(rs.getString("Username"));
                u.setPasswordHash(rs.getString("PasswordHash"));
                u.setFullName(rs.getString("FullName"));
                u.setRoleID(rs.getInt("RoleID"));
                u.setEmail(rs.getString("Email"));
                u.setPhone(rs.getString("Phone"));
                u.setCreateDate(rs.getTimestamp("CreateDate"));
                u.setActive(rs.getBoolean("IsActive"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ======================================================
    // ACTIVATE / DEACTIVATE USER
    // ======================================================
    public void setActive(int userId, boolean active) {
        String sql = "UPDATE [User] SET IsActive = ? WHERE UserID = ?";

        try (Connection c = getConnection();
             PreparedStatement st = c.prepareStatement(sql)) {

            st.setBoolean(1, active);
            st.setInt(2, userId);
            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ======================================================
    // GET USER BY ID
    // ======================================================
    public User getById(int id) {
        String sql = "SELECT * FROM [User] WHERE UserID = ? AND RoleID = 3";

        try (Connection c = getConnection();
             PreparedStatement st = c.prepareStatement(sql)) {

            st.setInt(1, id);

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setUsername(rs.getString("Username"));
                u.setPasswordHash(rs.getString("PasswordHash"));
                u.setFullName(rs.getString("FullName"));
                u.setRoleID(rs.getInt("RoleID"));
                u.setEmail(rs.getString("Email"));
                u.setPhone(rs.getString("Phone"));
                u.setCreateDate(rs.getTimestamp("CreateDate"));
                u.setActive(rs.getBoolean("IsActive"));
                return u;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ======================================================
    // GET FULL NAME BY ID
    // ======================================================
    public String getUserFullNameById(int userId) {
        String sql = "SELECT FullName FROM [User] WHERE UserID = ?";
        String fullName = null;

        try (Connection c = getConnection();
             PreparedStatement st = c.prepareStatement(sql)) {

            st.setInt(1, userId);

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                fullName = rs.getString("FullName");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return fullName;
    }
}
