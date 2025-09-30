package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.isBlank() ||
            password == null || password.isBlank()) {
            request.setAttribute("error", "Username and password cannot be empty!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findByUsername(username); // lấy user theo username
        if (user != null && BCrypt.checkpw(password, user.getPasswordHash())) {
            HttpSession session = request.getSession();
            session.setAttribute("account", user);

            if (user.getRoleID() == 1) {
                response.sendRedirect("admin/home.jsp");
            } else {
                response.sendRedirect("home.jsp");
            }
        } else {
            request.setAttribute("error", "Invalid username or password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
