package controller;

import dal.AccountDAO;
import dal.DBContext;
import dal.PurchaseOrderDAO;
import dal.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.Supplier;
import model.Ingredient;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.util.*;

@WebServlet("/admin/purchase-order")
public class PurchaseOrderController extends HttpServlet {

    private PurchaseOrderDAO poDAO;
    private SupplierDAO supplierDAO;
    private AccountDAO accountDAO;

    @Override
    public void init() {
        try {
            Connection conn = new DBContext().getConnection();
            poDAO = new PurchaseOrderDAO(conn);
            supplierDAO = new SupplierDAO(conn);
            accountDAO = new AccountDAO(conn);
            System.out.println("✅ PurchaseOrderController initialized successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ======================================================
    // GET HANDLER
    // ======================================================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "create":
                    showCreateForm(req, resp);
                    break;
                case "detail":
                    showOrderDetail(req, resp);
                    break;
                case "loadIngredients":
                    loadIngredientsBySupplier(req, resp);
                    break;
                case "searchSupplier":
                    searchSupplier(req, resp);
                    break;
                default:
                    listOrders(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    // ======================================================
    // POST HANDLER
    // ======================================================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "saveOrder":
                    saveOrder(req, resp);
                    break;
                case "addItem":
                    addItem(req, resp);
                    break;
                case "updateReceived":
                    updateReceived(req, resp);
                    break;
                default:
                    resp.sendRedirect("purchase-order");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    // ======================================================
    // 1. LIST ORDERS
    // ======================================================
    private void listOrders(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        String keyword = req.getParameter("keyword") == null ? "" : req.getParameter("keyword");
        String status = req.getParameter("status") == null ? "" : req.getParameter("status");

        List<PurchaseOrder> orders = poDAO.searchOrders(keyword, status);
        Map<Integer, String> supplierNames = new HashMap<>();

        for (PurchaseOrder o : orders) {
            String supplierName = supplierDAO.getSupplierNameById(o.getSupplierID());
            supplierNames.put(o.getPurchaseOrderID(), supplierName);
        }

        req.setAttribute("orders", orders);
        req.setAttribute("supplierNames", supplierNames);
        req.getRequestDispatcher("/admin/purchase_order_list.jsp").forward(req, resp);
    }

    // ======================================================
    // 2. SHOW CREATE FORM
    // ======================================================
    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        List<Supplier> suppliers = supplierDAO.getTopSuppliers(10);
        req.setAttribute("suppliers", suppliers);
        req.getRequestDispatcher("/admin/purchase_order_create.jsp").forward(req, resp);
    }

    // ======================================================
    // 3. SEARCH SUPPLIER
    // ======================================================
    private void searchSupplier(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        String keyword = req.getParameter("keyword");
        if (keyword == null) keyword = "";

        List<Supplier> suppliers = supplierDAO.searchSupplierByName(keyword);
        req.setAttribute("suppliers", suppliers);
        req.getRequestDispatcher("/admin/supplier_search.jsp").forward(req, resp);
    }

    // ======================================================
    // 4. LOAD INGREDIENTS BY SUPPLIER
    // ======================================================
    private void loadIngredientsBySupplier(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        String rawID = req.getParameter("supplierID");
        System.out.println("🔍 loadIngredientsBySupplier() supplierID = " + rawID);

        if (rawID == null || rawID.trim().isEmpty()) {
            req.setAttribute("ingredients", null);
            req.getRequestDispatcher("/admin/purchase_order_ingredient_table.jsp").forward(req, resp);
            return;
        }

        int supplierID = Integer.parseInt(rawID);
        List<Ingredient> ingredients = supplierDAO.getSuppliedIngredientsBySupplier(supplierID);
        req.setAttribute("ingredients", ingredients);
        req.getRequestDispatcher("/admin/purchase_order_ingredient_table.jsp").forward(req, resp);
    }

    // ======================================================
    // 5. SAVE ORDER + DETAIL
    // ======================================================
    private void saveOrder(HttpServletRequest req, HttpServletResponse resp)
        throws Exception {

    String rawSupplierID = req.getParameter("supplierID");
    String itemsData = req.getParameter("itemsData");
    System.out.println("📦 itemsData = " + itemsData);

    if (rawSupplierID == null || rawSupplierID.trim().isEmpty()) {
        System.err.println("❌ supplierID missing when saving order");
        resp.sendRedirect("purchase-order?action=create&error=no_supplier");
        return;
    }

    int supplierID = Integer.parseInt(rawSupplierID);
    String note = req.getParameter("note") == null ? "" : req.getParameter("note");

    // 1️⃣ Tạo đơn hàng chính
    PurchaseOrder po = new PurchaseOrder();
    po.setSupplierID(supplierID);
    po.setCreatedBy(1); // TODO: lấy từ session
    po.setNote(note);

    int orderID = poDAO.createPurchaseOrder(po);
    System.out.println("✅ Created new order with ID: " + orderID);

    // 2️⃣ Parse thủ công itemsData
    if (itemsData != null && !itemsData.isEmpty()) {
        itemsData = itemsData.replace("[", "").replace("]", "");
        String[] items = itemsData.split("\\},\\{");

        for (String raw : items) {
            raw = raw.replace("{", "").replace("}", "").replace("\"", "");
            Map<String, String> map = new HashMap<>();
            for (String part : raw.split(",")) {
                String[] kv = part.split(":");
                if (kv.length == 2) map.put(kv[0], kv[1]);
            }

            PurchaseOrderItem item = new PurchaseOrderItem();
            item.setPurchaseOrderID(orderID);
            item.setIngredientID(Integer.parseInt(map.get("ingredientID")));
            item.setUnitType(map.get("unitType"));
            item.setSubQuantityPerUnit(Double.parseDouble(map.get("subQuantityPerUnit")));
            item.setUnitQuantity(Double.parseDouble(map.get("unitQuantity")));
            item.setPricePerUnit(Double.parseDouble(map.get("pricePerUnit")));

            poDAO.addPurchaseOrderItem(item);
            System.out.println("✅ Added item: " + map.get("ingredientID"));
        }
    }

    resp.sendRedirect("purchase-order?action=detail&id=" + orderID);
}

    // ======================================================
    // 6. ADD ITEM MANUALLY (detail page)
    // ======================================================
    private void addItem(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        try {
            int orderID = Integer.parseInt(req.getParameter("orderID"));
            int ingredientID = Integer.parseInt(req.getParameter("ingredientID"));
            double unitQty = Double.parseDouble(req.getParameter("unitQty"));
            String unitType = req.getParameter("unitType");
            double subQty = Double.parseDouble(req.getParameter("subQty"));
            String subUnit = req.getParameter("subUnit");
            String weightPerSub = req.getParameter("weightPerSub");
            double price = Double.parseDouble(req.getParameter("price"));

            PurchaseOrderItem item = new PurchaseOrderItem();
            item.setPurchaseOrderID(orderID);
            item.setIngredientID(ingredientID);
            item.setUnitQuantity(unitQty);
            item.setUnitType(unitType);
            item.setSubQuantityPerUnit(subQty);
            item.setSubUnit(subUnit);
            item.setWeightPerSubUnit(weightPerSub);
            item.setPricePerUnit(price);

            poDAO.addPurchaseOrderItem(item);
            System.out.println("✅ Added item to orderID " + orderID + " (ingredientID: " + ingredientID + ")");
            resp.sendRedirect("purchase-order?action=detail&id=" + orderID);

        } catch (NumberFormatException e) {
            System.err.println("❌ NumberFormatException when adding item: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect("purchase-order?action=detail&error=invalid_number");
        }
    }

    // ======================================================
    // 7. SHOW ORDER DETAIL
    // ======================================================
    private void showOrderDetail(HttpServletRequest req, HttpServletResponse resp)
        throws Exception {

    int orderID = Integer.parseInt(req.getParameter("id"));
    PurchaseOrder order = poDAO.getOrderById(orderID);
    List<PurchaseOrderItem> items = poDAO.getItemsByOrder(orderID);

    // ✅ Tạo map chứa tên & đơn vị của nguyên liệu
    Map<Integer, String> ingredientNames = new HashMap<>();
    Map<Integer, String> ingredientUnits = new HashMap<>();

    for (PurchaseOrderItem item : items) {
        int ingredientId = item.getIngredientID();
        String name = supplierDAO.getIngredientNameById(ingredientId);
        String unit = supplierDAO.getIngredientUnitById(ingredientId); // 👈 thêm hàm này
        ingredientNames.put(ingredientId, name);
        ingredientUnits.put(ingredientId, unit);
    }

    // ✅ Lấy tên nhà cung cấp & người tạo
    String supplierName = supplierDAO.getSupplierNameById(order.getSupplierID());
    String creatorName = accountDAO.getUserFullNameById(order.getCreatedBy());

    // ✅ Gửi dữ liệu sang JSP
    req.setAttribute("order", order);
    req.setAttribute("items", items);
    req.setAttribute("ingredientNames", ingredientNames);
    req.setAttribute("ingredientUnits", ingredientUnits); // 👈 thêm dòng này
    req.setAttribute("supplierName", supplierName);
    req.setAttribute("creatorName", creatorName);

    req.getRequestDispatcher("/admin/purchase_order_detail.jsp").forward(req, resp);
}

    // ======================================================
    // 8. UPDATE RECEIVED QUANTITY
    // ======================================================
    private void updateReceived(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        try {
            int itemID = Integer.parseInt(req.getParameter("itemID"));
            int orderID = Integer.parseInt(req.getParameter("orderID"));
            double recUnits = Double.parseDouble(req.getParameter("receivedUnits"));
            double recSub = Double.parseDouble(req.getParameter("receivedSubUnits"));

            poDAO.updateReceivedQuantity(itemID, recUnits, recSub);
            System.out.println("✅ Updated received quantity for item " + itemID);
            resp.sendRedirect("purchase-order?action=detail&id=" + orderID);

        } catch (NumberFormatException e) {
            System.err.println("❌ Error parsing received quantities: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect("purchase-order?action=detail&error=invalid_received");
        }
    }
}
