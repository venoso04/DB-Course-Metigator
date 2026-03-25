

-- Sess 7 

-- Create a rep shows vategory name , desc , sorted by cat name

SELECT CategoryName , [Description] FROM Categories ORDER BY CategoryName


-- Q2 rep show contactName  companyName contact title phone mum from customers tbl sort by title desc
SELECT ContactName,  CompanyName , ContactTitle , Phone FROM Customers ORDER BY ContactTitle DESC

-- Q3 rep : show -> cspped first & last name , hire date , sort from newest emp
SELECT UPPER(FirstName) AS N'FirstName', UPPER(LastName) AS N'LastName' , HireDate FROM Employees ORDER BY HireDate DESC


-- Q4 rep show top 10 OrderID, OrderDate , ShippedDate , CustomerID, Freight from orders tbl , ORDER BY Freight DESC
SELECT top 10 OrderID, OrderDate , ShippedDate , CustomerID, Freight from Orders ORDER BY Freight DESC

-- Q6 rep show CompanyName , Fax , Phone , Country , HomePage  FROM Suppliers , ORDER BY Country desc , ORDER BY CompanyName ASC
SELECT CompanyName , Fax , Phone , Country , HomePage  FROM Suppliers  ORDER BY Country desc , CompanyName ASC

-- Q9 rep show ContactName, Address , City from all custs not in 'Germany' , 'Mexico' , 'Spain'
SELECT C.ContactName,   C.Address , C.City FROM Customers AS C 
WHERE Country NOT IN ( 'Germany' , 'Mexico' , 'Spain')

-- Q11 rep show FirstName ,  LastName , Country FROM  all Employees not in USA
SELECT FirstName ,  LastName , Country FROM Employees 
WHERE Country <>  'USA' 
-- Q12
SELECT EmployeeID ,OrderID , CustomerID, ShippedDate , RequiredDate FROM Orders
WHERE ShippedDate > RequiredDate

-- Q 13 city start w A or B
SELECT City , CompanyName , ContactName  FROM Customers
WHERE City like 'A%'  OR City like 'B%' 

-- Q 14 all even nums of OrderID from Orders tbl
SELECT OrderID FROM Orders 
WHERE OrderID % 2 = 0

 -- Q 22 get all emps born in 1950s 
 SELECT FirstName , LastName , BirthDate FROM Employees
 WHERE BirthDate BETWEEN '1950-01-01' AND '1959-12-31'

-- Q23 show birth year 
SELECT FirstName , LastName , YEAR(BirthDate) FROM Employees


-- Q 24  get number of items ordered for each order 
SELECT OrderID, COUNT(*)  AS NumOfItems FROM [Order Details] 
GROUP BY OrderID 
ORDER BY NumOfItems DESC

-- Q 25 rep show S.SupplierID, P.ProductName , S.CompanyName from only from supps :'Exotic Liquids' , 'Specialty Biscuits, Ltd.' , 'Escargots Nouveaux'
SELECT S.SupplierID, P.ProductName , S.CompanyName 
FROM Products AS P INNER JOIN Suppliers AS S
ON P.SupplierID = S.SupplierID
WHERE  S.CompanyName  IN ('Exotic Liquids' , 'Specialty Biscuits, Ltd.' , 'Escargots Nouveaux'  )
ORDER BY S.SupplierID

-- Q27 No sales in title
SELECT ContactTitle FROM Customers
WHERE ContactTitle NOT like '%Sales%'

-- Q29 custs from any city in mexico or spain except for madrid
SELECT Country ,City FROM Customers
WHERE Country = 'Mexico' OR (Country = 'Spain' AND City != 'Madrid')

--Q30 return employees with their extensions inn this format ([Emp First Name] [Emp Last Name] can be reached at [Extension])
SELECT [FirstName] + ' ' + [LastName] + ' can be reached at ' + [Extension] AS T FROM Employees
GO

SELECT CONCAT([FirstName] , ' ' , [LastName] , ' can be reached at ' , [Extension]) AS T FROM Employees
GO

-- 32 rep show avg unit price as avgPrice roubded to next whole, tot of UnitsInStock AS TotalStock, max UnitsOnOrder) AS PendingOrders  

SELECT 
	ROUND(AVG(UnitPrice),0) AS AveragePrice , 
	COUNT(UnitsInStock) AS TotalStock, 
	MAX(UnitsOnOrder) AS PendingOrders  
