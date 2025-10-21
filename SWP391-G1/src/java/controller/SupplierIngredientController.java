package controller;

import dal.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.IngredientSupplier;
import model.Supplier;

@WebServlet("/admin/supplier-ingredient")
public class SupplierIngredientController extends HttpServlet {

    private SupplierDAO dao = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String supplierName = request.getParameter("supplierName");
        String ingredientName = request.getParameter("ingredientName");

        List<IngredientSupplier> list = null;
        List<Supplier> suppliers = dao.getAllSuppliers();

        if (action == null || action.isEmpty()) {
            // Mặc định hiển thị toàn bộ danh sách
            list = dao.search(null, null);
        } else if (action.equals("search")) {
            // Tìm kiếm theo tên
            list = dao.search(supplierName, ingredientName);
        } else if (action.equals("view")) {
            // Xem chi tiết nguyên liệu theo nhà cung cấp
            try {
                int supplierID = Integer.parseInt(request.getParameter("supplierID"));
                list = dao.getIngredientsBySupplier(supplierID);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Truyền dữ liệu sang view
        request.setAttribute("list", list);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("supplierName", supplierName);
        request.setAttribute("ingredientName", ingredientName);

        request.getRequestDispatcher("/admin/supplierIngredientManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/supplier-ingredient");
            return;
        }

        try {
            switch (action) {
                case "addSupplier": {
                    String name = request.getParameter("name");
                    String contact = request.getParameter("contact");
                    String phone = request.getParameter("phone");
                    String address = request.getParameter("address");
                    dao.addSupplier(name, contact, phone, address);
                    break;
                }
                case "addIngredientSupplier": {
                    int supplierID = Integer.parseInt(request.getParameter("supplierID"));
                    int ingredientID = Integer.parseInt(request.getParameter("ingredientID"));
                    double price = Double.parseDouble(request.getParameter("price"));
                    dao.addIngredientSupplier(ingredientID, supplierID, price);
                    break;
                }
                case "updatePrice": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    double newPrice = Double.parseDouble(request.getParameter("newPrice"));
                    dao.updateIngredientPrice(id, newPrice);
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    dao.deleteIngredientSupplier(id);
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình xử lý!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/supplier-ingredient");
    }
}
