----- EASY TASKS -----
-- 1.
select concat(EMPLOYEE_ID, '-', FIRST_NAME, ' ', LAST_NAME) info from employees

-- 2.
update employees
set phone_number =
replace(phone_number, '124', '999')
select * from employees

-- 3.
select first_name, len(first_name) length from employees
where first_name like 'a%'
or first_name like 'j%'
or first_name like 'm%'
order by first_name

-- 4.
select e.manager_id, sum(m.salary) totalsalary from employees e
left join employees m
on e.MANAGER_ID = m.EMPLOYEE_ID
where e.manager_id > 0
group by e.MANAGER_ID

-- 5.
select year1, greatest(max1, max2, max3) max from testmax

-- 6.
select * from cinema
where id % 2 = 1
and description not like 'boring'

-- 7.
select *
from SingleOrder
order by case when Id = 0 then 1 else 0 end, id

-- 8.
select id, Coalesce(ssn, passportid, itin) nonnull from person

----- MEDIUM TASKS -----
-- 1. explaining needed
select * from students
select 
  studentid,
  left(fullname, charindex(' ', fullname)-1) as firstname,
  substring(fullname, charindex(' ', fullname)+1, charindex(' ', fullname, charindex(' ', fullname)+1) - charindex(' ', fullname)-1) as middlename,
  right(fullname, charindex(' ', reverse(fullname))-1) as lastname,
  grade
from students

-- 2.
select * from orders
where deliverystate = 'TX'
and customerid in (
    select distinct customerid
    from orders
    where deliverystate = 'CA'
)

-- 3.
select string_agg(string, ' ') 
within group (order by sequencenumber) query
from dmltable

-- 4.
 select employee_id, concat(first_name, ' ', last_name) name, email, phone_number, hire_date, job_id, salary, COMMISSION_PCT, manager_id, department_id from employees
 where concat(first_name, ' ', last_name)
 like '%a%a%a%'

-- 5.
select * from employees
select department_id,
count(employee_id) numofemp,
100 * count(case when year(hire_date) > 3 then 1 end) / count(employee_id) 'percent'
from employees
group by department_id

----- DIFFICULT TASKS -----
-- 1.
select *, sum(grade) over (order by studentid) runningtotal from students

-- 2.
select * from student 
where birthday in
(select birthday from student
group by birthday
having count(*) >  1)
order by birthday

-- 3.
select 
  case when playera < playerb then playera else playerb end as player1,
  case when playera < playerb then playerb else playera end as player2,
  sum(score) as total_score
from playerscores
group by 
  case when playera < playerb then playera else playerb end,
  case when playera < playerb then playerb else playera end

-- 4.
