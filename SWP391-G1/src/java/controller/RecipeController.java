package controller;

import dal.RecipeDAO;
import dal.IngredientDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
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
            case "view":
                viewRecipe(request, response);
                break;
            case "search":
                searchMenuItem(request, response);
                break;
            case "new":
                showAddRecipeForm(request, response);
                break;
            default:
                listMenuItems(request, response);
                break;
        }
    }

    // 🧾 Hiển thị danh sách món ăn (và đánh dấu món chưa có công thức)
    private void listMenuItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<MenuItem> items = recipeDAO.getAllMenuItems();
        List<Integer> itemsWithRecipe = recipeDAO.getItemsWithRecipeID(); // ✅ sửa ở đây
        request.setAttribute("menuItems", items);
        request.setAttribute("itemsWithRecipe", itemsWithRecipe);
        request.getRequestDispatcher("recipe-list.jsp").forward(request, response);
    }

    // 🔍 Tìm kiếm món ăn theo tên
    private void searchMenuItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<MenuItem> items = recipeDAO.searchMenuItemByName(keyword);
        List<Integer> itemsWithRecipe = recipeDAO.getItemsWithRecipeID(); // ✅ sửa ở đây
        request.setAttribute("menuItems", items);
        request.setAttribute("itemsWithRecipe", itemsWithRecipe);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("recipe-list.jsp").forward(request, response);
    }

    // 🍕 Xem chi tiết công thức của 1 món
    private void viewRecipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        Recipe recipe = recipeDAO.getRecipeByItem(itemId);
        List<Ingredient> allIngredients = ingredientDAO.getAll();

        request.setAttribute("recipe", recipe);
        request.setAttribute("ingredients", allIngredients);
        request.getRequestDispatcher("recipe-detail.jsp").forward(request, response);
    }

    // ➕ Hiển thị form thêm công thức cho món chưa có
    private void showAddRecipeForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        List<Ingredient> ingredients = ingredientDAO.getAll();
        request.setAttribute("itemId", itemId);
        request.setAttribute("ingredients", ingredients);
        request.getRequestDispatcher("recipe-add.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
                response.sendRedirect("recipe");
        }
    }

    // ➕ Thêm công thức mới
    private void addRecipe(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        String desc = request.getParameter("description");
        recipeDAO.addRecipe(itemId, desc);
        response.sendRedirect("recipe?action=view&itemId=" + itemId);
    }

    // ➕ Thêm nguyên liệu vào công thức
    private void addIngredient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int recipeId = Integer.parseInt(request.getParameter("recipeId"));
        int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
        double quantity = Double.parseDouble(request.getParameter("quantity"));
        recipeDAO.addIngredientToRecipe(recipeId, ingredientId, quantity);
        response.sendRedirect("recipe?action=view&itemId=" + request.getParameter("itemId"));
    }

    // ✏️ Cập nhật số lượng nguyên liệu
    private void updateIngredient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int detailId = Integer.parseInt(request.getParameter("detailId"));
        double quantity = Double.parseDouble(request.getParameter("quantity"));
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        recipeDAO.updateIngredientQuantity(detailId, quantity);
        response.sendRedirect("recipe?action=view&itemId=" + itemId);
    }

    // ❌ Xóa nguyên liệu khỏi công thức
    private void deleteIngredient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int detailId = Integer.parseInt(request.getParameter("detailId"));
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        recipeDAO.deleteIngredientFromRecipe(detailId);
        response.sendRedirect("recipe?action=view&itemId=" + itemId);
    }
}
