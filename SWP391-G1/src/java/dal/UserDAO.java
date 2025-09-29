package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.User;
import util.PasswordUtil;

public class UserDAO {
    private DBContext db;

    public UserDAO() {
        db = new DBContext();
    }

    /**
     * Đăng nhập
     * @param username tên đăng nhập
     * @param passwordInput mật khẩu người dùng nhập (plain text)
     * @return User nếu đăng nhập thành công, null nếu thất bại
     */
    public User login(String username, String passwordInput) {
        String sql = "SELECT * FROM [User] WHERE Username = ?";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("PasswordHash");
                // ✅ So sánh password nhập vào với hash trong DB
                if (PasswordUtil.checkPassword(passwordInput, storedHash)) {
                    return new User(
                        rs.getString("UserID"),
                        rs.getString("Username"),
                        storedHash,
                        rs.getString("FullName"),
                        rs.getInt("RoleID"),
                        rs.getString("Email"),
                        rs.getString("Phone"),
                        rs.getDate("CreateDate")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // login fail
    }

    /**
     * Đăng ký tài khoản mới
     * @param user User object (password là plain text)
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean register(User user) {
        String sql = "INSERT INTO [User] (UserID, Username, PasswordHash, FullName, RoleID, Email, Phone, CreateDate) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getUserID());
            ps.setString(2, user.getUsername());

            // ✅ hash password trước khi lưu
            String hashedPass = PasswordUtil.hashPassword(user.getPasswordHash());
            ps.setString(3, hashedPass);

            ps.setString(4, user.getFullName());
            ps.setInt(5, user.getRoleID());
            ps.setString(6, user.getEmail());
            ps.setString(7, user.getPhone());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra username đã tồn tại chưa
     * @param username tên đăng nhập
     * @return true nếu tồn tại
     */
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT 1 FROM [User] WHERE Username = ?";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
