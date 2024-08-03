package dev.ddb;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class SQLQueryReader {
  public static List<String> readQueriesFromFile(String filePath) {
    System.out.println("Reading queries from file: " + filePath);
    List<String> queries = new ArrayList<>();
    StringBuilder queryBuilder = new StringBuilder();
    try (InputStream inputStream =
        SQLQueryReader.class.getClassLoader().getResourceAsStream(filePath)) {
      if (inputStream != null) {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {
          String line;
          while ((line = reader.readLine()) != null) {
            if (!line.trim().isEmpty()) {
              if (line.trim().startsWith("--")) {
                // Skip comments
                continue;
              }
              queryBuilder.append(line).append(" ");
            } else if (queryBuilder.length() > 0) {
              // Empty line encountered, add query to the list
              queries.add(queryBuilder.toString().trim());
              queryBuilder.setLength(0); // Reset the query builder
            }
          }
          // Add the last query if it's not added yet
          if (queryBuilder.length() > 0) {
            queries.add(queryBuilder.toString().trim());
          }
        }
      } else {
        System.err.println("Failed to open file: " + filePath);
      }
    } catch (IOException e) {
      e.printStackTrace();
    }
    return queries;
  }
}
