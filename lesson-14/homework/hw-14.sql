----- EASY TASKS -----
-- 1.

select * from TestMultipleColumns
select substring(name, 1, charindex(',', name )-1) firstname,
substring(name, charindex(',', name )+1, len(name)) lastname
from TestMultipleColumns

-- 2.
select * from testpercent
where strs like '%!%%' escape '!'

-- 3.
select id,
parsename(vals, 3) as part1,
parsename(vals, 2) as part2,
parsename(vals, 1) as part3
from splitter

-- 4.
select * from testdots
where vals like '%.%.%.%'

-- 5.
select datalength(texts) - datalength(replace(texts,' ','')) "count" from countspaces
select * from countspaces

--6.
select concat(e.FIRST_NAME, ' ', e.LAST_NAME) empname, e.SALARY empsalary,
concat(m.FIRST_NAME,' ', m.LAST_NAME) mangname, m.SALARY mangsalary from employees e
join employees m
on m.EMPLOYEE_ID = e.MANAGER_ID
where e.SALARY > m.SALARY

-- 7.
select EMPLOYEE_ID, concat(first_name, ' ', LAST_NAME) empname,
HIRE_DATE, datediff(year, HIRE_DATE, getdate()) date_diff from employees
where datediff(year, HIRE_DATE, getdate()) > 10
and
datediff(year, HIRE_DATE, getdate()) < 15

----- MEDIUM TASKS -----
-- 1.
select w.Id, w.Temperature tdstemp, y.Temperature yesttemp from weather w
join weather y
on day(w.RecordDate) - 1 = day(y.RecordDate)
where w.Temperature > y.Temperature

-- 2.
 select * from activity
 select player_id, min(event_date) '1stlogin' from activity
 group by player_id

 -- 3.
 select * from fruits
select substring(
fruit_list,
charindex(',', fruit_list, charindex(',', fruit_list) + 1) + 1,   -- start after 2nd comma
charindex(',', fruit_list, charindex(',', fruit_list, charindex(',', fruit_list) + 1) + 1) 
- charindex(',', fruit_list, charindex(',', fruit_list) + 1) - 1  -- length between 2nd and 3rd comma
) as third_item
from fruits

-- 4.
select * from employees
select concat(First_name, ' ', LAST_NAME)empname, HIRE_DATE,
case 
	when datediff(year, hire_date, getdate()) < 1
		then 'New Hire'
	when datediff(year, hire_date, getdate()) between 1 and 5
		then 'Junior'
	when datediff(year, hire_date, getdate()) between 5 and 10
		then 'Mid-Level'
	when datediff(year, hire_date, getdate()) between 10 and 20
		then 'Senior'
	else 'Veteran'
	end 'status'
from employees
order by hire_date desc

-- 5.
select * from GetIntegers
select substring(vals, 1, 1)firstval from GetIntegers
where vals like '[1-9]%'

----- DIFFICULT TASKS -----
-- 1.
select id,
  substring(vals, charindex(',', vals) + 1, charindex(',', vals, charindex(',', vals) + 1) - charindex(',', vals) - 1)   -- second
  + ',' +
  left(vals, charindex(',', vals) - 1)   -- first
  + substring(vals, charindex(',', vals), len(vals))   -- rest
  as swapped_vals
from multiplevals

-- 2.
declare @str varchar(100) = 'sdgfhsdgfhs@121313131'

;with numbers as (
    select 1 as n
    union all
    select n+1 from numbers where n+1 <= len(@str)
)
select substring(@str, n, 1) as char
from numbers

-- 3.
select * from activity
select a.player_id, a.device_id, a.event_date
from activity a
where a.event_date = (select min(event_date) from activity
where a.player_id = player_id)

-- 4.

declare @str varchar(100) = 'rtcfvty34redt'
;with c as (
    select 1 as n,
           substring(@str,1,1) as ch
    union all
    select n+1,
           substring(@str,n+1,1)
    from c
    where n+1 <= len(@str)
)
select 
  string_agg(case when ch like '[0-9]' then ch end, '') as nums,
  string_agg(case when ch like '[a-zA-Z]' then ch end, '') as chars
from c
