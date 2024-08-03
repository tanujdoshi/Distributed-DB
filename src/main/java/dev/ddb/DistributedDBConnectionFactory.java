package dev.ddb;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class DistributedDBConnectionFactory {
  private final Map<String, Connection> connections = new HashMap<>();

  public DistributedDBConnectionFactory(String configFile) {
    loadConnections(configFile);
  }

  /**
   * Load connections from config file (GDC)
   *
   * @param configFile
   */
  private void loadConnections(String configFile) {
    Properties properties = new Properties();
    try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream(configFile)) {
      if (inputStream != null) {
        properties.load(inputStream);

        for (String key : properties.stringPropertyNames()) {
          String[] parts = key.split("\\."); // Split using dot as delimiter
          if (parts.length == 2 && parts[0].startsWith("db")) {
            String dbName = parts[0];

            if (!connections.containsKey(dbName)) {
              String url = properties.getProperty(dbName + ".url");
              String username = properties.getProperty(dbName + ".username");
              String password = properties.getProperty(dbName + ".password");

              Connection conn = getConnection(url, username, password);
              connections.put(dbName, conn);
              System.out.println("Connected to " + dbName);
            }
          }
        }
      } else {
        System.out.println("Failed to load connections from config file: " + configFile);
      }
    } catch (IOException | SQLException e) {
      System.out.println("Failed to load connections from config file: " + configFile);
      e.printStackTrace();
    }
  }

  /**
   * Get connection by url, username and password
   *
   * @param url
   * @param username
   * @param password
   * @return
   * @throws SQLException
   */
  private Connection getConnection(String url, String username, String password)
      throws SQLException {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
    return DriverManager.getConnection(url, username, password);
  }

  /**
   * Get connection by database name
   *
   * @param dbName
   * @return
   */
  public Connection getConnection(String dbName) {
    return connections.get(dbName);
  }

  /** Close all connections */
  public void closeConnections() {
    connections
        .values()
        .forEach(
            conn -> {
              try {
                conn.close();
              } catch (SQLException e) {
                e.printStackTrace();
              }
            });
  }

  /**
   * Execute query on all connections
   *
   * @param query
   */
  public void executeQueryOnAllConnections(String query) {
    for (Map.Entry<String, Connection> entry : connections.entrySet()) {
      try (Statement statement = entry.getValue().createStatement()) {
        statement.executeUpdate(query);
        System.out.println("Table created in database: " + entry.getKey());
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  }

  /**
   * Execute query from file on all connections
   *
   * @param filePath
   */
  public void executeQueryFromFileOnAllConnections(String filePath) {
    List<String> queries = SQLQueryReader.readQueriesFromFile(filePath);
    for (String query : queries) {
      executeQueryOnAllConnections(query);
    }
  }
}
