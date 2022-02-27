--*************************************************************************--
-- Title: Assignment07
-- Author: Ashley Arreola
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 2017-01-01,RRoot,Created File
-- 2022-02-27,AArreola,Executed Code to Create Database, Tables and Constraints
-- 2022-02-27,AArreola,Executed Code to Add Data in Tables
-- 2022-02-27,AArreola,Executed Code to Create Views
-- 2022-02-27,AArreola,Added Code and Steps to Each Question
-- 2022-02-27,AArreola,Ran All Codes
-- 2022-02-27,AArreola,Completed File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment07DB_AArreola')
	 Begin 
	  Alter Database [Assignment07DB_AArreola] set Single_user With Rollback Immediate;
	  Drop Database Assignment07DB_AArreola;
	 End
	Create Database Assignment07DB_AArreola;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment07DB_AArreola;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL
,[ProductID] [int] NOT NULL
,[ReorderLevel] int NOT NULL -- New Column 
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count], [ReorderLevel]) -- New column added this week
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock, ReorderLevel
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10, ReorderLevel -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, abs(UnitsInStock - 10), ReorderLevel -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go


-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count] From dbo.Inventories;
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From vCategories;
go
Select * From vProducts;
go
Select * From vEmployees;
go
Select * From vInventories;
go

/********************************* Questions and Answers *********************************/
Print
'NOTES------------------------------------------------------------------------------------ 
 1) You must use the BASIC views for each table.
 2) Remember that Inventory Counts are Randomly Generated. So, your counts may not match mine
 3) To make sure the Dates are sorted correctly, you can use Functions in the Order By clause!
------------------------------------------------------------------------------------------'
-- Question 1 (5% of pts):
-- Show a list of Product names and the price of each product.
-- Use a function to format the price as US dollars.
-- Order the result by the product name.

-- Steps:
-- Selected data from vProducts
-- Pulled columns ProductName and UnitPrice
-- Used Format function on UnitPrice
-- Ordered by ProductName
-- Highlighted and executed query

Select 
  ProductName
  ,Format(UnitPrice, 'C', 'en-US') as 'UnitPrice'
From
  vProducts
Order By ProductName;
go

-- Question 2 (10% of pts): 
-- Show a list of Category and Product names, and the price of each product.
-- Use a function to format the price as US dollars.
-- Order the result by the Category and Product.

-- Steps:
-- Copied and pasted query from Question 1 to Question 2
-- Added CategoryName to the select clause
-- Created a left join on vProducts (switched the order to follow select statement of column orders) on CategoryID
-- Added CategoryName in the Order By clause
-- Highlighted and executed query

Select 
  CategoryName
  ,ProductName
  ,Format(UnitPrice, 'C', 'en-US') as 'UnitPrice'
From
  vCategories Left Join vProducts
    on vCategories.CategoryID = vProducts.CategoryID
Order By CategoryName
		   ,ProductName;
go

-- Question 3 (10% of pts): 
-- Use functions to show a list of Product names, each Inventory Date, and the Inventory Count.
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- Steps:
-- Copied and pasted query from Question 2 to Question 3
-- Removed CategoryName and added [Count] to the select clause
-- Updated left join to join on vProducts and vInventories on ProductID
-- Removed CategoryName and added InventoryDate in the Order By clause
-- Highlighted and executed query

Select 
  ProductName
  ,Format(InventoryDate, 'MMMM, yyyy') as InventoryDate
  ,[Count]
From
  vProducts Left Join vInventories
    on vProducts.ProductID = vInventories.ProductID
Order By ProductName
		   ,InventoryDate;
go

-- Question 4 (10% of pts): 
-- CREATE A VIEW called vProductInventories. 
-- Shows a list of Product names, each Inventory Date, and the Inventory Count. 
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- Steps:
-- Used Create View statement and named it vProductInventories
-- In order to order results, after Select, added Top 10000
-- Selected data from vProducts and vInventories and created left join on ProductID
-- Added columns ProductName, copied Format function of InventoryDate from Question 3
-- Ordered by Product Name and month function for InventoryDate
-- Highlighted and executed query
-- Added Select * From vProductInventories under the check instructions
-- Highlighted and executed query

Create View vProductInventories
 As
   Select Top 10000
    ProductName
    ,Format(InventoryDate, 'MMMM, yyyy') as InventoryDate
	,[Count]
   From vProducts Left Join vInventories
          on vProducts.ProductID = vInventories.ProductID
   Order By ProductName
              ,Month(InventoryDate);
go

-- Check that it works: Select * From vProductInventories;
Select * From vProductInventories;
go

-- Question 5 (10% of pts): 
-- CREATE A VIEW called vCategoryInventories. 
-- Shows a list of Category names, Inventory Dates, and a TOTAL Inventory Count BY CATEGORY
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- Steps:
-- Used Create View statement and named it vCategoryInventories
-- Selected data from vCategories, vProducts and vInventories and created left joins on CategoryID and ProductID
-- Added columns CategoryName, copied Format function of InventoryDate from Question 4, 
-- added Sum function to [Count] and gave alias InventoryCountbyCategory
-- Used Group by clause and used InventoryDate and CategoryDate
-- Highlighted and executed query
-- Added Select * From vCategoryInventories under the check instructions
-- Highlighted and executed query

