USE AdventureWorks2019


--(1) Damilare has just received a mail from the sales manager to retrieve all 
--customer whohave placed order fro product with subcegory name of 'bike'

SELECT * FROM Production.ProductCategory
SELECT * FROM Sales.SalesOrderHeader
SELECT* FROM Sales.Customer
SELECT*
FROM Sales.Customer
WHERE CustomerID IN (SELECT CustomerID FROM Sales.SalesOrderHeader
					WHERE SalesOrderID IN (SELECT SalesOrderID FROM Sales.SalesOrderDetail
					WHERE ProductID IN (SELECT ProductID FROM Production.Product 
					WHERE ProductSubcategoryID IN (SELECT ProductSubcategoryID FROM Production.ProductCategory
					WHERE Name = 'BIKES'))))

--(2) The purchase department has required Damilare to identify all suppliers who have 
--supplied product with a unit price greater than the average unit price and also 
--suplier with standard price grater than the average standard price of all product

--for unit price
SELECT* FROM Purchasing.Vendor
SELECT* FROM Purchasing.ProductVendor
SELECT* FROM Purchasing.Vendor
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM Purchasing.ProductVendor
							WHERE ProductID IN (SELECT ProductID FROM Production.Product
							WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product)))

SELECT DISTINCT V.*
FROM Purchasing.Vendor V
JOIN Purchasing.ProductVendor PV
ON V.BusinessEntityID = PV.BusinessEntityID
JOIN Production.Product PP
ON PV.ProductID = PP.ProductID
WHERE PP.ListPrice > (SELECT AVG(ListPrice) 
					FROM Production.Product)
--for standard price
SELECT* FROM Purchasing.Vendor
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM Purchasing.ProductVendor
							WHERE StandardPrice > (SELECT AVG(StandardPrice) FROM Purchasing.ProductVendor))

SELECT DISTINCT V.*
FROM Purchasing.Vendor V
JOIN Purchasing.ProductVendor PV
ON V.BusinessEntityID = PV.BusinessEntityID
WHERE PV.StandardPrice > (SELECT AVG(StandardPrice) 
					FROM Purchasing.ProductVendor)

--(3) The accoucting deartment has reached out to Damilare to find all employees who have a salary
--greater than d salary of the employee with the highest salary in the Sales department

SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.EmployeePayHistory
SELECT * FROM HumanResources.EmployeeDepartmentHistory
SELECT * FROM HumanResources.Department
SELECT* FROM Person.Person

--Max for sales dept
SELECT MAX(EPH.Rate)
FROM HumanResources.EmployeePayHistory EPH
JOIN HumanResources.Employee E
ON EPH.BusinessEntityID = E.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory EDH
ON EPH.BusinessEntityID = EDH.BusinessEntityID
JOIN HumanResources.Department D
ON EDH.DepartmentID =D.DepartmentID
WHERE D.Name = 'SALES'

SELECT EPH.Rate, EPH.BusinessEntityID, D.Name
FROM HumanResources.EmployeePayHistory EPH
JOIN HumanResources.EmployeeDepartmentHistory EDH 	
ON EPH.BusinessEntityID = EDH.BusinessEntityID
JOIN HumanResources.Department D 
ON EDH.DepartmentID =D.DepartmentID
								WHERE Rate > (SELECT MAX(EPH.Rate)
								FROM HumanResources.EmployeePayHistory EPH
								JOIN HumanResources.Employee E
								ON EPH.BusinessEntityID = E.BusinessEntityID
								JOIN HumanResources.EmployeeDepartmentHistory EDH
								ON EPH.BusinessEntityID = EDH.BusinessEntityID
								JOIN HumanResources.Department D
								ON EDH.DepartmentID =D.DepartmentID
								WHERE D.Name = 'SALES')

--(4)The manager has reached out to Damilare to find all the customer 
--who have placed order with a total value grater than the average total value of all order

SELECT * FROM Sales.Customer
SELECT * FROM Sales.SalesOrderHeader

SELECT AVG(TotalDue)
FROM Sales.SalesOrderHeader



SELECT * FROM Sales.Customer
WHERE CustomerID IN (select CustomerID
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(TOTALDUE) > (SELECT AVG(TotalDue)
						FROM Sales.SalesOrderHeader))

--(5)HI! Damilare, you have been asked to retrieve all products where list price
--is greater than the list price of the product with thw highest list price
--in the clothing category

