
----- 1.COMBINE TWO TABLES -----

Create table Person (personId int, firstName varchar(255), lastName varchar(255))
Create table Address (addressId int, personId int, city varchar(255), state varchar(255))
Truncate table Person
insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen')
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob')
Truncate table Address
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York')
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California')

-----SOLUTION-----

select * from person
select * from address

select p.firstname, p.lastname, a.city, a.state
from person p
left join address a
on p.personid = a.personid

----- 2. EMPLOYEES EARNING MORE THAN THEIR MANAGERS -----

Create table Employee (id int, name varchar(255), salary int, managerId int)
Truncate table Employee
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3')
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4')
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL)
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL)

-----SOLUTION-----

select * from employee

select e.name employee
from employee e
join employee m
on e.managerId = m.id
where e.salary > m.salary

----- 3. DUPLICATE EMAILS -----
drop table if exists person
Create table Person (id int, email varchar(255))
Truncate table Person
insert into Person (id, email) values ('1', 'a@b.com')
insert into Person (id, email) values ('2', 'c@d.com')
insert into Person (id, email) values ('3', 'a@b.com')

-----SOLUTION-----

select email from person
group by email
having count(*) >1

----- 4. DELETE DUPLICATE EMAILS -----

drop table if exists person
Create table Person (id int, email varchar(255))
Truncate table Person
insert into Person (id, email) values ('1', 'john@example.com')
insert into Person (id, email) values ('2', 'bob@example.com')
insert into Person (id, email) values ('3', 'john@example.com')

-----SOLUTION-----

delete p
from Person p
join Person q
  on p.Email = q.Email
 and p.Id > q.Id;
 select * from person

 ----- 5. FIND THOSE PARENTS WHO HAS ONLY GIRLS -----

 CREATE TABLE boys (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

CREATE TABLE girls (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

INSERT INTO boys (Id, name, ParentName) 
VALUES 
(1, 'John', 'Michael'),  
(2, 'David', 'James'),   
(3, 'Alex', 'Robert'),   
(4, 'Luke', 'Michael'),  
(5, 'Ethan', 'David'),    
(6, 'Mason', 'George');  


INSERT INTO girls (Id, name, ParentName) 
VALUES 
(1, 'Emma', 'Mike'),  
(2, 'Olivia', 'James'),  
(3, 'Ava', 'Robert'),    
(4, 'Sophia', 'Mike'),  
(5, 'Mia', 'John'),      
(6, 'Isabella', 'Emily'),
(7, 'Charlotte', 'George');

-----SOLUTION-----

select * from boys
select * from girls

select distinct g.parentname from girls g
left join boys b
on g.ParentName = b.ParentName
where b.ParentName is null

----- 6. TOTAL OVER 50 AND LEAST -----

-----SOLUTION-----

select * from sales.orders

select custid, count(custid) 'totalsales>50', min(freight) leastweight from sales.orders
where freight > 50
group by custid

----- 7. CARTS -----

DROP TABLE IF EXISTS Cart1;
DROP TABLE IF EXISTS Cart2;
GO

CREATE TABLE Cart1
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

CREATE TABLE Cart2
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

INSERT INTO Cart1 (Item) VALUES
('Sugar'),('Bread'),('Juice'),('Soda'),('Flour');
GO

INSERT INTO Cart2 (Item) VALUES
('Sugar'),('Bread'),('Butter'),('Cheese'),('Fruit');
GO

-----SOLUTION-----

select * from cart1
select * from cart2
select coalesce(o.item, ' ') item, coalesce(t.item, ' ') item from cart1 o
full join cart2 t
on o.Item = t.Item


----- 8. CUSTOMERS WHO NEVER ORDER -----

drop table if exists customers
drop table if exists orders
Create table Customers (id int, name varchar(255))
Create table Orders (id int, customerId int)
Truncate table Customers
insert into Customers (id, name) values ('1', 'Joe')
insert into Customers (id, name) values ('2', 'Henry')
insert into Customers (id, name) values ('3', 'Sam')
insert into Customers (id, name) values ('4', 'Max')
Truncate table Orders
insert into Orders (id, customerId) values ('1', '3')
insert into Orders (id, customerId) values ('2', '1')

-----SOLUTION-----

select * from customers
select * from orders
select c.name from customers c
full join orders o
on c.id = o.customerId
where o.id is null

----- 9. STUDENTS AND EXAMINATIONS -----

Create table Students (student_id int, student_name varchar(20))
Create table Subjects (subject_name varchar(20))
Create table Examinations (student_id int, subject_name varchar(20))
Truncate table Students
insert into Students (student_id, student_name) values ('1', 'Alice')
insert into Students (student_id, student_name) values ('2', 'Bob')
insert into Students (student_id, student_name) values ('13', 'John')
insert into Students (student_id, student_name) values ('6', 'Alex')
Truncate table Subjects
insert into Subjects (subject_name) values ('Math')
insert into Subjects (subject_name) values ('Physics')
insert into Subjects (subject_name) values ('Programming')
Truncate table Examinations
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Programming')
insert into Examinations (student_id, subject_name) values ('2', 'Programming')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Programming')
insert into Examinations (student_id, subject_name) values ('13', 'Physics')
insert into Examinations (student_id, subject_name) values ('2', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Math')

-----SOLUTION-----

select * from students
select * from subjects
select * from examinations

select s.student_id, s.student_name, j.subject_name, count(e.subject_name) attended_exams from students s
cross join subjects j
left join examinations e
on s.student_id = e.student_id
and e.subject_name = j.subject_name
group by s.student_id, s.student_name, j.subject_name
