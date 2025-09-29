----- PUZZLE 1 -----
CREATE TABLE Dates (
    Id INT,
    Dt DATETIME
);
INSERT INTO Dates VALUES
(1,'2018-04-06 11:06:43.020'),
(2,'2017-12-06 11:06:43.020'),
(3,'2016-01-06 11:06:43.020'),
(4,'2015-11-06 11:06:43.020'),
(5,'2014-10-06 11:06:43.020');


select id, dt,
	case
		when month(dt) < 10 then concat('0', month(dt))
		else cast(month(dt) as varchar(2))
	end MonthPrefixedWithZero
from dates

----- PUZZLE 2 -----
CREATE TABLE MyTabel (
    Id INT,
    rID INT,
    Vals INT
);
INSERT INTO MyTabel VALUES
(121, 9, 1), (121, 9, 8),
(122, 9, 14), (122, 9, 0), (122, 9, 1),
(123, 9, 1), (123, 9, 2), (123, 9, 10);


select count(distinct id) distinct_ids, rid, sum(max_val) TotalOfMaxVals
from (
select id, rid, max(vals) max_val
from mytabel
group by id, rid) t
group by rid

----- PUZZLE 3 -----
CREATE TABLE TestFixLengths (
    Id INT,
    Vals VARCHAR(100)
);
INSERT INTO TestFixLengths VALUES
(1,'11111111'), (2,'123456'), (2,'1234567'), 
(2,'1234567890'), (5,''), (6,NULL), 
(7,'123456789012345');


select * from TestFixLengths
select * from TestFixLengths
where len(vals) >= 6
and
len(vals) <= 10


----- PUZZLE 4 -----
CREATE TABLE TestMaximum (
    ID INT,
    Item VARCHAR(20),
    Vals INT
);
INSERT INTO TestMaximum VALUES
(1, 'a1',15), (1, 'a2',20), (1, 'a3',90),
(2, 'q1',10), (2, 'q2',40), (2, 'q3',60), (2, 'q4',30),
(3, 'q5',20);


select t.ID, t.Item, t.Vals
from TestMaximum t
join (
select id, max(vals) max_val
from TestMaximum m
group by id
) m
on t.ID = m.id and t.vals = m.max_val

----- PUZZLE 5 -----
CREATE TABLE SumOfMax (
    DetailedNumber INT,
    Vals INT,
    Id INT
);
INSERT INTO SumOfMax VALUES
(1,5,101), (1,4,101), (2,6,101), (2,3,101),
(3,3,102), (4,2,102), (4,3,102);


select id, sum(max_val) as sumofmax
from (
    select id, detailednumber, max(vals) as max_val
    from sumofmax
    group by id, detailednumber
) t
group by id

----- PUZZLE 6 -----
CREATE TABLE TheZeroPuzzle (
    Id INT,
    a INT,
    b INT
);
INSERT INTO TheZeroPuzzle VALUES
(1,10,4), (2,10,10), (3,1, 10000000), (4,15,15);


select *,
case
when a - b = 0 then ''
else cast(a-b as varchar)
end 'output'
from TheZeroPuzzle

----- PUZZLE 7 -----
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    Product VARCHAR(50),
    Category VARCHAR(50),
    QuantitySold INT,
    UnitPrice DECIMAL(10,2),
    SaleDate DATE,
    Region VARCHAR(50),
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Sales (Product, Category, QuantitySold, UnitPrice, SaleDate, Region, CustomerID)
VALUES
('Laptop', 'Electronics', 10, 800.00, '2024-01-01', 'North', 1),
('Smartphone', 'Electronics', 15, 500.00, '2024-01-02', 'North', 2),
('Tablet', 'Electronics', 8, 300.00, '2024-01-03', 'East', 3),
('Headphones', 'Electronics', 25, 100.00, '2024-01-04', 'West', 4),
('TV', 'Electronics', 5, 1200.00, '2024-01-05', 'South', 5),
('Refrigerator', 'Appliances', 3, 1500.00, '2024-01-06', 'South', 6),
('Microwave', 'Appliances', 7, 200.00, '2024-01-07', 'East', 7),
('Washing Machine', 'Appliances', 4, 1000.00, '2024-01-08', 'North', 8),
('Oven', 'Appliances', 6, 700.00, '2024-01-09', 'West', 9),
('Smartwatch', 'Electronics', 12, 250.00, '2024-01-10', 'East', 10),
('Vacuum Cleaner', 'Appliances', 5, 400.00, '2024-01-11', 'South', 1),
('Gaming Console', 'Electronics', 9, 450.00, '2024-01-12', 'North', 2),
('Monitor', 'Electronics', 14, 300.00, '2024-01-13', 'West', 3),
('Keyboard', 'Electronics', 20, 50.00, '2024-01-14', 'South', 4),
('Mouse', 'Electronics', 30, 25.00, '2024-01-15', 'East', 5),
('Blender', 'Appliances', 10, 150.00, '2024-01-16', 'North', 6),
('Fan', 'Appliances', 12, 75.00, '2024-01-17', 'South', 7),
('Heater', 'Appliances', 8, 120.00, '2024-01-18', 'East', 8),
('Air Conditioner', 'Appliances', 2, 2000.00, '2024-01-19', 'West', 9),
('Camera', 'Electronics', 7, 900.00, '2024-01-20', 'North', 10);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Region VARCHAR(50),
    JoinDate DATE
);

