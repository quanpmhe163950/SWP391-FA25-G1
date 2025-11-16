package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author dotha
 */
public class LoyaltyDAO {

    public void updatePoints(String customerID, String programID, int pointsToAdd) throws Exception {
        try (Connection conn = DBContext.getConnection()) {
            String checkSql = "SELECT PointsBalance FROM CustomerLoyalty WHERE CustomerID = ? AND ProgramID = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, customerID);
                checkPs.setString(2, programID);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        int currentPoints = rs.getInt("PointsBalance");
                        String updateSql = "UPDATE CustomerLoyalty SET PointsBalance = ? WHERE CustomerID = ? AND ProgramID = ?";
                        try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                            updatePs.setInt(1, currentPoints + pointsToAdd);
                            updatePs.setString(2, customerID);
                            updatePs.setString(3, programID);
                            updatePs.executeUpdate();
                        }
                    } else {
                        String insertSql = "INSERT INTO CustomerLoyalty (CustomerID, ProgramID, PointsBalance) VALUES (?, ?, ?)";
                        try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                            insertPs.setString(1, customerID);
                            insertPs.setString(2, programID);
                            insertPs.setInt(3, pointsToAdd);
                            insertPs.executeUpdate();
                        }
                    }
                }
            }
        }
    }

    public void updatePointsAndProgram(String customerID, double pointsToAdd) throws Exception {
        try (Connection conn = DBContext.getConnection()) {

            // 1. Lấy dòng Loyalty của customer (nếu có)
            String checkSql = "SELECT ProgramID, PointsBalance FROM CustomerLoyalty WHERE CustomerID = ?";
            Integer currentProgramID = null;
            int currentPoints = 0;
            boolean exists = false;

            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setString(1, customerID);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        exists = true;

                        int pid = rs.getInt("ProgramID");
                        if (rs.wasNull()) {
                            currentProgramID = null;
                        } else {
currentProgramID = pid;
                        }

                        currentPoints = rs.getInt("PointsBalance");
                    }
                }
            }

            // 2. Tính điểm mới + Tier mới
            int newPoints = currentPoints + (int) pointsToAdd;
            int newProgramID = determineProgramID(newPoints);

            // 3. Nếu chưa có dòng → INSERT mới
            if (!exists) {
                String insertSql = "INSERT INTO CustomerLoyalty (CustomerID, ProgramID, PointsBalance) VALUES (?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setString(1, customerID);
                    ps.setInt(2, newProgramID);
                    ps.setInt(3, newPoints);
                    ps.executeUpdate();
                }
                return;
            }

            // 4. Nếu Tier thay đổi → UPDATE ProgramID + Points
            if (currentProgramID == null || !currentProgramID.equals(newProgramID)) {
                String updateSql = "UPDATE CustomerLoyalty SET ProgramID = ?, PointsBalance = ? WHERE CustomerID = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setInt(1, newProgramID);
                    ps.setInt(2, newPoints);
                    ps.setString(3, customerID);
                    ps.executeUpdate();
                }
                return;
            }

            // 5. Nếu Tier không đổi → chỉ Update điểm
            String updateSql = "UPDATE CustomerLoyalty SET PointsBalance = ? WHERE CustomerID = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, newPoints);
                ps.setString(2, customerID);
                ps.executeUpdate();
            }
        }
    }

    private int determineProgramID(int points) {
        if (points >= 100000) {
            return 1;
        } else if (points >= 10000) {
            return 2;
        } else if (points >= 1000) {
            return 3;
        } else {
            return 4;
        }
    }
}
