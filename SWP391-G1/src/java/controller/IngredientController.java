package controller;

import dal.IngredientDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Ingredient;

@WebServlet("/admin/ingredient")
public class IngredientController extends HttpServlet {

    private IngredientDAO dao = new IngredientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                request.getRequestDispatcher("/admin/ingredient_add.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                Ingredient ing = dao.getById(id);
                request.setAttribute("ingredient", ing);
                request.getRequestDispatcher("/admin/ingredient_edit.jsp").forward(request, response);
                break;
            case "delete":
                dao.delete(Integer.parseInt(request.getParameter("id")));
                response.sendRedirect(request.getContextPath() + "/admin/ingredient");
                break;
            default:
                List<Ingredient> list = dao.getAll();
                request.setAttribute("list", list);
                request.getRequestDispatcher("/admin/ingredient_list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
    Ingredient i = new Ingredient();
    i.setName(request.getParameter("name"));
    i.setUnit(request.getParameter("unit"));
    i.setQuantity(0); // mặc định 0 khi thêm mới
    i.setPrice(Double.parseDouble(request.getParameter("price")));
    dao.insert(i);
}
 else if ("edit".equals(action)) {
            Ingredient i = new Ingredient();
            i.setId(Integer.parseInt(request.getParameter("id")));
            i.setName(request.getParameter("name"));
            i.setUnit(request.getParameter("unit"));
            i.setPrice(Double.parseDouble(request.getParameter("price")));
            dao.update(i);
        }

        response.sendRedirect(request.getContextPath() + "/admin/ingredient");
    }
}