SELECT* FROM Production.Product
SELECT * FROM Production.ProductCategory
SELECT * FROM Production.ProductSubcategory

--max for clothing
SELECT MAX(pp.listPrice)
FROM Production.Product pp
JOIN Production.ProductSubcategory psc
ON PP.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory PC
ON PSC.ProductCategoryID =PC.ProductCategoryID
WHERE PC.Name = 'CLOTHING'


SELECT PP.ProductID, PP.NAME, PC.PRODUCTCATEGORYID, PC.NAME
FROM Production.Product pp
JOIN Production.ProductSubcategory psc
ON PP.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory PC
ON PSC.ProductCategoryID =PC.ProductCategoryID
WHERE PP.ListPrice > (SELECT MAX(pp.listPrice)
						FROM Production.Product pp
						JOIN Production.ProductSubcategory psc
						ON PP.ProductSubcategoryID = PSC.ProductSubcategoryID
						JOIN Production.ProductCategory PC
						ON PSC.ProductCategoryID =PC.ProductCategoryID
						WHERE PC.Name = 'CLOTHING')


--(6) As a customer relationship manager, you want to identify customers who have placed a large 
--number of orders and tend to order in higher quantities from the Sales.SalesOrderHeader 
--table. Specifically, you are interested in finding customers who have placed more than 400 
--orders with an average order quantity greater than 4 items. How would you write a SQL query 
--to retrieve these customers' first names, last names, their average order quantity, and the 
--total number of orders they have placed?

--CALLING OUT THE TABLE
SELECT* FROM Sales.SalesOrderHeader
SELECT* FROM Sales.SalesOrderDetail
SELECT* FROM Sales.Customer
SELECT* FROM Person.Person

SELECT pp.FirstName, pp.LastName, AVG(sod.OrderQty) AS AverageOrderQty, COUNT(sod.OrderQty) AS Total_Orders
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Sales.Customer sc
ON soh.CustomerID = sc.CustomerID
INNER JOIN Person.Person pp
ON sc.PersonID = pp.BusinessEntityID
GROUP BY pp.FirstName, pp.LastName
HAVING AVG(sod.OrderQty) > 4 AND COUNT(sod.OrderQty) > 400
ORDER BY Total_Orders DESC;

--(7) As a human resources manager, you need to identify departments with a significant number 
--of staff members. Specifically, you want to find out which departments have more than 5 
--employees and list them in descending order based on the number of employees. How would 
--you write a SQL query to retrieve the department names and the total number of staff 
--members in each department? 

--CALLING OUT THE TABLE
SELECT* FROM HumanResources.Employee
SELECT* FROM HumanResources.EmployeeDepartmentHistory
SELECT* FROM HumanResources.Department

SELECT hd.Name, COUNT(he.BusinessEntityID)AS TotalEmployees
FROM HumanResources.Employee he
INNER JOIN HumanResources.EmployeeDepartmentHistory hed
ON he.BusinessEntityID = hed.BusinessEntityID
INNER JOIN HumanResources.Department hd
ON hed.DepartmentID = hd.DepartmentID
GROUP BY hd.Name
HAVING COUNT(he.BusinessEntityID) >5
ORDER BY TotalEmployees DESC;

--(8) As a customer relationship manager, you want to identify customers who have placed a large 
--number of orders and tend to order in higher quantities from the Sales.SalesOrderHeader 
--table. Specifically, you are interested in finding customers who have placed more than 400 
--orders with an average order quantity greater than 4 items. How would you write a SQL query 
--to retrieve these customers' first names, last names, their average order quantity, and the 
--total number of orders they have placed? 

--CALLING OUT THE TABLE
SELECT* FROM Sales.SalesOrderHeader
SELECT* FROM Sales.SalesOrderDetail
SELECT* FROM Sales.Customer
SELECT* FROM Person.Person

SELECT pp.FirstName, pp.LastName, AVG(sod.OrderQty) AS AverageOrderQty, COUNT(sod.OrderQty) AS Total_Orders
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Sales.Customer sc
ON soh.CustomerID = sc.CustomerID
INNER JOIN Person.Person pp
ON sc.PersonID = pp.BusinessEntityID
GROUP BY pp.FirstName, pp.LastName
HAVING AVG(sod.OrderQty) > 4 AND COUNT(sod.OrderQty) > 400
ORDER BY Total_Orders DESC;

