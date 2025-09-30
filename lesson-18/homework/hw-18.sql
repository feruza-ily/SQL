-- 1
select p.productid,sum(s.quantity) totalquantity,sum(s.quantity*p.price) totalrevenue
into #monthlysales
from products p
join sales s on p.productid=s.productid
where month(s.saledate)=month(getdate()) and year(s.saledate)=year(getdate())
group by p.productid

select * from #monthlysales

-- 2
create view vw_productsalessummary as
select p.productid,p.productname,p.category,sum(s.quantity) totalquantitysold
from products p
left join sales s on p.productid=s.productid
group by p.productid,p.productname,p.category

-- 3
create function fn_gettotalrevenueforproduct(@productid int)
returns decimal(18,2)
as
begin
declare @rev decimal(18,2)
select @rev=sum(s.quantity*p.price)
from products p
join sales s on p.productid=s.productid
where p.productid=@productid
return @rev
end

-- 4
create function fn_getsalesbycategory(@category varchar(50))
returns table
as
return(
select p.productname,sum(s.quantity) totalquantity,sum(s.quantity*p.price) totalrevenue
from products p
join sales s on p.productid=s.productid
where p.category=@category
group by p.productname
)

-- 5
create function fn_isprime(@number int)
returns varchar(3)
as
begin
declare @i int=2,@flag int=1
if @number<=1 return 'No'
while @i<=sqrt(@number)
begin
if @number%@i=0 set @flag=0
set @i=@i+1
end
if @flag=1 return 'Yes' else return 'No'
end

-- 6
create function fn_getnumbersbetween(@start int,@end int)
returns @t table(number int)
as
begin
while @start<=@end
begin
insert into @t values(@start)
set @start=@start+1
end
return
end

-- 7
create function getnthhighestsalary(@n int)
returns int
as
begin
declare @res int
select @res=salary from(
select distinct salary,row_number() over(order by salary desc) rn
from employee
)x where rn=@n
return @res
end

-- 8
select id,count(*) num
from(
select requester_id id,accepter_id from requestaccepted
union all
select accepter_id id,requester_id from requestaccepted
)x
group by id
order by num desc

-- 9
create view vw_customerordersummary as
select c.customer_id,c.name,
count(o.order_id) total_orders,
sum(o.amount) total_amount,
max(o.order_date) last_order_date
from customers c
left join orders o on c.customer_id=o.customer_id
group by c.customer_id,c.name

-- 10
select rownumber,
max(testcase) over(order by rownumber rows unbounded preceding) workflow
from gaps
