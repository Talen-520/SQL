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
        String connectionUrl = "jdbc:sqlserver://occam-dbserver.cs.qc.cuny.edu\\dbclass:21433;databaseName=AdventureWorks2017;encrypt=false";
        String user = "student";
        String password = "fall2022";


        try {
            Connection connection = DriverManager.getConnection(connectionUrl, user, password);
            System.out.println("Connected the ms sql");
            //write queries here
            String sql = "SELECT c.CustomerID\r\n"
            		+ "	,o.SalesOrderID\r\n"
            		+ "	,o.OrderDate\r\n"
            		+ "	,p.ProductNumber\r\n"
            		+ "	,od.UnitPrice\r\n"
            		+ "	,od.OrderQty\r\n"
            		+ "	,od.UnitPriceDiscount\r\n"
            		+ "	,TotalCost = (od.UnitPrice * od.OrderQty)\r\n"
            		+ "	,TotalDiscountedCost = (od.UnitPrice * od.OrderQty) * (1 - od.UnitPriceDiscount)\r\n"
            		+ "FROM [AdventureWorks2017].[Sales].[Customer] AS C\r\n"
            		+ "INNER JOIN [Sales].[SalesOrderHeader] AS O ON o.CustomerId = c.CustomerId\r\n"
            		+ "INNER JOIN [SALES].[SalesOrderDetail] AS OD ON od.SalesOrderID = o.SalesOrderID\r\n"
            		+ "INNER JOIN [Production].[Product] AS P ON p.ProductId = od.ProductId\r\n"
            		+ "ORDER BY c.CustomerID\r\n"
            		+ "	,o.OrderDate	";
            Statement statement  = connection.createStatement();
            ResultSet result = statement.executeQuery(sql);
            
            //System.out.printf("Orderid" + "		" +  "Orderdate\n");
            int row = 0;
            while(result.next()) {
            	row++;
            	//String AccountNumber = result.getString("AccountNumber");
            	int CustomerID = result.getInt("CustomerID");
            	//printf("%c\n", ch); //printing character data
            	
            	//System.out.printf("Row %d: %s  %d\n",row ,shipname,orderid);
            	//System.out.print("AccountNumber: "+ AccountNumber);
            	System.out.println(", CustomerID: "+CustomerID);
            	
            }
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}