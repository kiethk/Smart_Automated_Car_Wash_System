package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtils {

    private static final String DEFAULT_DB_NAME = "CAR_WASH_DB";
    private static final String DEFAULT_DB_USER = "SA";
    private static final String DEFAULT_DB_PASSWORD = "12345";
    private static final String DEFAULT_DB_HOST = "localhost";
    private static final String DEFAULT_DB_PORT = "1433";

    public static Connection getConnection()
            throws ClassNotFoundException, SQLException {

        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        String dbHost = getEnvOrDefault("DB_HOST", DEFAULT_DB_HOST);
        String dbPort = getEnvOrDefault("DB_PORT", DEFAULT_DB_PORT);
        String dbName = getEnvOrDefault("DB_NAME", DEFAULT_DB_NAME);
        String dbUser = getEnvOrDefault("DB_USER", DEFAULT_DB_USER);
        String dbPassword = getEnvOrDefault("DB_PASSWORD", DEFAULT_DB_PASSWORD);

        String url = "jdbc:sqlserver://" + dbHost + ";"
                + "databaseName=" + dbName + ";"
                + "encrypt=true;"
                + "trustServerCertificate=true;";

        return DriverManager.getConnection(
                url,
                dbUser,
                dbPassword
        );
    }

    private static String getEnvOrDefault(String name, String defaultValue) {
        String value = System.getenv(name);

        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }

        return value;
    }
}
