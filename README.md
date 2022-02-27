Ashley Arreola  
February 27, 2022  
IT FDN 130 A  
Assignment 07  
*https://github.com/arreolaa12/DBFoundations-Module07*  

# Functions
## Introduction
This week, I learned additional information around SQL Functions – common built-in MS SQL functions, User-Defined Functions (UDF) and Table-Valued Functions. In this assignment, I will explain when to use a SQL UDF and the differences between Scalar, Inline, and Multi-Statement Functions.
## SQL UDF
UDFs are custom functions that returns a single value or table of values that uses parameters to change results of queries. UDFs are used when wanting to return results from different parameters. You can use a UDF to return data for a specified quantity and can use that same UDF to update the quantity instead of creating a new view or stored procedure. For example, if I want to see which product that has an inventory quantity of 50 I can use a UDF that uses a SUM() function of the quantity field. I can use that same UDF to increase the quantity from 50 to 100. This way I can analyze different products and their quantity and ultimately update the UDF to include KPIs.
## Scalar, Inline and Multi-Statement Functions
Most common UDFs are Scalar, Inline and Multi-Statement functions. A Scalar function returns a single value, while Inline and Multi-Statement functions returns multiple values in a table. Inline and Multi-Statement functions are referred to as Table-Valued Functions (TVFs). Inline functions results from using a single select statement, while multi-statement functions use a series of select statements for the results.
## Summary
In summary, UDFs are preferred when returning sets of data when parameters are involved. It provides a simpler way than creating additional views and stored procedures. 
