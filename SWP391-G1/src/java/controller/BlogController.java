package controller;

import dal.BlogDAO;
import model.Blog;
import model.User;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.nio.file.Paths;
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
                Object acct = request.getSession().getAttribute("account");
                if (!isManager(acct)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Manager mới có quyền xóa bài viết");
                    return;
                }

                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    dao.deleteBlog(id);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                response.sendRedirect(request.getContextPath() + "/BlogController");
                break;
            }

            case "listForHome": {
                List<Blog> blogs = dao.getAllBlogs();
                request.setAttribute("blogList", blogs);
                request.getSession().setAttribute("blogList", blogs);
                request.getRequestDispatcher("/HomePage.jsp").forward(request, response);
                break;
            }

            case "edit": {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Blog blog = dao.getBlogById(id);
                    if (blog == null) {
                        response.sendRedirect(request.getContextPath() + "/BlogController");
                        return;
                    }
                    request.setAttribute("blog", blog);
                    request.getRequestDispatcher("/admin/editBlog.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/BlogController");
                }
                break;
            }

            default: {
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

        Object acct = request.getSession().getAttribute("account");
        if (acct == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Debug thông tin người dùng đang thao tác
        if (acct instanceof User) {
            User u = (User) acct;
            System.out.println("[DEBUG] User: " + u.getUsername() + " | RoleID: " + u.getRoleID());
        }

        try {
            if ("add".equalsIgnoreCase(action)) {
                if (!isManager(acct)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Manager mới có quyền thêm bài viết");
                    return;
                }
                handleAdd(request, dao, (User) acct);
                response.sendRedirect(request.getContextPath() + "/BlogController?action=listForHome");
                return;

            } else if ("update".equalsIgnoreCase(action)) {
                if (!isManager(acct)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Manager mới có quyền sửa bài viết");
                    return;
                }
                handleUpdate(request, dao);
                response.sendRedirect(request.getContextPath() + "/BlogController");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý Blog");
        }
    }

    // ===================== HÀM TIỆN ÍCH =====================
    private boolean isManager(Object acct) {
        return acct != null && acct instanceof User && ((User) acct).getRoleID() == 3;
    }

    // =============== XỬ LÝ THÊM BLOG ================
    private void handleAdd(HttpServletRequest request, BlogDAO dao, User user) throws Exception {
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
        blog.setAuthorID(user.getUserID());
        dao.addBlog(blog);
    }

    // =============== XỬ LÝ CẬP NHẬT BLOG ================
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

    // =============== LƯU ẢNH ================
    private String saveImage(Part filePart) throws IOException {
        if (filePart == null) return null;

        String submitted = filePart.getSubmittedFileName();
        if (submitted == null || submitted.trim().isEmpty()) return null;

        String originalName = Paths.get(submitted).getFileName().toString();
        String ext = "";
        int dot = originalName.lastIndexOf('.');
        if (dot >= 0) ext = originalName.substring(dot);

        String fileName = System.currentTimeMillis() + "_" + UUID.randomUUID().toString() + ext;
        String uploadPath = getServletContext().getRealPath("/images");

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String fullPath = uploadPath + File.separator + fileName;
        System.out.println("[BlogController] Saving image: " + fullPath);

        try {
            filePart.write(fullPath);
            File saved = new File(fullPath);
            System.out.println("[BlogController] File saved? " + saved.exists() +
                    ", size=" + (saved.exists() ? saved.length() : 0));
        } catch (Exception ex) {
            System.out.println("[BlogController] Error saving file: " + ex.getMessage());
            ex.printStackTrace();
            return null;
        }

        return fileName;
    }
}