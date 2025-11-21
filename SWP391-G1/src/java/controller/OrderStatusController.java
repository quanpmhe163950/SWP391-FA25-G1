package controller;

import dal.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import model.Order;
import model.OrderItem;

@WebServlet("/orders/update-status")
@MultipartConfig
public class OrderStatusController extends HttpServlet {

    private final OrderDAO dao = new OrderDAO();

  @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    List<Order> completedOrders = dao.getOrdersByStatus("Completed");
    OrderDAO itemDao = new OrderDAO();

    for (Order order : completedOrders) {
        try {
            List<OrderItem> items = itemDao.getItemsByOrderId(order.getOrderID());
            order.setItems(items != null ? items : new ArrayList<OrderItem>());
        } catch (Exception e) {
            e.printStackTrace();
            order.setItems(new ArrayList<OrderItem>());
        }
    }

    request.setAttribute("completedOrders", completedOrders);
    request.getRequestDispatcher("/completedOrders.jsp").forward(request, response);
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String[] selectedIds = request.getParameterValues("selectedOrders");
        System.out.println("Selected IDs: " + Arrays.toString(selectedIds));

         System.out.println("🟢 doPost() received request");
        if (selectedIds != null) {
            for (String idStr : selectedIds) {
                try {
                    int orderId = Integer.parseInt(idStr);
                    dao.updateOrderStatus(orderId, "Served");
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
           
        }

        // Nếu gọi từ AJAX → trả về JSON
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true}");
    }
}
