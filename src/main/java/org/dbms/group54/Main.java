package org.dbms.group54;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Scanner;
import java.util.logging.Logger;

public class Main {
    private static final Logger log; // Logger for the application

    static {
        System.setProperty("java.util.logging.SimpleFormatter.format", "[%4$-7s] %5$s %n"); // Set log format
        log = Logger.getLogger(Main.class.getName()); // Initialize the logger
    }

    public static void main(String[] args) throws Exception {
        log.info("Starting the application"); // Log application start
        log.info("Loading application properties"); // Log loading properties

        Properties properties = new Properties(); // Load database properties
        properties.load(Main.class.getClassLoader().getResourceAsStream("application.properties")); // Load properties file

        log.info("Connecting to the database"); // Log database connection attempt
        Connection connection = DriverManager.getConnection(properties.getProperty("url"), properties); // Establish connection
        log.info("Database connection test: " + connection.getCatalog()); // Test the connection

        Scanner keyboard = new Scanner(System.in); // Initialize scanner for user input
        int query = 0; // Initialize query input variable

        while (query != 4) { // Loop until user selects option 4
            System.out.println("Choose an option (1: Insert faculty, 2: Insert with Department Exclusion, 3: View, 4: Exit): "); // Prompt user
            query = keyboard.nextInt(); // Get user input

            switch (query) { // Handle different query options
                case 1:
                    executeInsertProcedure(connection, keyboard); // Execute insert procedure (Option 1)
                    break;
                case 2:
                    executeInsertWithDepartmentProcedure(connection, keyboard); // Execute insert with dept exclusion (Option 2)
                    break;
                case 3:
                    executeViewProcedure(connection); // Execute view procedure (Option 3)
                    break;
                case 4:
                    System.out.println("Terminating program."); // Exit program
                    break;
                default:
                    System.out.println("Invalid option. Please select a valid option (1-4)."); // Handle invalid input
            }
        }

        connection.close(); // Close database connection
    }

    private static void executeInsertProcedure(Connection connection, Scanner keyboard) throws SQLException {
        System.out.println("Enter faculty id: "); // Prompt for faculty id
        int facultyId = keyboard.nextInt(); // Get faculty id

        System.out.println("Enter faculty name: "); // Prompt for faculty name
        String facultyName = keyboard.next(); // Get faculty name

        System.out.println("Enter faculty department: "); // Prompt for faculty department
        String facultyDepartment = keyboard.next(); // Get faculty department

        String sql = "{call InsertFacultyByDept(?, ?, ?)}"; // Prepare the SQL call for the procedure
        CallableStatement stmt = connection.prepareCall(sql); // Create CallableStatement

        stmt.setInt(1, facultyId); // Set faculty id parameter
        stmt.setString(2, facultyName); // Set faculty name parameter
        stmt.setString(3, facultyDepartment); // Set faculty department parameter

        stmt.execute(); // Execute the stored procedure
        System.out.println("Faculty inserted successfully."); // Confirm success
        stmt.close(); // Close the statement
    }

    private static void executeInsertWithDepartmentProcedure(Connection connection, Scanner keyboard) throws SQLException {
        System.out.println("Enter faculty id: "); // Prompt for faculty id
        int facultyId = keyboard.nextInt(); // Get faculty id

        System.out.println("Enter faculty name: "); // Prompt for faculty name
        String facultyName = keyboard.next(); // Get faculty name

        System.out.println("Enter department id: "); // Prompt for department id
        int departmentId = keyboard.nextInt(); // Get department id

        System.out.println("Enter department id to exclude: "); // Prompt for department id to exclude
        int departmentIdToExclude = keyboard.nextInt(); // Get department id to exclude

        String sql = "{call InsertFacultyWhereNotDept(?, ?, ?, ?)}"; // Prepare the SQL call for the procedure
        CallableStatement stmt = connection.prepareCall(sql); // Create CallableStatement

        stmt.setInt(1, facultyId); // Set faculty id parameter
        stmt.setString(2, facultyName); // Set faculty name parameter
        stmt.setInt(3, departmentId); // Set department id parameter
        stmt.setInt(4, departmentIdToExclude); // Set department exclusion parameter

        stmt.execute(); // Execute the stored procedure
        System.out.println("Faculty inserted successfully."); // Confirm success
        stmt.close(); // Close the statement
    }

    private static void executeViewProcedure(Connection connection) throws SQLException {
        String sql = "{call SelectAllFaculty()}"; // Prepare the SQL call for the procedure
        CallableStatement stmt = connection.prepareCall(sql); // Create CallableStatement

        ResultSet rs = stmt.executeQuery(); // Execute the stored procedure and retrieve the result set

        while (rs.next()) { // Iterate through the result set
            System.out.println("fid: " + rs.getInt("fid") + ", fname: " + rs.getString("fname") + ", deptid: " + rs.getInt("deptid") + ", salary: " + rs.getInt("salary")); // Print each row
        }

        rs.close(); // Close the result set
        stmt.close(); // Close the statement
    }
}