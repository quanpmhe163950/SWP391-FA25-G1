package dal;

import java.sql.*;
import java.util.*;
import model.PurchaseOrderItem;

public class PurchaseOrderItemDAO extends DBContext {

    // Lấy tất cả item theo PO và return Map<Integer, PurchaseOrderItem>
    public Map<Integer, PurchaseOrderItem> getItemsMapByOrder(int purchaseOrderId) {
        Map<Integer, PurchaseOrderItem> map = new HashMap<>();

        String sql = """
            SELECT 
                PurchaseOrderItemID,
                PurchaseOrderID,
                IngredientID,
                UnitQuantity,
                UnitType,
                SubQuantityPerUnit,
                SubUnit,
                WeightPerSubUnit,
                PricePerUnit,
                QuantityReceivedUnits,
                QuantityReceivedSubUnits,
                TotalPrice
            FROM PurchaseOrderItem
            WHERE PurchaseOrderID = ?
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, purchaseOrderId);

            try (ResultSet rs = ps.executeQuery()) {
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

                    map.put(item.getPurchaseOrderItemID(), item);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }

    // Cập nhật số lượng nhận theo SubUnit -> Unit = SubUnit * SubQuantityPerUnit
    public void updateReceivedSubUnits(int itemId, double receivedSubUnits, double subQuantityPerUnit) {

        String sql = """
            UPDATE PurchaseOrderItem
            SET 
                QuantityReceivedSubUnits = ?,
                QuantityReceivedUnits = (? * ?)
            WHERE PurchaseOrderItemID = ?
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, receivedSubUnits);
            ps.setDouble(2, receivedSubUnits);
            ps.setDouble(3, subQuantityPerUnit);
            ps.setInt(4, itemId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