INSERT INTO Customers (CustomerName, Region, JoinDate)
VALUES
('John Doe', 'North', '2022-03-01'),
('Jane Smith', 'West', '2023-06-15'),
('Emily Davis', 'East', '2021-11-20'),
('Michael Brown', 'South', '2023-01-10'),
('Sarah Wilson', 'North', '2022-07-25'),
('David Martinez', 'East', '2023-04-30'),
('Laura Johnson', 'West', '2022-09-14'),
('Kevin Anderson', 'South', '2021-12-05'),
('Sophia Moore', 'North', '2023-02-17'),
('Daniel Garcia', 'East', '2022-08-22');
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    CostPrice DECIMAL(10,2),
    SellingPrice DECIMAL(10,2)
);
INSERT INTO Products (ProductName, Category, CostPrice, SellingPrice)
VALUES
('Laptop', 'Electronics', 600.00, 800.00),
('Smartphone', 'Electronics', 350.00, 500.00),
('Tablet', 'Electronics', 200.00, 300.00),
('Headphones', 'Electronics', 50.00, 100.00),
('TV', 'Electronics', 900.00, 1200.00),
('Refrigerator', 'Appliances', 1100.00, 1500.00),
('Microwave', 'Appliances', 120.00, 200.00),
('Washing Machine', 'Appliances', 700.00, 1000.00),
('Oven', 'Appliances', 500.00, 700.00),
('Gaming Console', 'Electronics', 320.00, 450.00);

-- 7. 
select sum(unitprice*quantitysold)totrev from sales
-- 8.
select avg(unitprice)avgprice from sales
-- 9.
select count(saleid)salestran from sales
-- 10.
select max(quantitysold)maxunitssold from sales
-- 11.
select category, count(product)numofprodsold from sales
group by category
-- 12.
select region, sum(unitprice*quantitysold)totrev from sales
group by region

-- 13.
select top 1 product, sum(quantitysold*unitprice)totrev
from sales
group by product
order by totrev desc

-- 14.
select saleid, product, category, quantitysold * unitprice as revenue,
sum(quantitysold * unitprice) over (
order by saledate
rows between unbounded preceding and current row
) as runttl
from sales
order by saledate

-- 15.
select category,
sum(unitprice * quantitysold) as category_revenue,
sum(unitprice * quantitysold) * 100.0 /
sum(sum(unitprice * quantitysold)) over () as pct_of_total
from sales
group by category

-- 17.
select c.customername, s.* from sales s
left join customers c
on s.customerid = c.customerid

-- 18.
select * from customers c
left join sales s
on c.CustomerID = s.CustomerID
where s.CustomerID is null

-- 19.
select c.CustomerID, c.CustomerName,
s.quantitysold, s.unitprice, s.quantitysold*s.unitprice rev,
sum(s.quantitysold*s.unitprice) over (order by s.customerid)rnttlrev from sales s
join customers c
on s.CustomerID = c.CustomerID

-- 20.
select top 1 c.CustomerID, c.CustomerName,
s.quantitysold*s.unitprice rev
from sales s
join customers c
on s.CustomerID = c.CustomerID
order by rev desc

-- 21.
select c.customerid, c.customername,
sum(s.quantitysold*s.unitprice)'ttl.sal.pr.cust' from sales s
join customers c
on s.CustomerID = c.CustomerID
group by c.customerid, c.customername

-- 22.
select p.productname from sales s
join products p
on s.Product = p.ProductName

-- 23.
select top 1 productname, sellingprice
from products
order by sellingprice desc

-- 24.
select productname from products p
where sellingprice > (select avg(sellingprice)avg
from products
where category = p.category)
