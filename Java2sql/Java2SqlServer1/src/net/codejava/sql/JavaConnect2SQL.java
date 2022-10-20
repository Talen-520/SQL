package net.codejava.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JavaConnect2SQL {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//String connectionUrl = "jdbc:sqlserver://occam-dbserver.cs.qc.cuny.edu\\dbclass,21433;databaseName=TSQLV4;user=student;password=fall2022";
		//String user = "student";
		//String password = "Fall2022";
		//String connectionUrl = "jdbc:sqlserver://192.168.4.21,13001;databaseName=TSQLV4;user=sa;password=PH@123456789";
        String connectionUrl = "jdbc:sqlserver://occam-dbserver.cs.qc.cuny.edu\\dbclass:21433;databaseName=TSQLV4;encrypt=false";
        String user = "student";
        String password = "fall2022";


        try {
            Connection connection = DriverManager.getConnection(connectionUrl, user, password);
            System.out.println("Connected the ms sql");

            String sql = "SELECT TOP (10) * FROM [AdventureWorks2017].[Sales].[SalesOrderHeaderSalesReason]";
            Statement statement  = connection.createStatement();
            ResultSet result = statement.executeQuery(sql);
            
            
            int count = 0;
            while(result.next()) {
            	count++;
            	String name = result.getString("name");
            	int mark = result.getInt("mark");
            	System.out.printf("hello");
            	connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}