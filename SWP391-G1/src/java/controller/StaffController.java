package controller;

import dal.StaffDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.Normalizer;
import java.text.SimpleDateFormat;
import java.util.*;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/admin/staff")
public class StaffController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ❗ DAO tạo mới theo từng request → tránh lỗi "The connection is closed"
        StaffDAO dao = new StaffDAO();

        String action = request.getParameter("action");
        String roleStr = request.getParameter("role");
        String usernameFilter = request.getParameter("username");
        Integer roleFilter = null;

        if ("add".equals(action)) {
            request.getRequestDispatcher("/admin/staff_add.jsp").forward(request, response);
            return;
        }

        if ("3".equals(roleStr) || "4".equals(roleStr)) {
            roleFilter = Integer.parseInt(roleStr);
        }

        // Lấy danh sách nhân viên theo filter
        List<User> list = dao.getAll(roleFilter, usernameFilter);

        request.setAttribute("list", list);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("username", usernameFilter);
        request.getRequestDispatcher("/admin/staff_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // ❗ DAO phải tạo mới trong POST luôn
        StaffDAO dao = new StaffDAO();

        // --- Thêm mới staff ---
        if ("add".equals(action)) {
            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            int roleId = Integer.parseInt(request.getParameter("role"));
            String startDateStr = request.getParameter("startDate");

            try {
                Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(startDateStr);
                java.sql.Date sqlDate = new java.sql.Date(startDate.getTime());

                // validate ngày bắt đầu (chỉ cho hiện tại hoặc tương lai)
                Date now = new Date();
                if (startDate.before(new java.util.Date(now.getTime() - 24L * 60 * 60 * 1000))) {
                    request.setAttribute("error", "Start date cannot be in the past!");
                    request.getRequestDispatcher("/admin/staff_add.jsp").forward(request, response);
                    return;
                }

                // tạo username + hash pw
                String username = generateUsername(fullname, sqlDate, dao);
                String defaultPassword = "123456";
                String hashed = BCrypt.hashpw(defaultPassword, BCrypt.gensalt());

                User u = new User();
                u.setUsername(username);
                u.setPasswordHash(hashed);
                u.setFullName(fullname);
                u.setPhone(phone);
                u.setRoleID(roleId);
                u.setActive(true);
                u.setStartDate(sqlDate);

                dao.addStaff(u);
                response.sendRedirect(request.getContextPath() + "/admin/staff");
                return;

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Invalid input data!");
                request.getRequestDispatcher("/admin/staff_add.jsp").forward(request, response);
                return;
            }
        }

        // --- Cập nhật vai trò ---
        if ("updateRole".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            dao.updateRole(userId, roleId);
            response.sendRedirect(request.getContextPath() + "/admin/staff");
            return;
        }

        // --- Bật/tắt trạng thái ---
        if ("toggleActive".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean active = "1".equals(request.getParameter("active"));
            dao.setActive(userId, active);
            response.sendRedirect(request.getContextPath() + "/admin/staff");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/staff");
    }

    // --- Generate Username ---
    private String generateUsername(String fullname, java.sql.Date startDate, StaffDAO dao) {
        String cleanName = removeVietnameseAccents(fullname.trim().toLowerCase());

        String[] parts = cleanName.split("\\s+");
        String name = parts[parts.length - 1];

        StringBuilder initials = new StringBuilder();
        for (int i = 0; i < parts.length - 1; i++) {
            initials.append(parts[i].charAt(0));
        }

        String datePart = new SimpleDateFormat("ddMMyyyy").format(startDate);

        int count = dao.countAccountsByDate(startDate);
        String sequence = String.format("%03d", count + 1);

        return name + initials + datePart + sequence;
    }

    // --- Remove Vietnamese accents ---
    private String removeVietnameseAccents(String input) {
        if (input == null) return "";
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
        return normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "")
                         .replaceAll("đ", "d")
                         .replaceAll("Đ", "D");
    }
}
