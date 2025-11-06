package dal;

import model.User;
import java.sql.*;
import java.util.*;

public class AccountDAO extends DBContext {

    public AccountDAO(Connection conn) {
this.connection = connection;
    }

    public AccountDAO() {
    }

    // ✅ Lấy tất cả Customer (RoleID = 3 chẳng hạn, tuỳ bạn định nghĩa trong DB)
    // Nếu bạn dùng RoleID = 2 cho Customer thì đổi lại nhé.
    public List<User> getAllCustomers(String phoneFilter) {
        List<User> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder("SELECT * FROM [User] WHERE RoleID = 2"); // chỉ lấy Customer

        if (phoneFilter != null && !phoneFilter.trim().isEmpty()) {
            sb.append(" AND Phone LIKE ?");
        }

        sb.append(" ORDER BY CreateDate DESC");

        try (PreparedStatement st = connection.prepareStatement(sb.toString())) {
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

    // ✅ Chỉ còn chức năng bật/tắt trạng thái tài khoản
    public void setActive(int userId, boolean active) {
        String sql = "UPDATE [User] SET IsActive = ? WHERE UserID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setBoolean(1, active);
            st.setInt(2, userId);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Optional: lấy user theo id (dùng cho xác nhận hoặc debug)
    public User getById(int id) {
        String sql = "SELECT * FROM [User] WHERE UserID = ? AND RoleID = 3";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
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
    public String getUserFullNameById(int userId) {
    String fullName = null;
    String sql = "SELECT FullName FROM [User] WHERE UserID = ?";

    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setInt(1, userId);

        try (ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                fullName = rs.getString("FullName");
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return fullName;
}

}
