package dal;

import java.sql.*;
import java.util.*;
import model.Blog;

public class BlogDAO extends DBContext {

    // Lấy tất cả blog (mới nhất trước)
    public List<Blog> getAllBlogs() {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blog ORDER BY CreatedDate DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

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

            rs.close();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy blog theo ID
    public Blog getBlogById(int id) {
        Blog b = null;
        String sql = "SELECT * FROM Blog WHERE BlogID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                b = new Blog();
                b.setBlogID(rs.getInt("BlogID"));
                b.setTitle(rs.getString("Title"));
                b.setContent(rs.getString("Content"));
                b.setAuthorID(rs.getInt("AuthorID"));
                b.setCreatedDate(rs.getTimestamp("CreatedDate"));
                b.setUpdatedDate(rs.getTimestamp("UpdatedDate"));
                b.setImage(rs.getString("Image"));
            }

            rs.close();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return b;
    }

    // Thêm blog mới
    public void addBlog(Blog b) {
        String sql = "INSERT INTO Blog (Title, Content, AuthorID, Image, CreatedDate, UpdatedDate) "
                   + "VALUES (?, ?, ?, ?, GETDATE(), GETDATE())";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getContent());
            ps.setInt(3, b.getAuthorID());
            ps.setString(4, b.getImage());
            ps.executeUpdate();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Cập nhật blog
    public void updateBlog(Blog b) {
        String sql = "UPDATE Blog SET Title=?, Content=?, Image=?, UpdatedDate=GETDATE() WHERE BlogID=?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getContent());
            ps.setString(3, b.getImage());
            ps.setInt(4, b.getBlogID());
            ps.executeUpdate();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Xóa blog
    public void deleteBlog(int id) {
        String sql = "DELETE FROM Blog WHERE BlogID=?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
