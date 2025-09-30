-- 1.
DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

select r.region,d.distributor,coalesce(rs.sales,0)sales
from (select distinct region from #RegionSales)r
cross join (select distinct distributor from #RegionSales)d
left join #RegionSales rs
on r.region=rs.region and d.distributor=rs.distributor

-- 2.
CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

select e.name
from employee e
join employee sub on e.id=sub.managerid
group by e.id,e.name
having count(sub.id)>=5

-- 3.
CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

select p.product_name,sum(o.unit)unit
from products p
join orders o on p.product_id=o.product_id
where o.order_date between '2020-02-01' and '2020-02-29'
group by p.product_name
having sum(o.unit)>=100

-- 4.
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

with c as (
select customerid,vendor,count(*)cnt,
row_number()over(partition by customerid order by count(*)desc)rn
from orders
group by customerid,vendor
)
select customerid,vendor from c where rn=1

-- 5.

declare @n int=91,@i int=2,@isprime bit=1
while @i<=sqrt(@n)
begin
if @n%@i=0 set @isprime=0
set @i=@i+1
end
if @isprime=1 print'This number is prime'
else print'This number is not prime'

-- 6.
CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

select device_id,
count(distinct locations)no_of_location,
(select top 1 locations from device d2 where d2.device_id=d1.device_id
group by locations order by count(*)desc)max_signal_location,
count(*)no_of_signals
from device d1
group by device_id

-- 7.
drop table if exists employee
CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

select e.empid,e.empname,e.salary
from employee e
where e.salary>(select avg(salary) from employee where deptid=e.deptid)

-- 8.
-- Step 1: Create the table
CREATE TABLE Numbers (
    Number INT
);

-- Step 2: Insert values into the table
INSERT INTO Numbers (Number)
VALUES
(25),
(45),
(78);


-- Step 1: Create the Tickets table
CREATE TABLE Tickets (
    TicketID VARCHAR(10),
    Number INT
);

-- Step 2: Insert the data into the table
INSERT INTO Tickets (TicketID, Number)
VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);


with c as(
select ticketid,count(*)cnt
from tickets t
join numbers n on t.number=n.number
group by ticketid
),
d as(
select count(*) total from numbers
)
select sum(case
when c.cnt=d.total then 100
when c.cnt>0 then 10
else 0 end) total_winnings
from c,d

-- 9.
CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

with c as(
select spend_date,user_id,
sum(case when platform='Mobile' then amount else 0 end)m,
sum(case when platform='Desktop' then amount else 0 end)d
from spending
group by spend_date,user_id
)
select spend_date,'Mobile'platform,sum(m)total_amount,count(*)total_users
from c where m>0 and d=0 group by spend_date
union all
select spend_date,'Desktop',sum(d),count(*)
from c where d>0 and m=0 group by spend_date
union all
select spend_date,'Both',sum(m+d),count(*)
from c where m>0 and d>0 group by spend_date

-- 10.
DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

with c as(
select product,quantity from grouped
union all
select product,quantity-1 from c where quantity>1
)
select product,1 quantity from c order by product
