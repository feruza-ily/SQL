CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

-- 1.
select distinct customername
from #sales s
where exists (select 1 from #sales where customername = s.customername
and
saledate between '2024-03-01' and '2024-03-31')

-- 2.
select product from #sales
group by product
having sum(quantity*price)=(select max(total) from (select sum(quantity*price) total
from #sales group by product)x)

-- 3.
select max(Price)'2ndhighest'
from #Sales
where Price < (select max(Price) from #Sales)

-- 4.
select distinct year(SaleDate) as yr, month(SaleDate) as mon,
(select sum(Quantity) from #Sales s2 where year(s2.SaleDate)=year(s1.SaleDate) and month(s2.SaleDate)=month(s1.SaleDate)) total_qty
from #Sales s1
order by yr, mon

-- 5.
select distinct s1.CustomerName
from #Sales s1
where exists (
select 1
from #Sales s2
where s2.Product = s1.Product
and s2.CustomerName <> s1.CustomerName
)

-- 6.
create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')

select 
Name,
sum(case when Fruit='Apple' then 1 else 0 end) as Apple,
sum(case when Fruit='Orange' then 1 else 0 end) as Orange,
sum(case when Fruit='Banana' then 1 else 0 end) as Banana
from Fruits
group by Name

-- 7.
create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)

with cte as (
select ParentId as PID, ChildID as CHID from Family
union all
select cte.PID, f.ChildID
from cte
join Family f on cte.CHID = f.ParentID
)
select PID, CHID from cte
order by PID, CHID

-- 8.
CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

select * from #Orders o
where o.DeliveryState='TX'
and exists (
select 1 from #Orders o2
where o2.CustomerID=o.CustomerID
and o2.DeliveryState='CA'
)

-- 9.
create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')

update #residents
set fullname = substring(address, charindex('name=', address)+5,
                        charindex(' ', address + ' ', charindex('name=', address)+5) - (charindex('name=', address)+5))
where fullname not like '%name%'

-- 10.
CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

with paths as (
select cast(DepartureCity + ' - ' + ArrivalCity as varchar(max)) route, Cost, ArrivalCity
from #Routes
where DepartureCity='Tashkent'
union all
select cast(p.route + ' - ' + r.ArrivalCity as varchar(max)), p.Cost + r.Cost, r.ArrivalCity
from paths p
join #Routes r on p.ArrivalCity = r.DepartureCity
)
select * from (
    select top 1 route, Cost from paths where ArrivalCity='Khorezm' order by Cost asc
) t1
union all
select * from (
    select top 1 route, Cost from paths where ArrivalCity='Khorezm' order by Cost desc
) t2

-- 11.
CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

select ID, Vals,
       dense_rank() over(order by ID) rn
from #RankingPuzzle

-- 12.
CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

select EmployeeID, EmployeeName, Department, SalesAmount
from #EmployeeSales e
where SalesAmount > (select avg(SalesAmount) from #EmployeeSales where Department=e.Department)

-- 13 
select EmployeeID, EmployeeName, Department, SalesAmount, SalesMonth, SalesYear
from #EmployeeSales e
where exists (select 1 from #EmployeeSales x where x.SalesMonth=e.SalesMonth and x.SalesYear=e.SalesYear group by x.SalesMonth, x.SalesYear having max(x.SalesAmount)=e.SalesAmount)

-- 14 
CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

select EmployeeID, EmployeeName
from #EmployeeSales e
where not exists (
    select distinct SalesMonth from #EmployeeSales
    where SalesMonth not in (select SalesMonth from #EmployeeSales where EmployeeID=e.EmployeeID)
)

-- 15 
select Name, Price from Products
where Price > (select avg(Price) from Products)

-- 16 
select Name, Stock from Products
where Stock < (select max(Stock) from Products)

-- 17 
select Name, Category from Products
where Category = (select Category from Products where Name='Laptop')

-- 18
select Name, Price from Products
where Price > (select min(Price) from Products where Category='Electronics')

-- 19 
CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');

select Name, Category, Price from Products p
where Price > (select avg(Price) from Products where Category=p.Category)

-- 20 
select distinct p.Name from Products p
join Orders o on p.ProductID=o.ProductID

-- 21 
select p.Name from Products p
join Orders o on p.ProductID=o.ProductID
group by p.Name
having sum(o.Quantity) > (select avg(Quantity) from Orders)

-- 22
select Name from Products
where ProductID not in (select ProductID from Orders)

-- 23 
select top 1 p.Name, sum(o.Quantity) as TotalQuantity from Products p
join Orders o on p.ProductID=o.ProductID
group by p.Name
order by TotalQuantity desc
