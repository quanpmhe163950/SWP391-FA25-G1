package controller;



import dal.PromotionDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Promotion;

@WebServlet("/admin/promotion")
public class PromotionController extends HttpServlet {
    private PromotionDAO promotionDAO = new PromotionDAO();

    /**
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     * @throws SQLException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
            {
                try {
                    showEditForm(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(PromotionController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

            case "delete":
            {
                try {
                    deletePromotion(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(PromotionController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

            default:
            {
                try {
                    listPromotions(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(PromotionController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

        }
    }

    /**
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     * @throws SQLException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            try {
                addPromotion(request, response);
            } catch (SQLException ex) {
                Logger.getLogger(PromotionController.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else if ("update".equals(action)) {
            try {
                updatePromotion(request, response);
            } catch (SQLException ex) {
                Logger.getLogger(PromotionController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    private void listPromotions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Promotion> promotions = promotionDAO.getAllPromotions();
        request.setAttribute("promotions", promotions);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/promotion.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/promotion-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Promotion promotion = promotionDAO.getPromotionById(id);
        request.setAttribute("promotion", promotion);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/promotion-form.jsp");
        dispatcher.forward(request, response);
    }

    private void addPromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        Promotion p = extractPromotionFromRequest(request);
        promotionDAO.addPromotion(p);
        response.sendRedirect("promotion");
    }

    private void updatePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        Promotion p = extractPromotionFromRequest(request);
        p.setPromoId(Integer.parseInt(request.getParameter("promoId")));
        promotionDAO.updatePromotion(p);
        response.sendRedirect(request.getContextPath() + "/admin/promotion");
    }

    private void deletePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        promotionDAO.deletePromotion(id);
        response.sendRedirect("promotion");
    }

    private Promotion extractPromotionFromRequest(HttpServletRequest request) {
        Promotion p = new Promotion();
        try {
            if (request.getParameter("promoId") != null && !request.getParameter("promoId").isEmpty()) {
                p.setPromoId(Integer.parseInt(request.getParameter("promoId")));
            }

            p.setCode(request.getParameter("code"));
            p.setDescription(request.getParameter("description"));
            p.setDiscountType(request.getParameter("discountType"));
            p.setValue(new BigDecimal(request.getParameter("value")));

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            p.setStartDate((Date) sdf.parse(request.getParameter("startDate")));
            p.setEndDate((Date) sdf.parse(request.getParameter("endDate")));
            p.setStatus(request.getParameter("status"));
            p.setApplyCondition(request.getParameter("applyCondition"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }
    
}