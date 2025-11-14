package dal;

import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO extends DBContext {

    // Lấy danh sách staff / manager
    public List<User> getAll(Integer roleFilter, String usernameFilter) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM [User] WHERE RoleID IN (3,4)");

        if (roleFilter != null) sql.append(" AND RoleID = ?");
        if (usernameFilter != null && !usernameFilter.trim().isEmpty()) {
            sql.append(" AND Username LIKE ?");
        }

        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (roleFilter != null) st.setInt(idx++, roleFilter);
            if (usernameFilter != null && !usernameFilter.trim().isEmpty()) {
                st.setString(idx++, "%" + usernameFilter.trim() + "%");
            }

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setUserID(rs.getInt("UserID"));
                    u.setUsername(rs.getString("Username"));
                    u.setFullName(rs.getString("FullName"));
                    u.setEmail(rs.getString("Email"));
                    u.setPhone(rs.getString("Phone"));
                    u.setRoleID(rs.getInt("RoleID"));
                    u.setActive(rs.getBoolean("IsActive"));
                    u.setStartDate(rs.getDate("StartDate"));
                    list.add(u);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    // Thêm staff mới
    public void addStaff(User u) {
        String sql = "INSERT INTO [User](Username, PasswordHash, FullName, Email, Phone, RoleID, IsActive, StartDate) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, u.getUsername());
            st.setString(2, u.getPasswordHash());
            st.setString(3, u.getFullName());
            st.setString(4, u.getEmail());
            st.setString(5, u.getPhone());
            st.setInt(6, u.getRoleID());
            st.setBoolean(7, u.isActive());
            st.setDate(8, new java.sql.Date(u.getStartDate().getTime()));

            st.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    // Cập nhật role
    public void updateRole(int userId, int roleId) {
        String sql = "UPDATE [User] SET RoleID=? WHERE UserID=?";

        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setInt(1, roleId);
            st.setInt(2, userId);
            st.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    // Bật/tắt active
    public void setActive(int userId, boolean active) {
        String sql = "UPDATE [User] SET IsActive=? WHERE UserID=?";

        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setBoolean(1, active);
            st.setInt(2, userId);
            st.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    // Đếm account theo ngày
    public int countAccountsByDate(Date date) {
        String sql = "SELECT COUNT(*) FROM [User] WHERE CAST(StartDate AS DATE) = ?";

        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setDate(1, date);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
}
