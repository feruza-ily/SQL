-- bulk insert is used to quickly bring in data from a file like .txt or .csv into a table
-- formats that can be imported into sql server: txt, csv, xls/xlsx (excel), xml

create table products (
    productid int primary key,
    productname varchar(50),
    price decimal(10,2)
)

insert into products values
(1, 'apple', 1.5),
(2, 'banana', 0.9),
(3, 'orange', 1.2)

-- null means empty or unknown, not null means a value is required

alter table products
add constraint uq_productname unique (productname)

-- this comment explains what the next line does

alter table products
add categoryid int

create table categories (
    categoryid int primary key,
    categoryname varchar(50) unique
)

-- identity is used to automatically generate numbers for a column
create table auto_test (
    id int identity(1,1) primary key,
    name varchar(50)
)
bulk insert products
from 'C:\\C++\\SQL\\products.txt'
with (
    fieldterminator = ',',
    rowterminator = '\n',
    firstrow = 1,
)

alter table products
add constraint fk_category foreign key (categoryid) references categories(categoryid)

-- primary key is one per table and can't be null
-- unique key allows duplicates and one null value unless not null is added

alter table products
add constraint chk_price check (price > 0)

alter table products
add stock int not null default 0

select productid, productname, isnull(price, 0) as price from products

-- foreign key makes sure values in one table match the values in another
-- for example, the product's category must exist in the categories table
create table customers (
    id int primary key,
    name varchar(50),
    age int check (age >= 18)
)

create table test_identity (
    id int identity(100,10) primary key,
    item varchar(50)
)

create table orderdetails (
    orderid int,
    productid int,
    quantity int,
    primary key (orderid, productid)
)

-- coalesce and isnull are both used to replace null values
-- isnull can only check one value, coalesce checks multiple and returns the first one that's not null

create table employees (
    empid int primary key,
    name varchar(50),
    email varchar(50) unique
)

alter table products
add constraint fk_category_cascade foreign key (categoryid)
references categories(categoryid)
on delete cascade
on update cascade
