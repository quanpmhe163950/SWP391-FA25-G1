package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    private static final String USER = "sa";
    private static final String PASS = "123";
    private static final String URL =
            "jdbc:sqlserver://localhost:1433;"
            + "databaseName=PizzaManagement;"
            + "encrypt=false;"
            + "trustServerCertificate=true;";

    // ✅ connection static: để DAO cũ vẫn dùng được
    public static Connection connection = null;

    static {
        try {
            // ✅ Load driver 1 lần khi ứng dụng khởi động
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("✅ SQLServer Driver loaded");

            // ✅ Tạo kết nối ban đầu
            connection = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("✅ Connected to DB (initial)");
        } catch (Exception e) {
            System.out.println("❌ Cannot initialize DB connection");
            e.printStackTrace();
        }
    }

    // ✅ Luôn trả về connection có thể dùng
    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                System.out.println("⚠ Connection null/closed → reconnecting...");

                connection = DriverManager.getConnection(URL, USER, PASS);
                System.out.println("✅ Reconnected to DB");
            }
        } catch (SQLException e) {
            System.out.println("❌ Reconnect failed");
            e.printStackTrace();
        }
        return connection;
    }

    // ✅ Constructor này để DAO cũ gọi new DBContext() vẫn OK
    public DBContext() {
        // Không làm gì, vì static block lo hết
    }
}