--(9) As a sales analyst, you want to get an overview of your customer base, including how many 
--orders each customer has placed from Sales.Customer table. Specifically, you need to retrieve 
--a list of all customers along with the total number of orders they have made and rank them in 
--descending order of their total orders. How would you write a SQL query to get each 
--customer’s first name, last name, and total number of orders, even if some customers have 
--not placed any orders? 

--CALLING OUT THE TABLE
SELECT* FROM Sales.Customer
SELECT* FROM Person.Person
SELECT* FROM Sales.SalesOrderHeader

SELECT pp.FirstName, pp.LastName, COUNT(soh.SalesOrderID) AS Total_Orders
FROM Sales.Customer sc
LEFT JOIN Sales.SalesOrderHeader soh
ON soh.CustomerID = sc.CustomerID
LEFT JOIN Person.Person pp
ON sc.PersonID = pp.BusinessEntityID
GROUP BY pp.FirstName, pp.LastName
ORDER BY Total_Orders DESC;


--(10) you are working as a sales manager and want to analyze the sales performance of different 
--products across various sales territories for the year 2011 from Sales.SalesOrderDetail table.
--specifically, you need to determine the total sales amount for each product within each 
--territory and rank them in descending order of sales. How would you write a SQL query to 
--retrieve the product names, territory names, and total sales amounts for orders placed 
--between January 1, 2011, and December 31, 2011? 


--CALLING OUT TABLE
SELECT* FROM Sales.SalesOrderDetail
SELECT* FROM Production.Product
SELECT* FROM Sales.SalesOrderHeader
SELECT* FROM Sales.SalesTerritory

SELECT pp.Name, sst.Name, SUM(sod.LineTotal) AS TotalSalesAmount   
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product pp
ON sod.ProductID = pp.ProductID
INNER JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Sales.SalesTerritory sst
ON soh.TerritoryID = sst.TerritoryID
WHERE soh.OrderDate LIKE '%2011%'
GROUP BY pp.Name,sst.Name
ORDER BY TotalSalesAmount DESC;

--OR

SELECT pp.Name, sst.Name, SUM(sod.LineTotal) AS TotalSalesAmount   
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product pp
ON sod.ProductID = pp.ProductID
INNER JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Sales.SalesTerritory sst
ON soh.TerritoryID = sst.TerritoryID
WHERE  year(soh.OrderDate) = '2011'
GROUP BY pp.Name,sst.Name
ORDER BY TotalSalesAmount DESC;


--(11)retrive the total quantity of each product slod, along with product name 
--and category, for products that have been sold more than 100 times
SELECT* FROM SALES.SalesOrderDetail
SELECT* FROM PRODUCTION.Product
SELECT* FROM PRODUCTION.ProductCategory
SELECT* FROM PRODUCTION.ProductSubcategory

select p.NAME, PC.NAME, SUM(SOD.ORDERQTY) TOTAL_Q
FROM SALES.SalesOrderDetail SOD
INNER JOIN Production.Product P
ON SOD.ProductID = P.ProductID
INNER JOIN Production.ProductSubcategory PSC
ON P.ProductSubcategoryID = PSC. ProductSubcategoryID
INNER JOIN PRODUCTION.ProductCategory PC
ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY P.Name, PC.Name
HAVING SUM(SOD.ORDERQTY) > 100
ORDER BY TOTAL_Q DESC


--(12) Hi! Damilare, the company will like to know those who are collecting the 
--most salary, hence you have been asked to provide those who have a higher salary
--than their department average salary

SELECT * FROM HumanResources.EmployeePayHistory 
SELECT * FROM HumanResources.EmployeeDepartmentHistory 
SELECT * FROM HumanResources.Department

WITH DEPT_AVG AS (
SELECT EDH.DepartmentID, AVG(EPH.RATE) AS AVERAGE
FROM HumanResources.EmployeePayHistory EPH  
JOIN HumanResources.EmployeeDepartmentHistory EDH
ON EPH.BusinessEntityID = EDH.BusinessEntityID
GROUP BY EDH.DepartmentID
)

SELECT EDH.*
FROM HumanResources.EmployeeDepartmentHistory EDH
JOIN HumanResources.EmployeePayHistory EPH
ON EDH.BusinessEntityID = EPH.BusinessEntityID
JOIN DEPT_AVG DA
ON EDH.DepartmentID =DA.DepartmentID
WHERE EPH.Rate > DA.AVERAGE



--(13) Damilare has baan asked to help retrieve PRODUCT listPrice than the
--average listprice of product in the same category

