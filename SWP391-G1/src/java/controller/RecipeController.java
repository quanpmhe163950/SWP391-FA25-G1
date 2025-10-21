package controller;

import dal.RecipeDAO;
import dal.IngredientDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import model.*;

@WebServlet("/recipe")
public class RecipeController extends HttpServlet {

    private final RecipeDAO recipeDAO = new RecipeDAO();
    private final IngredientDAO ingredientDAO = new IngredientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "getRecipeAjax":
                getRecipeAjax(request, response);
                break;
            case "search":
                searchMenuItem(request, response);
                break;
            default:
                listMenuItems(request, response);
                break;
        }
    }

    // 🧾 Danh sách món ăn (hiển thị modal khi cần)
    private void listMenuItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<MenuItem> items = recipeDAO.getAllMenuItems();
        List<Integer> itemsWithRecipe = recipeDAO.getItemsWithRecipeID();
        List<Ingredient> allIngredients = ingredientDAO.getAll();

        request.setAttribute("menuItems", items);
        request.setAttribute("itemsWithRecipe", itemsWithRecipe);
        request.setAttribute("ingredients", allIngredients);
        request.getRequestDispatcher("/web/admin/recipe-management.jsp").forward(request, response);
    }

    // 🔍 Tìm kiếm món ăn
    private void searchMenuItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<MenuItem> items = recipeDAO.searchMenuItemByName(keyword);
        List<Integer> itemsWithRecipe = recipeDAO.getItemsWithRecipeID();
        List<Ingredient> allIngredients = ingredientDAO.getAll();

        request.setAttribute("menuItems", items);
        request.setAttribute("itemsWithRecipe", itemsWithRecipe);
        request.setAttribute("ingredients", allIngredients);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/web/admin/recipe-management.jsp").forward(request, response);
    }

    // 🔄 AJAX: Lấy chi tiết công thức (trả JSON)
    private void getRecipeAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        Recipe recipe = recipeDAO.getRecipeByItem(itemId);

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (recipe == null) {
            out.print("{\"exists\":false}");
            return;
        }

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"exists\":true,");
        json.append("\"recipeId\":").append(recipe.getRecipeID()).append(",");
        json.append("\"description\":\"").append(escapeJson(recipe.getDescription())).append("\",");
        json.append("\"details\":[");

        List<RecipeDetail> details = recipe.getDetails();
        for (int i = 0; i < details.size(); i++) {
            RecipeDetail d = details.get(i);
            json.append("{")
                .append("\"detailId\":").append(d.getRecipeDetailID()).append(",")
                .append("\"ingredientName\":\"").append(escapeJson(d.getIngredientName())).append("\",")
                .append("\"unit\":\"").append(escapeJson(d.getUnit())).append("\",")
                .append("\"quantity\":").append(d.getQuantity())
                .append("}");
            if (i < details.size() - 1) json.append(",");
        }

        json.append("]}");
        out.print(json.toString());
    }

    // 🧾 POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        switch (action) {
            case "addRecipe":
                addRecipe(request, response);
                break;
            case "addIngredient":
                addIngredient(request, response);
                break;
            case "updateIngredient":
                updateIngredient(request, response);
                break;
            case "deleteIngredient":
                deleteIngredient(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // ➕ Thêm công thức mới
    private void addRecipe(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            String desc = request.getParameter("description");
            recipeDAO.addRecipe(itemId, desc);
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // ➕ Thêm nguyên liệu vào công thức
    private void addIngredient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int recipeId = Integer.parseInt(request.getParameter("recipeId"));
            int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
            double quantity = Double.parseDouble(request.getParameter("quantity"));
            recipeDAO.addIngredientToRecipe(recipeId, ingredientId, quantity);
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // ✏️ Cập nhật số lượng nguyên liệu trong công thức
    private void updateIngredient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            double quantity = Double.parseDouble(request.getParameter("quantity"));
            recipeDAO.updateIngredientQuantity(detailId, quantity);
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // ❌ Xóa nguyên liệu khỏi công thức
    private void deleteIngredient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            recipeDAO.deleteIngredientFromRecipe(detailId);
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // ⚙️ Escape ký tự JSON
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "");
    }
}
