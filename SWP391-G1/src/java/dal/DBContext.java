package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {
    private static final String USER = "sa";
    private static final String PASS = "123";
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=PizzaManagement;encrypt=false;trustServerCertificate=true";

    protected Connection connection; // ⚡ dùng cho DAO

    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("✅ Connected to: " + connection.getCatalog());
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                connection = DriverManager.getConnection(URL, USER, PASS);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return connection;
    }
}
