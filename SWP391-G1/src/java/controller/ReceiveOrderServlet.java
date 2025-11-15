package controller;

import dal.PurchaseOrderDAO;
import dal.PurchaseOrderItemDAO;
import dal.IngredientDAO;
import model.PurchaseOrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/receive-order")
public class ReceiveOrderServlet extends HttpServlet {

    private PurchaseOrderItemDAO itemDAO = new PurchaseOrderItemDAO();
    private PurchaseOrderDAO orderDAO = new PurchaseOrderDAO();
    private IngredientDAO ingredientDAO = new IngredientDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        // Lấy danh sách item dạng Map
        Map<Integer, PurchaseOrderItem> orderItems = itemDAO.getItemsMapByOrder(orderId);

        Map<String, String[]> paramMap = request.getParameterMap();

        boolean allZero = true;
        boolean allFull = true;

        for (PurchaseOrderItem item : orderItems.values()) {

            int itemId = item.getPurchaseOrderItemID();

            // User nhập theo SubUnit
            String key = "receivedSubUnits[" + itemId + "]";

            double receivedSubUnits = 0;

            if (paramMap.containsKey(key)) {
                try {
                    receivedSubUnits = Double.parseDouble(paramMap.get(key)[0]);
                } catch (Exception ignored) {}
            }

            // Quy đổi sang Unit
            double receivedUnits = receivedSubUnits * item.getSubQuantityPerUnit();

            // Lưu xuống DB: subUnit và unit
            itemDAO.updateReceivedSubUnits(
                itemId,
                receivedSubUnits,
                item.getSubQuantityPerUnit()
            );

            // *** CẬP NHẬT KHO THEO UNIT ***
            ingredientDAO.increaseStock(item.getIngredientID(), receivedUnits);

            // Xác định trạng thái đơn
            if (receivedSubUnits > 0) allZero = false;
            if (receivedUnits < item.getUnitQuantity()) allFull = false;
        }

        // Cập nhật trạng thái đơn
        String newStatus;
        if (allZero) newStatus = "pending";
        else if (allFull) newStatus = "received";
        else newStatus = "partial";

        orderDAO.updateStatus(orderId, newStatus);

        response.sendRedirect("purchase-order");
    }
}
