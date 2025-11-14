package controller;

import dal.ComboDAO;
import model.Combo;
import model.User;
import java.io.File;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/ComboController")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ComboController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) action = "list";

        ComboDAO dao = new ComboDAO();

        switch (action) {
            case "delete":
                if (!isManager(request)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteCombo(id);
                response.sendRedirect(request.getContextPath() + "/ComboController");
                break;

            case "edit":
                int idEdit = Integer.parseInt(request.getParameter("id"));
                Combo combo = dao.getComboById(idEdit);
                request.setAttribute("combo", combo);
                request.getRequestDispatcher("/admin/editCombo.jsp").forward(request, response);
                break;

            default:
                List<Combo> list = dao.getAllCombos();
                request.setAttribute("comboList", list);
                request.getRequestDispatcher("/admin/combo.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        ComboDAO dao = new ComboDAO();

        try {
            if ("add".equalsIgnoreCase(action)) {
                if (!isManager(request)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                String comboName = request.getParameter("comboName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                String status = request.getParameter("status");

                Part filePart = request.getPart("imagePath");
                String fileName = "default.jpg";
                if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                    String uploadPath = getServletContext().getRealPath("/") + "images/combo/";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    filePart.write(uploadPath + fileName);
                }
                String imagePath = "images/combo/" + fileName;

                Combo c = new Combo();
                c.setComboName(comboName);
                c.setDescription(description);
                c.setPrice(price);
                c.setImagePath(imagePath);
                c.setStatus(status);

                dao.addCombo(c);
                response.sendRedirect(request.getContextPath() + "/ComboController");

            } else if ("update".equalsIgnoreCase(action)) {
                if (!isManager(request)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                int id = Integer.parseInt(request.getParameter("comboID"));
                String comboName = request.getParameter("comboName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                String status = request.getParameter("status");

                String imagePath = request.getParameter("imagePath");  // hidden old image
                Part filePart = request.getPart("imagePath");
                if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                    String uploadPath = getServletContext().getRealPath("/") + "images/combo/";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    filePart.write(uploadPath + fileName);
                    imagePath = "images/combo/" + fileName;
                }

                Combo combo = new Combo(id, comboName, description, price, imagePath, status);
                dao.updateCombo(combo);
                response.sendRedirect(request.getContextPath() + "/ComboController");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý Combo");
        }
    }

    private boolean isManager(HttpServletRequest request) {
        Object acct = request.getSession().getAttribute("account");
        return acct instanceof User && ((User) acct).getRoleID() == 3;
    }
}