FROM Products

-- Q33 rep show, SupplierID , CompanyName , CategoryName , ProductName, UnitPrice
SELECT 
	P.SupplierID , 
	S.CompanyName , 
	C.CategoryName , 
	P.ProductName,
	P.UnitPrice
FROM Products P
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
INNER JOIN Categories C ON P.CategoryID = C.CategoryID

-- Q34 rep show sum of Freight for each custID if < 200 
SELECT 
	O.CustomerID, 
	SUM(O.Freight) AS SumFreight
FROM  Orders O
GROUP BY O.CustomerID
HAVING O.Freight > 200


-- Q35 rep show OrderID, ContactName, UnitPrice, Quantity w dicount given on every purchase
SELECT
    O.OrderID, 
    C.ContactName, 
    OD.UnitPrice, 
    OD.Quantity ,
    OD.Discount
FROM Orders O 
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE OD.Discount <> 0
GO

-- 36 rep show EmpID , LastName FirstName AS Emloyee , and thier manager: LastName FirstName AS reports to Sorted by emp id
SELECT
A.EmployeeID,
CONCAT(A.LastName,' ', A.FirstName) AS Employee,
CONCAT(B.LastName,' ', B.FirstName) AS ReportsTo
FROM Employees A
INNER JOIN Employees B ON A.ReportsTo = B.EmployeeID
ORDER BY A.EmployeeID
GO

-- 37 rep show ProductId, 
SELECT 
ProductID,
ProductName,
CASE Discontinued 
    WHEN 1 THEN 'Active'
    WHEN 0 THEN 'Inactive'
ENd AS N'Status'
FROM Products
GO

-- Q38 view named CustomerInfo w 
CREATE VIEW dbo.CustomerInfo AS
SELECT
    C.CustomerID,
    C.CompanyName,
    C.ContactTitle,
    C.Address,
    C.Country,
    C.Phone,
    O.OrderDate,
    O.RequiredDate,
    O.ShippedDate
FROM Customers C 
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
GO

SELECT * FROM dbo.CustomerInfo
GO

-- 39 Change View bame to CustomerDetails
sp_rename @objname = 'dbo.CustomerInfo' , @newname = 'CustomerDetails'
-- OR
EXEC sp_rename 'dbo.CustomerInfo', 'CustomerDetails'

-- 41 drop CustomerDetails view
DROP VIEW dbo.CustomerDetails;

-- 42 rep show 1st 5 chars of CategoryName AS ticker FROM Categories

SELECT LEFT(  CategoryName ,5 ) AS ticker
FROM Categories

-- Q43 create copy of shippers tbl call it shippersDupe and copy the shippers data there
SELECT * INTO Shippers_Duplicate FROM Shippers;

-- Q 44 add col email varchar(50) to Shippers_Duplicate, 
ALTER TABLE Shippers_Duplicate
ADD  email varchar(150)

SELECT * FROM Shippers_Duplicate 

UPDATE Shippers_Duplicate SET email = 'speedyCat@miaw.net' WHERE ShipperId =1 ;
UPDATE Shippers_Duplicate SET email = 'speedyCat2@miaw.net' WHERE ShipperId =2 ;
UPDATE Shippers_Duplicate SET email = 'speedyCat3@miaw.net' WHERE ShipperId =3 ;

-- Q46  rep show most exp and least exp product show name and unit price
SELECT 
    ProductName,
    UnitPrice
FROM Products
WHERE UnitPrice = (SELECT MAX(UnitPrice )FROM Products) OR UnitPrice = (SELECT MIN(UnitPrice) FROM Products)
GROUP BY ProductName, UnitPrice

-- 48 get age of emps
SELECT 
LastName, FirstName, Title, 
CONVERT(int,ROUND(DATEDIFF(HOUR, BirthDate , GETDATE()) / 8766.0 , 0 )) AS AGE
FROM Employees

-- 49 rep show comp name and tot num of orders of each cust as num or orders since dec 31 1994 only orders above 10
SELECT  
C.CompanyName,  
COUNT(O.OrderID) AS N'Number Of Orders'
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderDate >= '1994-12-31'
GROUP BY C.CompanyName
HAVING COUNT(O.OrderID) > 10

-- 50 output 
SELECT 
CONCAT(ProductName ,' / is ' , QuantityPerUnit , ' and cost $ ' , UnitPrice ) AS prodInfo
FROM Products