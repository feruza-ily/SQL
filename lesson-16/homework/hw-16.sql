-- 1. numbers 1 to 1000
;with Numbers as (
select 1 as num
union all
select num + 1
from Numbers
where num < 1000
)
select num
from Numbers
option (maxrecursion 0)

-- 2. total sales per employee
select e.employeeid, e.firstname, e.lastname, t.totalsales
from employees e
join (
select employeeid, sum(salesamount) totalsales from sales
group by employeeid
) t
on e.employeeid = t.employeeid

-- 3. avg salary with cte
with avgsal as (
select avg(salary) avgsalary from employees
)
select avgsalary from avgsal

-- 4. highest sales per product
select p.productid, p.productname, t.maxsale
from products p
join (
select productid, max(salesamount) maxsale from sales
group by productid
) t
on p.productid = t.productid

-- 5. doubling numbers until < 1000000
with dbl as (
select 1 as n
union all
select n*2 from dbl where n*2 < 1000000
)
select n from dbl

-- 6. employees with more than 5 sales
with emp_sales as (
select employeeid, count(*) num_sales from sales
group by employeeid
)
select e.employeeid, e.firstname, e.lastname from employees e
join emp_sales s on e.employeeid = s.employeeid
where s.num_sales > 5

-- 7. products with sales > 500
with prod_sales as (
select productid, sum(salesamount) totalsales from sales
group by productid
)
select p.productid, p.productname, totalsales from products p
join prod_sales ps on p.productid = ps.productid
where totalsales > 500

-- 8. employees with salary above avg
with avg_sal as (
select avg(salary) avgsal from employees
)
select employeeid, firstname, lastname, salary from employees
where salary > (select avgsal from avg_sal)

-- 9. top 5 employees by orders
select top 5 e.employeeid, e.firstname, e.lastname, t.numorders
from employees e
join (
select employeeid, count(*) numorders from sales
group by employeeid
) t
on e.employeeid = t.employeeid
order by t.numorders desc

-- 10. sales per product category
select p.categoryid, sum(s.salesamount) totalsales
from sales s
join products p on s.productid = p.productid
group by p.categoryid

-- 11. factorial of each value
with fact as (
select number as n, cast(number as bigint) fact, number as step from numbers1
union all
select n, fact*step, step-1 from fact where step > 1
)
select n, max(fact) factorial from fact
group by n

-- 12. split string into characters
with cte as (
select id, string, 1 as pos, substring(string,1,1) as ch from example
union all
select id, string, pos+1, substring(string,pos+1,1) from cte
where pos < len(string)
)
select id, ch from cte

-- 13. sales difference current vs previous month
with monthly as (
select year(saledate) y, month(saledate) m, sum(salesamount) totalsales
from sales
group by year(saledate), month(saledate)
),
diff as (
select y,m,totalsales,
lag(totalsales) over(order by y,m) prevsales
from monthly
)
select y,m,totalsales,totalsales-prevsales as diff from diff

-- 14. employees with quarterly sales > 45000
select e.employeeid, e.firstname, e.lastname, t.qtr, t.totalsales
from employees e
join (
select employeeid, datepart(quarter,saledate) qtr, sum(salesamount) totalsales
from sales
group by employeeid, datepart(quarter,saledate)
) t
on e.employeeid = t.employeeid
where t.totalsales > 45000

-- 15. fibonacci numbers
with fib as (
select 0 as a, 1 as b
union all
select b, a+b from fib where a+b < 1000
)
select a from fib

-- 16. string where all chars same and length>1
select id, vals from findsamecharacters
where len(vals) > 1
and len(replace(vals, left(vals,1), '')) = 0

-- 17. numbers like 1,12,123...
with seq as (
select 1 as n, cast('1' as varchar(50)) s
union all
select n+1, cast(s + cast(n+1 as varchar(10)) as varchar(50)) from seq where n < 5
)
select s from seq

-- 18. top employee by sales last 6 months
select top 1 e.employeeid, e.firstname, e.lastname, t.totalsales
from employees e
join (
select employeeid, sum(salesamount) totalsales from sales
where saledate >= dateadd(month,-6,getdate())
group by employeeid
) t
on e.employeeid = t.employeeid
order by t.totalsales desc

-- 19. remove duplicate ints in string
select pawanname,
replace(
replace(
replace(
replace(
replace(pawan_slug_name,'-111',''),
'-123',''),
'-32',''),
'-4444',''),
'-3','') cleanstring
from removeduplicateintsfromnames
