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

@WebServlet("/admin/recipe")
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
            case "getAvailableIngredients":
                getAvailableIngredients(request, response);
                break;
            case "search":
                searchMenuItem(request, response);
                break;
            default:
                listMenuItems(request, response);
                break;
        }
    }

    // 🧾 Danh sách món ăn
    private void listMenuItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<MenuItem> items = recipeDAO.getAllMenuItems();
        List<Integer> itemsWithRecipe = recipeDAO.getItemsWithRecipeID();
        List<Ingredient> allIngredients = ingredientDAO.getAll();

        request.setAttribute("menuItems", items);
        request.setAttribute("itemsWithRecipe", itemsWithRecipe);
        request.setAttribute("ingredients", allIngredients);
        request.getRequestDispatcher("/admin/recipe-management.jsp").forward(request, response);
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
        request.getRequestDispatcher("/admin/recipe-management.jsp").forward(request, response);
    }

    // 🔄 AJAX: Lấy chi tiết công thức (JSON)
    private void getRecipeAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String itemParam = request.getParameter("itemId");
        if (itemParam == null || itemParam.trim().isEmpty()) {
            out.print("{\"exists\":false, \"error\":\"invalid_itemId\"}");
            return;
        }

        int itemId;
        try {
            itemId = Integer.parseInt(itemParam.trim());
        } catch (NumberFormatException e) {
            out.print("{\"exists\":false, \"error\":\"invalid_itemId\"}");
            return;
        }

        try {
            Recipe recipe = recipeDAO.getRecipeByItem(itemId);
            if (recipe == null) {
                out.print("{\"exists\":false}");
                return;
            }

            List<RecipeDetail> details = recipeDAO.getRecipeDetails(recipe.getRecipeID());

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"exists\":true,");
            json.append("\"recipeId\":").append(recipe.getRecipeID()).append(",");
            json.append("\"description\":\"").append(escapeJson(recipe.getDescription())).append("\",");
            json.append("\"details\":[");

            for (int i = 0; i < details.size(); i++) {
                RecipeDetail d = details.get(i);
                json.append("{")
                    .append("\"detailId\":").append(d.getRecipeDetailID()).append(",")
                    .append("\"ingredientId\":").append(d.getIngredientID()).append(",")
                    .append("\"ingredientName\":\"").append(escapeJson(d.getIngredientName())).append("\",")
                    .append("\"unit\":\"").append(escapeJson(d.getUnit())).append("\",")
                    .append("\"quantity\":").append(d.getQuantity())
                    .append("}");
                if (i < details.size() - 1) json.append(",");
            }

            json.append("]}");
            out.print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"exists\":false, \"error\":\"server_exception\"}");
        }
    }

    // 🧾 POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String action = request.getParameter("action");
        if (action == null) action = "";

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
            case "updateRecipe":
                updateRecipe(request, response);
                break;
            default:
                response.sendRedirect("recipe?action=list");
        }
    }

    // ✅ Thêm công thức mới
    private void addRecipe(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            int itemId = Integer.parseInt(request.getParameter("menuItemId"));
            String desc = request.getParameter("description");

            String[] ingredientIds = request.getParameterValues("ingredientId");
            String[] quantities = request.getParameterValues("quantity");

            List<RecipeDetail> details = new ArrayList<>();
            if (ingredientIds != null && quantities != null) {
                for (int i = 0; i < ingredientIds.length; i++) {
                    if (ingredientIds[i] == null || ingredientIds[i].isEmpty()) continue;
                    RecipeDetail d = new RecipeDetail();
                    d.setIngredientID(Integer.parseInt(ingredientIds[i]));
                    double q = 0;
                    try {
                        q = Double.parseDouble(quantities[i]);
                    } catch (NumberFormatException ignore) {}
                    d.setQuantity(q);
                    details.add(d);
                }
            }

            int newRecipeId = recipeDAO.addRecipeWithDetails(itemId, desc, details);
            if (newRecipeId > 0) {
                response.sendRedirect("recipe?action=list&success=add");
            } else {
                response.sendRedirect("recipe?action=list&error=addFail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("recipe?action=list&error=addException");
        }
    }

    private void addIngredient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int recipeId = Integer.parseInt(request.getParameter("recipeId"));
            int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
            double quantity = Double.parseDouble(request.getParameter("quantity"));
            recipeDAO.addIngredientToRecipe(recipeId, ingredientId, quantity);
            response.sendRedirect("recipe?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("recipe?action=list&error=addIngredient");
        }
    }

    private void updateIngredient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            double quantity = Double.parseDouble(request.getParameter("quantity"));
            recipeDAO.updateIngredientQuantity(detailId, quantity);
            response.sendRedirect("recipe?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("recipe?action=list&error=update");
        }
    }

    private void deleteIngredient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            recipeDAO.deleteIngredientFromRecipe(detailId);
            response.sendRedirect("recipe?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("recipe?action=list&error=delete");
        }
    }

    private void updateRecipe(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
    try {
        request.setCharacterEncoding("UTF-8");

        int recipeId = Integer.parseInt(request.getParameter("recipeId"));
        String description = request.getParameter("description");

        // --- 1️⃣ Nguyên liệu hiện có (đã tồn tại trong DB)
        // --- 1️⃣ Lấy danh sách chi tiết hiện có (đã có trong DB) ---
String[] detailIds = request.getParameterValues("detailId"); // hidden input chứa RecipeDetailID
String[] updatedQuantities = request.getParameterValues("updatedQuantity"); // ✅ KHỚP VỚI PAYLOAD
List<RecipeDetail> updatedDetails = new ArrayList<>();

if (detailIds != null && updatedQuantities != null) {
    for (int i = 0; i < detailIds.length; i++) {
        try {
            int id = Integer.parseInt(detailIds[i]);
            double q = Double.parseDouble(updatedQuantities[i]);
            RecipeDetail d = new RecipeDetail();
            d.setRecipeDetailID(id);
            d.setQuantity(q);
            updatedDetails.add(d);
        } catch (Exception ignore) {}
    }
}

        // --- 2️⃣ Nguyên liệu mới thêm
        String[] newIngredientIds = request.getParameterValues("newIngredientId");
        String[] newQuantities = request.getParameterValues("newQuantity");
        List<RecipeDetail> newDetails = new ArrayList<>();

        if (newIngredientIds != null && newQuantities != null) {
            for (int i = 0; i < newIngredientIds.length; i++) {
                try {
                    int ingId = Integer.parseInt(newIngredientIds[i]);
                    double q = Double.parseDouble(newQuantities[i]);
                    RecipeDetail d = new RecipeDetail();
                    d.setIngredientID(ingId);
                    d.setQuantity(q);
                    newDetails.add(d);
                } catch (Exception ignore) {}
            }
        }

        // --- 3️⃣ Nguyên liệu bị xóa
        String[] deletedIds = request.getParameterValues("deletedDetailId");
        List<Integer> deletedDetailIds = new ArrayList<>();

        if (deletedIds != null) {
            for (String s : deletedIds) {
                try {
                    deletedDetailIds.add(Integer.parseInt(s));
                } catch (Exception ignore) {}
            }
        }

        // --- 4️⃣ Gọi DAO
        recipeDAO.updateRecipe(recipeId, description, updatedDetails, newDetails, deletedDetailIds);
        response.sendRedirect("recipe?action=list&success=update");

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("recipe?action=list&error=updateException");
    }
}

    // 🧩 Lấy danh sách nguyên liệu chưa có trong công thức
    private void getAvailableIngredients(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            int recipeId = Integer.parseInt(request.getParameter("recipeId"));
            List<Ingredient> available = ingredientDAO.getIngredientsNotInRecipe(recipeId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < available.size(); i++) {
                Ingredient ing = available.get(i);
                json.append("{")
                    .append("\"id\":").append(ing.getId()).append(",")
                    .append("\"name\":\"").append(escapeJson(ing.getName())).append("\",")
                    .append("\"unit\":\"").append(escapeJson(ing.getUnit())).append("\"")
                    .append("}");
                if (i < available.size() - 1) json.append(",");
            }
            json.append("]");
            out.print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("[]");
        }
    }

    // 🔐 Escape JSON
    private String escapeJson(String text) {
        if (text == null) return "";
        StringBuilder sb = new StringBuilder();
        for (char c : text.toCharArray()) {
            switch (c) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                default:
                    if (c < 0x20 || c > 0x7E) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }
}
