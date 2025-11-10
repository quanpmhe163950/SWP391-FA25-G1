/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
        try (Connection conn = DBConnection.getConnection()) {
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
        try (Connection conn = DBConnection.getConnection()) {
            String checkSql = "SELECT ProgramID, PointsBalance FROM CustomerLoyalty WHERE CustomerID = ?";
            String currentProgramID = null;
            int currentPoints = 0;
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, customerID);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        currentProgramID = rs.getString("ProgramID");
                        currentPoints = rs.getInt("PointsBalance");
                    }
                }
            }

            int newPoints = currentPoints + (int) pointsToAdd;
            String newProgramID = determineProgramID(newPoints);

            if (currentProgramID == null) {
                // Insert new
                String insertSql = "INSERT INTO CustomerLoyalty (CustomerID, ProgramID, PointsBalance) VALUES (?, ?, ?)";
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setString(1, customerID);
                    insertPs.setString(2, newProgramID);
                    insertPs.setInt(3, newPoints);
                    insertPs.executeUpdate();
                }
            } else if (!currentProgramID.equals(newProgramID)) {
                // Delete old and insert new
                String deleteSql = "DELETE FROM CustomerLoyalty WHERE CustomerID = ? AND ProgramID = ?";
                try (PreparedStatement deletePs = conn.prepareStatement(deleteSql)) {
                    deletePs.setString(1, customerID);
                    deletePs.setString(2, currentProgramID);
                    deletePs.executeUpdate();
                }
                String insertSql = "INSERT INTO CustomerLoyalty (CustomerID, ProgramID, PointsBalance) VALUES (?, ?, ?)";
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    insertPs.setString(1, customerID);
                    insertPs.setString(2, newProgramID);
                    insertPs.setInt(3, newPoints);
                    insertPs.executeUpdate();
                }
            } else {
                // Update points in existing
                String updateSql = "UPDATE CustomerLoyalty SET PointsBalance = ? WHERE CustomerID = ? AND ProgramID = ?";
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setInt(1, newPoints);
                    updatePs.setString(2, customerID);
                    updatePs.setString(3, currentProgramID);
                    updatePs.executeUpdate();
                }
            }
        }
    }

    private String determineProgramID(int points) {
        if (points >= 100000) {
            return "LP003";
        } else if (points >= 10000) {
            return "LP002";
        } else if (points >= 1000) {
            return "LP001";
        } else {
            return "LP000";
        }
    }
}
