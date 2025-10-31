package controller;

import dal.BlogDAO;
import model.Blog;
import java.io.File;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/BlogController")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class BlogController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        BlogDAO dao = new BlogDAO();

        switch (action) {
            case "delete": {
                // Chỉ Manager (roleID == 3) mới được xóa
                Object acct = request.getSession().getAttribute("account");
                if (acct == null || !(acct instanceof model.User) || ((model.User) acct).getRoleID() != 3) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Manager mới có quyền xóa bài viết");
                    return;
                }
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    dao.deleteBlog(id);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                // Xóa xong thì quay lại danh sách admin
                response.sendRedirect(request.getContextPath() + "/BlogController");
                break;
            }

            case "listForHome": {
                // ✅ Lấy danh sách blog và hiển thị ở HomePage.jsp
                List<Blog> blogs = dao.getAllBlogs();
                request.setAttribute("blogList", blogs);
                // Lưu vào session để HomePage.jsp có thể dùng khi truy cập trực tiếp
                request.getSession().setAttribute("blogList", blogs);
                request.getRequestDispatcher("/HomePage.jsp").forward(request, response);
                break;
            }

            case "edit": {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Blog blog = dao.getBlogById(id);
                    request.setAttribute("blog", blog);
                    request.getRequestDispatcher("/admin/editBlog.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/BlogController");
                }
                break;
            }

            default: {
                // ✅ Danh sách blog trong admin
                List<Blog> list = dao.getAllBlogs();
                request.setAttribute("blogList", list);
                request.getRequestDispatcher("/admin/blog.jsp").forward(request, response);
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        BlogDAO dao = new BlogDAO();

        try {
            // Với thao tác thay đổi dữ liệu (add/update) chỉ cho Manager
            Object acct = request.getSession().getAttribute("account");
            boolean isManager = (acct != null && acct instanceof model.User && ((model.User) acct).getRoleID() == 3);

            if ("add".equalsIgnoreCase(action)) {
                if (!isManager) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Manager mới có quyền thêm bài viết");
                    return;
                }
                handleAdd(request, dao);

                // ✅ Sau khi thêm blog xong → về HomePage hiển thị bài mới
                response.sendRedirect(request.getContextPath() + "/BlogController?action=listForHome");
                return;

            } else if ("update".equalsIgnoreCase(action)) {
                if (!isManager) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Manager mới có quyền sửa bài viết");
                    return;
                }
                handleUpdate(request, dao);

                // ✅ Sau khi sửa → về lại trang quản lý admin
                response.sendRedirect(request.getContextPath() + "/BlogController");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý Blog");
        }
    }

    // ======================= XỬ LÝ THÊM BLOG =======================
    private void handleAdd(HttpServletRequest request, BlogDAO dao) throws Exception {
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        String fileName = saveImage(request.getPart("image"));
        if (fileName == null || fileName.isEmpty()) {
            fileName = "default.jpg";
        }

        Blog blog = new Blog();
        blog.setTitle(title);
        blog.setContent(content);
        blog.setImage(fileName);

        dao.addBlog(blog);
    }

    // ======================= XỬ LÝ CẬP NHẬT BLOG =======================
    private void handleUpdate(HttpServletRequest request, BlogDAO dao) throws Exception {
        int id = Integer.parseInt(request.getParameter("blogID"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        Blog existing = dao.getBlogById(id);
        if (existing == null) return;

        String fileName = saveImage(request.getPart("image"));
        if (fileName == null || fileName.trim().isEmpty()) {
            fileName = existing.getImage();
        }

        existing.setTitle(title);
        existing.setContent(content);
        existing.setImage(fileName);

        dao.updateBlog(existing);
    }

    // ======================= HÀM LƯU ẢNH =======================
    private String saveImage(Part filePart) throws IOException {
        if (filePart == null) return null;

        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.trim().isEmpty()) return null;

        // ✅ Đường dẫn tuyệt đối đến thư mục images (webapp/images)
        String uploadPath = getServletContext().getRealPath("/images");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        filePart.write(uploadPath + File.separator + fileName);
        return fileName;
    }
}