SELECT * FROM Production.Product
SELECT * FROM Production.ProductCategory
SELECT * FROM Production.ProductSubcategory


	WITH PRODCAT_AVG AS (
    SELECT PC.ProductCategoryID, AVG(PP.ListPrice) AS AVERAGE
    FROM Production.Product PP
    JOIN Production.ProductSubcategory PSC
        ON PP.ProductSubcategoryID = PSC.ProductSubcategoryID
    JOIN Production.ProductCategory PC
        ON PSC.ProductCategoryID = PC.ProductCategoryID
    GROUP BY PC.ProductCategoryID
)

SELECT PP.*
FROM Production.Product PP
JOIN Production.ProductSubcategory PSC
    ON PP.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory PC
    ON PSC.ProductCategoryID = PC.ProductCategoryID
JOIN PRODCAT_AVG PCA
    ON PC.ProductCategoryID = PCA.ProductCategoryID
WHERE PP.ListPrice > PCA.AVERAGE;


--OR

WITH PRODCAT_AVG AS(
SELECT PC.ProductCategoryID, AVG(PP.ListPrice) AS AVERAGE
FROM Production.Product PP
JOIN Production.ProductSubcategory PSC
ON PP.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory PC
ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY PC.ProductCategoryID
)

SELECT PP.*
FROM Production.Product PP
JOIN Production.ProductSubcategory PSC
ON PP.ProductSubcategoryID =PSC.ProductSubcategoryID
JOIN PRODCAT_AVG PCA
ON PSC.ProductCategoryID =PCA.ProductCategoryID
WHERE PP.ProductID IN (SELECT PP.ProductID FROM Production.Product PP
						JOIN Production.ProductSubcategory PSC
						ON PP.ProductSubcategoryID = PSC.ProductSubcategoryID
						JOIN PRODCAT_AVG PCA
						ON PCA.ProductCategoryID =PSC.ProductCategoryID
						WHERE PP.ListPrice > PCA.AVERAGE)

--Both queries should theoretically give the same result, as they aim to achieve the same goal. However, Query 1 is generally preferred for its simplicity and efficiency:
--Query 1 directly applies the filtering condition, making it straightforward and likely less error-prone.
--Query 2 involves an additional subquery which might lead to inefficiencies or discrepancies depending on how the database engine handles the intermediate results.
--Therefore, Query 1 is typically the correct choice for directly addressing the requirement.



--(14) Hi Damilare! the sales department will need your help to determine customer
--who are placing high order per country. Hence help determine the customer 
--who have higher orders than the averaage number of orders placed by customers 
--within the same country
SELECT * FROM SALES.SalesTerritory
SELECT * FROM SALES.Customer
SELECT * FROM SALES.SalesOrderHeader
SELECT * FROM SALES.SalesOrderDetail


WITH COUNTRY_AVG AS (
SELECT ST.CountryRegionCode, AVG(SOD.OrderQty) AS AVERAGE
FROM Sales.SalesTerritory ST
JOIN Sales.SalesOrderHeader SOH
ON ST.TerritoryID = SOH.TerritoryID
JOIN Sales.SalesOrderDetail SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY ST.CountryRegionCode
)

SELECT SOD.*, SOH.CustomerID, ST.CountryRegionCode
FROM Sales.SalesOrderDetail SOD
JOIN Sales.SalesOrderHeader SOH
    ON SOD.SalesOrderID = SOH.SalesOrderID
JOIN Sales.SalesTerritory ST
    ON SOH.TerritoryID = ST.TerritoryID
JOIN COUNTRY_AVG CA
    ON ST.CountryRegionCode = CA.CountryRegionCode
WHERE SOD.OrderQty > CA.AVERAGE;



--(15) Hi Damilare! Please generate product that have higher average 
--selling price than the overall average selling price of all products

SELECT * FROM SALES.SalesOrderDetail

WITH AVG_SELLING_PER_PRODUCT AS (
    SELECT ProductID, AVG(UnitPrice) AS AVERAGE
    FROM Sales.SalesOrderDetail
    GROUP BY ProductID
)

SELECT *
FROM AVG_SELLING_PER_PRODUCT ASP
WHERE ASP.AVERAGE > (
    SELECT AVG(UnitPrice)
    FROM Sales.SalesOrderDetail
);

--(16) You have been required to provide the List of orders placed by employees who have sold more than 1 million worth of product

SELECT * FROM Sales.SalesOrderHeader


