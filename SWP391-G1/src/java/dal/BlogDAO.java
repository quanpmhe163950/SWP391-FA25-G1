package dal;

import java.sql.*;
import java.util.*;
import model.Blog;

public class BlogDAO extends DBContext {

    // Lấy tất cả blog
    public List<Blog> getAllBlogs() {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blog ORDER BY CreatedDate DESC";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Blog b = new Blog();
                b.setBlogID(rs.getInt("BlogID"));
                b.setTitle(rs.getString("Title"));
                b.setContent(rs.getString("Content"));
                b.setAuthorID(rs.getInt("AuthorID"));
                b.setCreatedDate(rs.getTimestamp("CreatedDate"));
                b.setUpdatedDate(rs.getTimestamp("UpdatedDate"));
                b.setImage(rs.getString("Image"));
                list.add(b);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy blog theo ID
    public Blog getBlogById(int id) {
        String sql = "SELECT * FROM Blog WHERE BlogID = ?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Blog b = new Blog();
                    b.setBlogID(rs.getInt("BlogID"));
                    b.setTitle(rs.getString("Title"));
                    b.setContent(rs.getString("Content"));
                    b.setAuthorID(rs.getInt("AuthorID"));
                    b.setCreatedDate(rs.getTimestamp("CreatedDate"));
                    b.setUpdatedDate(rs.getTimestamp("UpdatedDate"));
                    b.setImage(rs.getString("Image"));
                    return b;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm blog mới
    public boolean addBlog(Blog b) {
        String sql = "INSERT INTO Blog (Title, Content, AuthorID, Image, CreatedDate, UpdatedDate) "
                   + "VALUES (?, ?, ?, ?, GETDATE(), GETDATE())";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getContent());
            ps.setInt(3, b.getAuthorID());
            ps.setString(4, b.getImage());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật blog
    public boolean updateBlog(Blog b) {
        String sql = "UPDATE Blog SET Title=?, Content=?, Image=?, UpdatedDate=GETDATE() WHERE BlogID=?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getContent());
            ps.setString(3, b.getImage());
            ps.setInt(4, b.getBlogID());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Xóa blog
    public boolean deleteBlog(int id) {
        String sql = "DELETE FROM Blog WHERE BlogID=?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
