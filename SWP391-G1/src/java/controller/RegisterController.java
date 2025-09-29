package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword"); // ✅ thêm confirm
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // 🔹 Validate input
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username is required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password cannot be empty or only spaces!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Confirm password does not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("error", "Phone number is required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Email có thể null, không cần validate

        // Tạo user mới
        User newUser = new User();
        newUser.setUserID(java.util.UUID.randomUUID().toString().substring(0, 8));
        newUser.setUsername(username.trim());
        newUser.setPasswordHash(password); // BCrypt xử lý trong DAO
        newUser.setFullName(fullname);
        newUser.setEmail((email != null && !email.trim().isEmpty()) ? email : null);
        newUser.setPhone(phone.trim());

        // 🔹 Mặc định role = "2" (Customer)
        newUser.setRoleID(2);

        boolean success = userDAO.register(newUser);
        if (success) {
            response.sendRedirect("login.jsp?msg=register_success");
        } else {
            request.setAttribute("error", "Username already exists or registration failed.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