SELECT SalesOrderID, SalesPersonID,CustomerID
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IN (SELECT SalesPersonID FROM Sales.SalesOrderHeader SOH
						JOIN Sales.SalesOrderDetail SOD
						ON SOH.SalesOrderID = SOD.SalesOrderID
						GROUP BY SalesPersonID
						HAVING SUM(SOD.LINETOTAL) > 100000
						)

--(17).You have been asked to List the top 5 product names and their corresponding categories where 
--the product is still being sold.
SELECT * FROM Production.Product
SELECT * FROM Production.ProductSubcategory
SELECT * FROM Production.ProductCategory


SELECT TOP 5 P.Name AS ProductName, PC.Name AS CategoryName
FROM Production.Product P
JOIN Production.ProductSubcategory PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory PC ON PSC.ProductCategoryID = PC.ProductCategoryID
WHERE P.DiscontinuedDate IS NULL
ORDER BY P.Name;


--(18). Its the end of the year, and the management plans to give out incentive only to the top three customers,
--Damilare is requierd to Retrieve the top 3 customers by their total purchase amounts
SELECT * FROM Sales.Customer
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Person.Person


SELECT TOP 3 C.FirstName + ' ' + C.LastName AS CustomerName, SUM(SOH.TotalDue) AS TotalPurchases
FROM Sales.Customer CU
JOIN Person.Person C ON CU.PersonID = C.BusinessEntityID
JOIN Sales.SalesOrderHeader SOH ON CU.CustomerID = SOH.CustomerID
GROUP BY C.FirstName, C.LastName
ORDER BY SUM(SOH.TotalDue) DESC;

--OR

SELECT TOP 3 concat(C.FirstName , C.LastName) AS CustomerName, SUM(SOH.TotalDue) AS TotalPurchases
FROM Sales.Customer CU
JOIN Person.Person C ON CU.PersonID = C.BusinessEntityID
JOIN Sales.SalesOrderHeader SOH ON CU.CustomerID = SOH.CustomerID
GROUP BY C.FirstName, C.LastName
ORDER BY SUM(SOH.TotalDue) DESC;


--(19). I just received a call from sales manager to Get the names of salespeople 
--who have made at least 10 sales and the total sales amount they have made.
SELECT * FROM Sales.SalesPerson SP
SELECT * FROM Person.Person P 
SELECT * FROM Sales.SalesOrderHeader 


SELECT concat(P.FirstName , P.LastName) AS SalesPersonName, COUNT(SOH.SalesOrderID) AS TotalOrders, SUM(SOH.TotalDue) AS TotalSales
FROM Sales.SalesPerson SP
JOIN Person.Person P ON SP.BusinessEntityID = P.BusinessEntityID
JOIN Sales.SalesOrderHeader SOH ON SP.BusinessEntityID = SOH.SalesPersonID
GROUP BY P.FirstName, P.LastName
HAVING COUNT(SOH.SalesOrderID) >= 10
ORDER BY SUM(SOH.TotalDue) DESC;

--OR

SELECT P.FirstName + ' ' + P.LastName AS SalesPersonName, COUNT(SOH.SalesOrderID) AS TotalOrders, SUM(SOH.TotalDue) AS TotalSales
FROM Sales.SalesPerson SP
JOIN Person.Person P ON SP.BusinessEntityID = P.BusinessEntityID
JOIN Sales.SalesOrderHeader SOH ON SP.BusinessEntityID = SOH.SalesPersonID
GROUP BY P.FirstName, P.LastName
HAVING COUNT(SOH.SalesOrderID) >= 10
ORDER BY SUM(SOH.TotalDue) DESC;


--(20). The management is planning on promotionof some employees, Damilare is asked to provide 
--List employees who have been in their department for more than 5 years, along with the department name.
 SELECT * FROM HumanResources.Employee
 SELECT * FROM Person.Person
SELECT * FROM HumanResources.EmployeeDepartmentHistory
 SELECT * FROM HumanResources.Department


SELECT P.FirstName + ' ' + P.LastName AS EmployeeName, D.Name AS DepartmentName, DATEDIFF(YEAR, EDH.StartDate, GETDATE()) AS YearsInDepartment
FROM HumanResources.Employee E
JOIN Person.Person P ON E.BusinessEntityID = P.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory EDH ON E.BusinessEntityID = EDH.BusinessEntityID
JOIN HumanResources.Department D ON EDH.DepartmentID = D.DepartmentID
WHERE EDH.EndDate IS NULL AND DATEDIFF(YEAR, EDH.StartDate, GETDATE()) > 5;