package dal;

import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.Ingredient;
import model.IngredientSupplier;
import model.Supplier;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PurchaseOrderDAO {

    // Không dùng connection truyền từ controller nữa
    public PurchaseOrderDAO() {}

    private Connection getConnection() throws SQLException {
        return DBContext.getConnection();
    }

    // =============================
    // CREATE PURCHASE ORDER
    // =============================
    public int createPurchaseOrder(PurchaseOrder po) throws Exception {
        String sql = "INSERT INTO PurchaseOrder (SupplierID, CreatedBy, Note) VALUES (?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, po.getSupplierID());
            ps.setInt(2, po.getCreatedBy());
            ps.setString(3, po.getNote());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    // ======================================================
    // ADD PURCHASE ORDER ITEM
    // ======================================================
    public void addPurchaseOrderItem(PurchaseOrderItem item) throws Exception {
        String sql = "INSERT INTO PurchaseOrderItem "
                + "(PurchaseOrderID, IngredientID, UnitQuantity, UnitType, SubQuantityPerUnit, SubUnit, WeightPerSubUnit, PricePerUnit) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        System.out.println("DEBUG: addPurchaseOrderItem called");
        System.out.println("DEBUG: SQL = " + sql);
        System.out.println("DEBUG: item values - orderID=" + item.getPurchaseOrderID()
                + ", ingredientID=" + item.getIngredientID()
                + ", unitQty=" + item.getUnitQuantity()
                + ", unitType=" + item.getUnitType()
                + ", subQty=" + item.getSubQuantityPerUnit()
                + ", subUnit=" + item.getSubUnit()
                + ", weightPerSubUnit=" + item.getWeightPerSubUnit()
                + ", price=" + item.getPricePerUnit());

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            boolean auto = conn.getAutoCommit();
            System.out.println("DEBUG: connection autocommit = " + auto);

            ps.setInt(1, item.getPurchaseOrderID());
            ps.setInt(2, item.getIngredientID());
            ps.setDouble(3, item.getUnitQuantity());
            ps.setString(4, item.getUnitType());
            ps.setDouble(5, item.getSubQuantityPerUnit());
            ps.setString(6, item.getSubUnit());
            ps.setString(7, item.getWeightPerSubUnit());
            ps.setDouble(8, item.getPricePerUnit());

            int rows = ps.executeUpdate();
            System.out.println("DEBUG: executeUpdate returned rows = " + rows);

            if (!auto) {
                conn.commit();
                System.out.println("DEBUG: manual commit done");
            }

        } catch (SQLException e) {
            System.err.println("ERROR: Exception inserting PurchaseOrderItem: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // =============================
    // GET ALL ORDERS
    // =============================
    public List<PurchaseOrder> getAllOrders() throws Exception {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = "SELECT * FROM PurchaseOrder ORDER BY OrderDate DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setPurchaseOrderID(rs.getInt("PurchaseOrderID"));
                po.setSupplierID(rs.getInt("SupplierID"));
                po.setCreatedBy(rs.getInt("CreatedBy"));
                po.setReceivedBy((Integer) rs.getObject("ReceivedBy"));
                po.setOrderDate(rs.getTimestamp("OrderDate"));
                po.setReceiveDate(rs.getTimestamp("ReceiveDate"));
                po.setStatus(rs.getString("Status"));
                po.setNote(rs.getString("Note"));
                list.add(po);
            }
        }
        return list;
    }

    // =============================
    // GET ITEMS BY ORDER
    // =============================
    public List<PurchaseOrderItem> getItemsByOrder(int purchaseOrderID) throws Exception {
        List<PurchaseOrderItem> list = new ArrayList<>();

        String sql = "SELECT * FROM PurchaseOrderItem WHERE PurchaseOrderID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, purchaseOrderID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PurchaseOrderItem item = new PurchaseOrderItem();
                item.setPurchaseOrderItemID(rs.getInt("PurchaseOrderItemID"));
                item.setPurchaseOrderID(rs.getInt("PurchaseOrderID"));
                item.setIngredientID(rs.getInt("IngredientID"));
                item.setUnitQuantity(rs.getDouble("UnitQuantity"));
                item.setUnitType(rs.getString("UnitType"));
                item.setSubQuantityPerUnit(rs.getDouble("SubQuantityPerUnit"));
                item.setSubUnit(rs.getString("SubUnit"));
                item.setWeightPerSubUnit(rs.getString("WeightPerSubUnit"));
                item.setPricePerUnit(rs.getDouble("PricePerUnit"));
                item.setQuantityReceivedUnits(rs.getDouble("QuantityReceivedUnits"));
                item.setQuantityReceivedSubUnits(rs.getDouble("QuantityReceivedSubUnits"));
                item.setTotalPrice(rs.getDouble("TotalPrice"));
                list.add(item);
            }
        }
        return list;
    }

    // =============================
    // UPDATE RECEIVED QUANTITY
    // =============================
    public void updateReceivedQuantity(int itemID, double units, double subUnits) throws Exception {
        String sql = "UPDATE PurchaseOrderItem SET QuantityReceivedUnits = ?, QuantityReceivedSubUnits = ? "
                + "WHERE PurchaseOrderItemID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, units);
            ps.setDouble(2, subUnits);
            ps.setInt(3, itemID);
            ps.executeUpdate();
        }
    }

    // =============================
    // UPDATE ORDER STATUS
    // =============================
    public void updateOrderStatus(int orderID, String status) throws Exception {
        String sql = "UPDATE PurchaseOrder SET Status = ?, ReceiveDate = GETDATE() WHERE PurchaseOrderID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, orderID);
            ps.executeUpdate();
        }
    }

    // =============================
    // SEARCH ORDERS
    // =============================
    public List<PurchaseOrder> searchOrders(String keyword, String status) throws Exception {
        List<PurchaseOrder> list = new ArrayList<>();

        String sql = "SELECT po.* FROM PurchaseOrder po JOIN Supplier s ON po.SupplierID = s.SupplierID "
                + "WHERE (s.SupplierName LIKE ? OR ? = '') "
                + "AND (po.Status = ? OR ? = '') "
                + "ORDER BY po.OrderDate DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, keyword);
            ps.setString(3, status);
            ps.setString(4, status);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setPurchaseOrderID(rs.getInt("PurchaseOrderID"));
                po.setSupplierID(rs.getInt("SupplierID"));
                po.setCreatedBy(rs.getInt("CreatedBy"));
                po.setReceivedBy((Integer) rs.getObject("ReceivedBy"));
                po.setOrderDate(rs.getTimestamp("OrderDate"));
                po.setReceiveDate(rs.getTimestamp("ReceiveDate"));
                po.setStatus(rs.getString("Status"));
                po.setNote(rs.getString("Note"));
                list.add(po);
            }
        }
        return list;
    }

    // =============================
    // GET ALL SUPPLIERS
    // =============================
    public List<Supplier> getAllSuppliers() throws Exception {
        List<Supplier> list = new ArrayList<>();

        String sql = "SELECT SupplierID, SupplierName, Phone, Email, Address, IsActive "
                + "FROM Supplier WHERE IsActive = 1 ORDER BY SupplierName";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierID(rs.getInt("SupplierID"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setPhone(rs.getString("Phone"));
                s.setEmail(rs.getString("Email"));
                s.setAddress(rs.getString("Address"));
                s.setActive(rs.getBoolean("IsActive"));
                list.add(s);
            }
        }
        return list;
    }

    // =============================
    // GET INGREDIENTS BY SUPPLIER
    // =============================
    public List<IngredientSupplier> getIngredientsBySupplier(int supplierID) throws Exception {
        List<IngredientSupplier> list = new ArrayList<>();

        String sql = """
        SELECT 
            isup.id AS is_id,
            isup.supplierID,
            isup.ingredientID,
            isup.price AS supplierPrice,
            isup.lastUpdated,

            s.SupplierID,
            s.SupplierName,
            s.Phone,
            s.Email,
            s.Address,
            s.IsActive,

            i.id AS ing_id,
            i.name,
            i.unit,
            i.quantity,
            i.price
        FROM IngredientSupplier isup
        JOIN Supplier s ON isup.supplierID = s.SupplierID
        JOIN Ingredients i ON isup.ingredientID = i.id
        WHERE isup.supplierID = ?
        ORDER BY i.name ASC
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, supplierID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                IngredientSupplier isup = new IngredientSupplier();
                isup.setId(rs.getInt("is_id"));
                isup.setSupplierID(rs.getInt("supplierID"));
                isup.setIngredientID(rs.getInt("ingredientID"));
                isup.setPrice(rs.getDouble("supplierPrice"));
                isup.setLastUpdated(rs.getDate("lastUpdated"));

                Supplier s = new Supplier();
                s.setSupplierID(rs.getInt("SupplierID"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setPhone(rs.getString("Phone"));
                s.setEmail(rs.getString("Email"));
                s.setAddress(rs.getString("Address"));
                s.setActive(rs.getBoolean("IsActive"));
                isup.setSupplier(s);

                Ingredient ing = new Ingredient();
                ing.setId(rs.getInt("ing_id"));
                ing.setName(rs.getString("name"));
                ing.setUnit(rs.getString("unit"));
                ing.setQuantity(rs.getDouble("quantity"));
                ing.setPrice(rs.getDouble("price"));
                isup.setIngredient(ing);

                list.add(isup);
            }
        }

        return list;
    }

    // =============================
    // GET ORDER BY ID
    // =============================
    public PurchaseOrder getOrderById(int orderID) {
        PurchaseOrder po = null;

        String sql =
                "SELECT PurchaseOrderID, SupplierID, CreatedBy, ReceivedBy, " +
                        "OrderDate, ReceiveDate, Status, Note " +
                        "FROM PurchaseOrder WHERE PurchaseOrderID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                po = new PurchaseOrder();
                po.setPurchaseOrderID(rs.getInt("PurchaseOrderID"));
                po.setSupplierID(rs.getInt("SupplierID"));
                po.setCreatedBy(rs.getInt("CreatedBy"));
                po.setReceivedBy((Integer) rs.getObject("ReceivedBy"));
                po.setOrderDate(rs.getTimestamp("OrderDate"));
                po.setReceiveDate(rs.getTimestamp("ReceiveDate"));
                po.setStatus(rs.getString("Status"));
                po.setNote(rs.getString("Note"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return po;
    }
    
    public void updateStatus(int orderId, String status) {
String sql = "UPDATE PurchaseOrder SET Status = ? WHERE PurchaseOrderID = ?";

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, status);
        ps.setInt(2, orderId);
        ps.executeUpdate();

    } catch (Exception e) {
        e.printStackTrace();
    }
}

}
