-- 1 create stored procedure for Employee Bonus
create procedure sp_CreateEmployeeBonus
as
begin
create table #EmployeeBonus (
EmployeeID int,
FullName nvarchar(100),
Department nvarchar(50),
Salary decimal(10,2),
BonusAmount decimal(10,2)
)
insert into #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
select e.EmployeeID, e.FirstName + ' ' + e.LastName, e.Department, e.Salary, e.Salary * b.BonusPercentage / 100
from Employees e
join DepartmentBonus b on e.Department=b.Department
select * from #EmployeeBonus
end

-- 2 create stored procedure to update salary by department
create procedure sp_UpdateSalaryByDepartment
@Department nvarchar(50),
@IncreasePercentage decimal(5,2)
as
begin
update Employees
set Salary = Salary + Salary*@IncreasePercentage/100
where Department=@Department
select * from Employees where Department=@Department
end

-- 3.
drop table if exists Products_Current
drop table if exists Products_New

create table Products_Current (
ProductID int primary key,
ProductName nvarchar(100),
Price decimal(10,2)
)

create table Products_New (
ProductID int primary key,
ProductName nvarchar(100),
Price decimal(10,2)
)

insert into Products_Current values
(1, 'Laptop', 1200),
(2, 'Tablet', 600),
(3, 'Smartphone', 800)

insert into Products_New values
(2, 'Tablet Pro', 700),
(3, 'Smartphone', 850),
(4, 'Smartwatch', 300)

merge Products_Current as target
using Products_New as source
on target.ProductID=source.ProductID
when matched then update set target.ProductName=source.ProductName, target.Price=source.Price
when not matched by target then insert (ProductID, ProductName, Price) values (source.ProductID, source.ProductName, source.Price)
when not matched by source then delete
output inserted.*;


-- 4 Tree Node

drop table if exists Tree
create table Tree (id int, p_id int)
insert into Tree (id, p_id) values (1, null),(2, 1),(3, 1),(4, 2),(5, 2)
select t1.id,
case
when t1.p_id is null then 'Root'
when t1.id in (select p_id from Tree where p_id is not null) then 'Inner'
else 'Leaf'
end type
from Tree t1

-- 5 Confirmation Rate
drop table if exists Signups
drop table if exists Confirmations
create table Signups (user_id int, time_stamp datetime)
create table Confirmations (user_id int, time_stamp datetime, action varchar(10))
insert into Signups (user_id, time_stamp) values (3, '2020-03-21 10:16:13'),(7, '2020-01-04 13:57:59'),(2, '2020-07-29 23:09:44'),(6, '2020-12-09 10:39:37')
insert into Confirmations (user_id, time_stamp, action) values
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout')
select s.user_id,
cast(coalesce(sum(case when c.action='confirmed' then 1 else 0 end)/nullif(count(c.user_id),0),0) as decimal(3,2)) confirmation_rate
from Signups s
left join Confirmations c on s.user_id=c.user_id
group by s.user_id

-- 6 Employees with lowest salary
drop table if exists employees
create table employees (id int primary key, name varchar(100), salary decimal(10,2))
insert into employees (id, name, salary) values (1, 'Alice', 50000),(2, 'Bob', 60000),(3, 'Charlie', 50000)
select * from employees where salary=(select min(salary) from employees)

-- 7 Get Product Sales Summary
drop table if exists Products
drop table if exists Sales
create table Products (ProductID int primary key, ProductName nvarchar(100), Category nvarchar(50), Price decimal(10,2))
create table Sales (SaleID int primary key, ProductID int foreign key references Products(ProductID), Quantity int, SaleDate date)
insert into Products (ProductID, ProductName, Category, Price) values
(1, 'Laptop Model A', 'Electronics', 1200),
(2, 'Laptop Model B', 'Electronics', 1500),
(3, 'Tablet Model X', 'Electronics', 600),
(4, 'Tablet Model Y', 'Electronics', 700),
(5, 'Smartphone Alpha', 'Electronics', 800),
(6, 'Smartphone Beta', 'Electronics', 850),
(7, 'Smartwatch Series 1', 'Wearables', 300),
(8, 'Smartwatch Series 2', 'Wearables', 350),
(9, 'Headphones Basic', 'Accessories', 150),
(10, 'Headphones Pro', 'Accessories', 250),
(11, 'Wireless Mouse', 'Accessories', 50),
(12, 'Wireless Keyboard', 'Accessories', 80),
(13, 'Desktop PC Standard', 'Computers', 1000),
(14, 'Desktop PC Gaming', 'Computers', 2000),
(15, 'Monitor 24 inch', 'Displays', 200),
(16, 'Monitor 27 inch', 'Displays', 300),
(17, 'Printer Basic', 'Office', 120),
(18, 'Printer Pro', 'Office', 400),
(19, 'Router Basic', 'Networking', 70),
(20, 'Router Pro', 'Networking', 150)
insert into Sales (SaleID, ProductID, Quantity, SaleDate) values
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01')
drop procedure if exists GetProductSalesSummary
create procedure GetProductSalesSummary @ProductID int
as
begin
select p.ProductName,
sum(s.Quantity) TotalQuantity,
sum(s.Quantity*p.Price) TotalAmount,
min(s.SaleDate) FirstSaleDate,
max(s.SaleDate) LastSaleDate
from Products p
left join Sales s on p.ProductID=s.ProductID
where p.ProductID=@ProductID
group by p.ProductName
end
