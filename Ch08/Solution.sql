/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [custid]
      ,[companyname]
      ,[country]
      ,[region]
      ,[city]
  FROM [TSQLV4].[dbo].[Customers]
  --1.1
  INSERT INTO dbo.Customers
  (custid,companyname,country,region,city)
  VALUES
  (100,'Coho Winery','USA','WA','Redmond');
  --1.2

   INSERT INTO dbo.Customers
  (custid,companyname,country,region,city)
SELECT C.custid,companyname,country,region,city
FROM SALES.Customers AS C
WHERE EXISTS
(SELECT o.custid FROM SALES.Orders AS O
WHERE o.custid = c.custid);
--1.3
DROP TABLE IF EXISTS dbo.Orders
SELECT*
INTO dbo.Orders
FROM sales.Orders as O
WHERE o.orderdate >='20140101' AND O.orderdate <'20170101';

--2
DELETE FROM dbo.Orders
OUTPUT
deleted.orderid,
deleted.orderdate

WHERE orderdate < '20140801';


-- 3
--- Delete from the dbo.Orders table orders placed by customers from Brazil
--solution1:
DELETE FROM dbo.Orders
WHERE EXISTS
  (SELECT *
   FROM dbo.Customers AS C
   WHERE dbo.Orders.custid = C.custid
     AND C.country = N'Brazil');
--solution2:
DELETE FROM O
FROM dbo.Orders AS O
  INNER JOIN dbo.Customers AS C
    ON O.custid = C.custid
WHERE country = N'Brazil';
--solution3:
MERGE INTO dbo.Orders AS O
USING (SELECT * FROM dbo.Customers WHERE country = N'Brazil') AS C
  ON O.custid = C.custid
WHEN MATCHED THEN DELETE;


-- 4
-- Run the following query against dbo.Customers,
-- and notice that some rows have a NULL in the region column
SELECT * FROM dbo.Customers;
-- Update the dbo.Customers table and change all NULL region values to '<None>'
-- Use the OUTPUT clause to show the custid, old region and new region

-- Desired output:

UPDATE  dbo.Customers
SET Region = '<None>'
OUTPUT
  deleted.custid,
  deleted.region AS oldregion,
  inserted.region AS newregion
where region IS NULL

-- 5
-- Update in the dbo.Orders table all orders placed by UK customers
-- and set their shipcountry, shipregion, shipcity values
-- to the country, region, city values of the corresponding customers from dbo.Customers
--SOLUTION 1
UPDATE  O
SET O.shipcountry = C.country, 
O.shipregion=C.region, 
O.shipcity = C.city
FROM dbo.Orders AS O
INNER JOIN dbo.Customers AS C 
ON  O.custid = C.custid
WHERE C.country = N'UK'
--SOLUTION 2
WITH CTE_UPD AS
(
  SELECT
    O.shipcountry AS ocountry, C.country AS ccountry,
    O.shipregion  AS oregion,  C.region  AS cregion,
    O.shipcity    AS ocity,    C.city    AS ccity
  FROM dbo.Orders AS O
    INNER JOIN dbo.Customers AS C
      ON O.custid = C.custid
  WHERE C.country = N'UK'
)
UPDATE CTE_UPD
  SET ocountry = ccountry, oregion = cregion, ocity = ccity;
--SOLUTION 3
MERGE INTO dbo.Orders AS O
USING (SELECT * FROM dbo.Customers WHERE country = N'UK') AS C
  ON O.custid = C.custid
WHEN MATCHED THEN
  UPDATE SET shipcountry = C.country,
             shipregion = C.region,
             shipcity = C.city;
---- 6
-- Run the following code to create the tables Orders and OrderDetails and populate them with data
USE TSQLV4;

DROP TABLE IF EXISTS dbo.OrderDetails, dbo.Orders;

CREATE TABLE dbo.Orders
(
  orderid        INT          NOT NULL,
  custid         INT          NULL,
  empid          INT          NOT NULL,
  orderdate      DATE         NOT NULL,
  requireddate   DATE         NOT NULL,
  shippeddate    DATE         NULL,
  shipperid      INT          NOT NULL,
  freight        MONEY        NOT NULL
    CONSTRAINT DFT_Orders_freight DEFAULT(0),
  shipname       NVARCHAR(40) NOT NULL,
  shipaddress    NVARCHAR(60) NOT NULL,
  shipcity       NVARCHAR(15) NOT NULL,
  shipregion     NVARCHAR(15) NULL,
  shippostalcode NVARCHAR(10) NULL,
  shipcountry    NVARCHAR(15) NOT NULL,
  CONSTRAINT PK_Orders PRIMARY KEY(orderid)
);

CREATE TABLE dbo.OrderDetails
(
  orderid   INT           NOT NULL,
  productid INT           NOT NULL,
  unitprice MONEY         NOT NULL
    CONSTRAINT DFT_OrderDetails_unitprice DEFAULT(0),
  qty       SMALLINT      NOT NULL
    CONSTRAINT DFT_OrderDetails_qty DEFAULT(1),
  discount  NUMERIC(4, 3) NOT NULL
    CONSTRAINT DFT_OrderDetails_discount DEFAULT(0),
  CONSTRAINT PK_OrderDetails PRIMARY KEY(orderid, productid),
  CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY(orderid)
    REFERENCES dbo.Orders(orderid),
  CONSTRAINT CHK_discount  CHECK (discount BETWEEN 0 AND 1),
  CONSTRAINT CHK_qty  CHECK (qty > 0),
  CONSTRAINT CHK_unitprice CHECK (unitprice >= 0)
);
GO

INSERT INTO dbo.Orders SELECT * FROM Sales.Orders;
INSERT INTO dbo.OrderDetails SELECT * FROM Sales.OrderDetails;

-- Write and test the T-SQL code that is required to truncate both tables,
-- and make sure that your code runs successfully

ALTER TABLE dbo.OrderDetails DROP CONSTRAINT FK_OrderDetails_Orders;
--dbo.OrderDetails contains  referenced by a FOREIGN KEY constraint
--Drop the constraints
--Trunc the table
--Recreate the constraints.
--clear table with drop table if exists
TRUNCATE TABLE dbo.OrderDetails;
TRUNCATE TABLE dbo.Orders;

ALTER TABLE dbo.OrderDetails ADD CONSTRAINT FK_OrderDetails_Orders
  FOREIGN KEY(orderid) REFERENCES dbo.Orders(orderid);

DROP TABLE IF EXISTS dbo.OrderDetails, dbo.Orders, dbo.Customers;