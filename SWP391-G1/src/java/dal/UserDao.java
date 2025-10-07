package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.User;

public class UserDAO {

    private final DBContext db = new DBContext();

    // Đăng ký user mới
    public boolean register(User user) {
        String sql = "INSERT INTO [User] (username, passwordHash, email, fullName, phone, roleID) VALUES(?,?,?,?,?,?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getPhone());
            ps.setInt(6, user.getRoleID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean existsByUsername(String username) {
        String sql = "SELECT 1 FROM [User] WHERE username = ?";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // nếu lỗi DB thì coi như tồn tại để tránh đăng ký trùng
        }
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT 1 FROM [User] WHERE email = ?";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    // Tìm user theo username
    public User findByUsername(String username) {
        String sql = "SELECT * FROM [User] WHERE username = ?";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("userID"));
                u.setUsername(rs.getString("username"));
                u.setPasswordHash(rs.getString("passwordHash")); // match tên cột
                u.setFullName(rs.getString("fullName"));
                u.setRoleID(rs.getInt("roleID"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setCreateDate(rs.getTimestamp("createDate"));
                return u;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
