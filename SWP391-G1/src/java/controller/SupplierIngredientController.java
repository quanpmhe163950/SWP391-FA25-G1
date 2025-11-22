package controller;

import dal.SupplierDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Supplier;
import model.Ingredient;

@WebServlet(name = "SupplierIngredientController", urlPatterns = {"/admin/supplier-ingredient"})
public class SupplierIngredientController extends HttpServlet {

    private SupplierDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new SupplierDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {

            // ==== AJAX: Load nguyên liệu của 1 nhà cung cấp ====
            case "getIngredients": {
                try {
                    int supplierID = Integer.parseInt(request.getParameter("supplierID"));

                    List<Ingredient> provided = dao.getSuppliedIngredientsBySupplier(supplierID);
                    List<Ingredient> notProvided = dao.getUnsuppliedIngredientsBySupplier(supplierID);

                    request.setAttribute("provided", provided);
                    request.setAttribute("notProvided", notProvided);

                    // ⚠️ Dùng đường dẫn tuyệt đối từ context root (rất quan trọng)
                    RequestDispatcher rd = request.getRequestDispatcher("/admin/ingredientFragment.jsp");
                    rd.forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid supplier ID");
                }
                break;
            }

            // ==== Mặc định: hiển thị trang quản lý ====
            default: {
                List<Supplier> suppliers = dao.getAllSuppliers();
                request.setAttribute("suppliers", suppliers);

                // ⚠️ Đặt JSP trong /WEB-INF để tránh truy cập trực tiếp
                RequestDispatcher rd = request.getRequestDispatcher("/admin/supplierIngredientManagement.jsp");
                rd.forward(request, response);
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {

            // ==== Thêm nhà cung cấp ====
            case "addSupplier": {
                dao.addSupplier(
                        request.getParameter("supplierName"),
                        request.getParameter("phone"),
                        request.getParameter("email"),
                        request.getParameter("address"),
                        true
                );
                response.sendRedirect(request.getContextPath() + "/admin/supplier-ingredient");
                break;
            }

            // ==== Cập nhật nhà cung cấp ====
            case "updateSupplier": {
                int id = Integer.parseInt(request.getParameter("supplierID"));
                dao.updateSupplier(
                        id,
                        request.getParameter("supplierName"),
                        request.getParameter("phone"),
                        request.getParameter("email"),
                        request.getParameter("address"),
                        request.getParameter("active") != null
                );
                response.sendRedirect(request.getContextPath() + "/admin/supplier-ingredient");
                break;
            }

            // ==== Lưu danh sách nguyên liệu cung cấp ====
            case "saveIngredients": {
                int supplierID = Integer.parseInt(request.getParameter("supplierID"));
                String json = request.getParameter("data");

                if (json != null && !json.isBlank()) {
                    json = json.trim();
                    if (json.startsWith("[")) json = json.substring(1);
                    if (json.endsWith("]")) json = json.substring(0, json.length() - 1);

                    String[] items = json.split("\\},\\{");
                    for (String item : items) {
                        item = item.replace("{", "").replace("}", "");
                        String[] pairs = item.split(",");
                        int id = 0;
                        double price = 0;
                        for (String p : pairs) {
                            String[] kv = p.split(":");
                            if (kv.length != 2) continue;
                            String key = kv[0].replaceAll("\"", "").trim();
                            String val = kv[1].replaceAll("\"", "").trim();
                            if (key.equals("id")) id = Integer.parseInt(val);
                            if (key.equals("price")) price = Double.parseDouble(val);
                        }
                        dao.addOrUpdateSupplierIngredient(supplierID, id, price);
                    }
                }

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("OK");
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/admin/supplier-ingredient");
        }
    }
}