Create View vCategoryInventories
 As
   Select 
    CategoryName 
    ,Format(InventoryDate, 'MMMM, yyyy') as InventoryDate
	,Sum([count]) as InventoryCountByCategory
   From vCategories Left Join vProducts
          on vCategories.CategoryID = vProducts.CategoryID
	 Left Join vInventories
		  on vProducts.ProductID = vInventories.ProductID
   Group By InventoryDate, CategoryName;
go

-- Check that it works: Select * From vCategoryInventories;
Select * From vCategoryInventories;
go


-- Question 6 (10% of pts): 
-- CREATE ANOTHER VIEW called vProductInventoriesWithPreviouMonthCounts. 
-- Show a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month Count.
-- Use functions to set any January NULL counts to zero. 
-- Order the results by the Product and Date. 
-- This new view must use your vProductInventories view.

-- Steps:
-- Used Create View statement and named it vProductInventoriesWithPreviouMonthCounts
-- Selected data from vProducts and vInventories and created left join on ProductID
-- Added columns ProductName, copied Format function of InventoryDate from Question 5, 
-- added Sum function to [Count] and gave alias InventoryCount
-- added new column name PreviousMonthCount and added Immediate IF function and Lag function
-- to order by ProductName and month function for InventoryDate
-- Used Group by clause and used ProductName and InventoryDate
-- Highlighted and executed query
-- Added Select * From vProductInventoriesWithPreviousMonthCounts under the check instructions
-- Highlighted and executed query

Create View vProductInventoriesWithPreviouMonthCounts
 As
   Select 
    ProductName 
    ,Format(InventoryDate, 'MMMM, yyyy') as InventoryDate
	,[InventoryCount] = sum([count])
	,[PreviousMonthCount] = 
			IIF(Month(InventoryDate) = 1, 0, lag(sum([count])) over(Order By ProductName, month(InventoryDate)))
   From vProducts Left Join vInventories
          on vProducts.ProductID = vInventories.ProductID
   Group By ProductName, InventoryDate;

go

-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCounts;
Select * From vProductInventoriesWithPreviouMonthCounts
go

-- Question 7 (15% of pts): 
-- CREATE a VIEW called vProductInventoriesWithPreviousMonthCountsWithKPIs.
-- Show columns for the Product names, Inventory Dates, Inventory Count, Previous Month Count. 
-- The Previous Month Count is a KPI. The result can show only KPIs with a value of either 1, 0, or -1. 
-- Display months with increased counts as 1, same counts as 0, and decreased counts as -1. 
-- Varify that the results are ordered by the Product and Date.

-- Steps:
-- Used Create View statement and named it vProductInventoriesWithPreviousMonthCountsWithKPIs
-- Selected data from vProductInventoriesWithPreviouMonthCounts
-- Added columns ProductName, InventoryDate, InventoryCount, PreviousMonthCount, and
-- new column name CountVsPerviousCountKPI and added a Case statement to list 3 KPIs
-- Highlighted and executed query
-- Added Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs under the check instructions
-- Highlighted and executed query

Create View vProductInventoriesWithPreviousMonthCountsWithKPIs
 As
   Select 
    ProductName 
    ,InventoryDate
	,InventoryCount
	,PreviousMonthCount 
	,[CountVsPreviousCountKPI] = Case
		When InventoryCount > PreviousMonthCount Then 1
		When InventoryCount = PreviousMonthCount Then 0
		When InventoryCount < PreviousMonthCount Then -1
		End
   From vProductInventoriesWithPreviouMonthCounts
  go


-- Important: This new view must use your vProductInventoriesWithPreviousMonthCounts view!
-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
go

-- Question 8 (25% of pts): 
-- CREATE a User Defined Function (UDF) called fProductInventoriesWithPreviousMonthCountsWithKPIs.
-- Show columns for the Product names, Inventory Dates, Inventory Count, the Previous Month Count. 
-- The Previous Month Count is a KPI. The result can show only KPIs with a value of either 1, 0, or -1. 
-- Display months with increased counts as 1, same counts as 0, and decreased counts as -1. 
-- The function must use the ProductInventoriesWithPreviousMonthCountsWithKPIs view.
-- Varify that the results are ordered by the Product and Date.

-- Steps:
-- Used UDF statement and named it fProductInventoriesWithPreviousMonthCountsWithKPIs
-- Selected data from dbo.vProductInventoriesWithPreviousMonthCountsWithKPIs
-- Added @CountVsPreviousCountKPI Int as the parameter and datatype
-- Under the Select statement copied column names from Question 7 to Question 8
-- Added Where caluse to equal the parameter to CountVsPreviousCountKPI 
-- Highlighted and executed query
-- Copied the Select * From statements in the check instructions and pasted underneath section
-- Highlighted and executed query


Create Function fProductInventoriesWithPreviousMonthCountsWithKPIs
(
	@CountVsPreviousCountKPI Int
)
Returns Table
As
Return
	Select
	 ProductName
	 ,InventoryDate
	 ,InventoryCount
	 ,PreviousMonthCount
	 ,CountVsPreviousCountKPI
	From dbo.vProductInventoriesWithPreviousMonthCountsWithKPIs
	Where CountVsPreviousCountKPI = @CountVsPreviousCountKPI
go

/* Check that it works:
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
*/

Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
go

/***************************************************************************************/