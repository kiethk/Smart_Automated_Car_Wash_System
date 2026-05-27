package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtils {
 
    private final String serverName = "localhost";
    private final String dbName = "CAR_WASH_DB";
    private final String portNumber = "1433";
    private final String userID = "sa";
    private final String password = "12345";

    public Connection getConnection() throws Exception {
        String url = "jdbc:sqlserver://" + serverName + ":" + portNumber + ";databaseName=" + dbName + ";encrypt=false";
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, userID, password);
    }

    // Hàm test nhanh kết nối
    public static void main(String[] args) {
        try {
            DBUtils db = new DBUtils();
            if (db.getConnection() != null) {
                System.out.println("Connected to CAR_WASH_DB!");
            }
        } catch (Exception e) {
            System.out.println("Failed connect: " + e.getMessage());
        }
    }
}