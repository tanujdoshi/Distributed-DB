package dev.ddb;

import java.util.Scanner;

public class Main {
  public static void main(String[] args) {

    // Create a new instance of DistributedDBConnection
    DistributedDBConnectionFactory ddb = new DistributedDBConnectionFactory("GDC.properties");

    Scanner scanner = new Scanner(System.in);
    System.out.println("Welcome to DDB Query Tool");

    // make this an infinite loop
    while (true) {
      // scan input from user to get the query
      System.out.println("Enter the query: ");
      String query = scanner.nextLine();

      if (query.equalsIgnoreCase("exit")) {
        break;
      }

      if (query.equalsIgnoreCase("run_all_queries_from_ddl_file")) {
        ddb.executeQueryFromFileOnAllConnections("DDL.sql");
        continue;
      }

      if (!query.isEmpty()) {
        ddb.executeQueryOnAllConnections(query);
      }
    }

    // Close all connections
    ddb.closeConnections();
  }
}
