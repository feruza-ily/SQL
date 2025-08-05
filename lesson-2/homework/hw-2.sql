create database lesson2
use lesson2

CREATE TABLE Employees (
  EmpID INT,
  Name VARCHAR(50),
  Salary DECIMAL(10,2)
)

INSERT INTO Employees VALUES (1, 'Ali', 5000.00)
INSERT INTO Employees (EmpID, Name, Salary) VALUES (2, 'Layla', 4500.50)
INSERT INTO Employees VALUES 
(3, 'Jasur', 6000.75)

UPDATE Employees
SET Salary = 7000
WHERE EmpID = 1

DELETE FROM Employees
WHERE EmpID = 2

-- "delete" is used to delete specific rows from a table. the table structure and rows other than the one selected stays. this can be undone.
-- "truncate" is used to delete data from the table. specific rows cannot be selected and the structure of table stays but the data is gone. this cannot be undone.
-- "drop" is used to delete the overall table. neither data nor table structure stays. this cannot be undone.

ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100)

ALTER TABLE Employees
ADD Department VARCHAR(50)

ALTER TABLE Employees
ALTER COLUMN Salary FLOAT

IF OBJECT_ID('Departments', 'U') IS NOT NULL DROP TABLE Departments
CREATE TABLE Departments (
  DepartmentID INT PRIMARY KEY,
  DepartmentName VARCHAR(50)
)

TRUNCATE TABLE Employees


INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT * FROM (VALUES
  (1, 'HR'),
  (2, 'IT'),
  (3, 'Finance'),
  (4, 'Marketing'),
  (5, 'Support')
) AS temp(DepartmentID, DepartmentName)

UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000

TRUNCATE TABLE Employees

ALTER TABLE Employees
DROP COLUMN Department

IF OBJECT_ID('StaffMembers', 'U') IS NOT NULL DROP TABLE StaffMembers
EXEC sp_rename 'Employees', 'StaffMembers'

DROP TABLE Departments


IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products
CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Category VARCHAR(50),
  Price DECIMAL(10,2),
  Description VARCHAR(100)
)

ALTER TABLE Products
ADD CONSTRAINT chk_price_homework CHECK (Price > 0)

ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50

EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN'

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Description)
VALUES 
(1, 'Laptop', 'Electronics', 1000.00, 'Basic laptop'),
(2, 'Phone', 'Electronics', 800.00, 'Smartphone'),
(3, 'Chair', 'Furniture', 120.00, 'Office chair'),
(4, 'Table', 'Furniture', 200.00, 'Wooden table'),
(5, 'Pen', 'Stationery', 1.50, 'Ballpoint pen')

IF OBJECT_ID('Products_Backup', 'U') IS NOT NULL DROP TABLE Products_Backup
SELECT * INTO Products_Backup
FROM Products

IF OBJECT_ID('Inventory', 'U') IS NOT NULL DROP TABLE Inventory
EXEC sp_rename 'Products', 'Inventory'

ALTER TABLE Inventory
ALTER COLUMN Price FLOAT

CREATE TABLE NewInventory (
  ProductCode INT IDENTITY(1000,5),
  ProductID INT,
  ProductName VARCHAR(50),
  ProductCategory VARCHAR(50),
  Price FLOAT,
  Description VARCHAR(100),
  StockQuantity INT
)

INSERT INTO NewInventory (ProductID, ProductName, ProductCategory, Price, Description, StockQuantity)
SELECT ProductID, ProductName, ProductCategory, Price, Description, StockQuantity
FROM Inventory

DROP TABLE Inventory
EXEC sp_rename 'NewInventory', 'Inventory'

SELECT * FROM StaffMembers
SELECT * FROM Products_Backup
SELECT * FROM Inventory
