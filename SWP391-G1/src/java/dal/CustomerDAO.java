package dal;

import java.sql.*;
import model.User;

public class CustomerDAO extends DBContext {

    // ✅ Không dùng connection thừa kế nữa
    // ✅ Mỗi hàm tự mở connection bằng getConnection()

    public User getById(String userId) throws SQLException {
        String sql = "SELECT UserID, FullName, Phone, Email FROM [User] WHERE UserID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserID(rs.getInt("UserID"));
                    user.setFullName(rs.getString("FullName"));
                    user.setPhone(rs.getString("Phone"));
                    user.setEmail(rs.getString("Email"));
                    return user;
                }
            }
        }
        return null;
    }

    public User getUserByUsername(String username) {
        User user = null;
        String sql = "SELECT * FROM [User] WHERE Username=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUsername(rs.getString("Username"));
                    user.setPasswordHash(rs.getString("PasswordHash"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updatePassword(String username, String hashedPassword) {
        String sql = "UPDATE [User] SET PasswordHash=? WHERE Username=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hashedPassword);
            ps.setString(2, username);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getCustomerById(int id) {
        User user = null;
        String sql = "SELECT * FROM [User] WHERE UserID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserID(rs.getInt("UserID"));
                    user.setFullName(rs.getString("FullName"));
                    user.setPhone(rs.getString("Phone"));
                    user.setEmail(rs.getString("Email"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updateCustomer(User customer) {
        String sql = "UPDATE [User] SET FullName=?, Phone=?, Email=? WHERE UserID=?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getPhone());
            ps.setString(3, customer.getEmail());
            ps.setInt(4, customer.getUserID());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
