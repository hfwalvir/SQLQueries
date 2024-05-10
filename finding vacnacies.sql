--find vacant positions

select * from job_positions
select * from job_employees

--normal solution

with cte as(
select id, title,groups,levels,payscale, totalpost,1 as rn 
from job_positions
union all
select id, title,groups,levels,payscale, totalpost, rn+1
from cte
where rn+1 <=totalpost)
,emp as(
select *,
row_number() over (partition by position_id order by id) as rn
from job_employees)
select cte.*, emp.*, coalesce(emp.name,'vacant') as name 
from cte
left join emp on cte.id = emp.position_id and cte.rn= emp.rn
order by cte.id, cte.rn


-- easier approach

select * 
from job_positions
select * from Orders
-- here we are using orders table to get the row_id from there (without using recursive cte)
with t1 as (
select row_id as rn from orderswhere row_id <=(select max(totoalpost) from job_positions)
, cte as(
select * 
from job_positions jp
inner join t1 on t1.rn <= totalpost)
,emp as(
select *,
row_number() over (partition by position_id order by id) as rn
from job_employees)
select cte.*, coalesce(emp.name,'vacant') as name 
from cte
left join emp on cte.id = emp.position_id and cte.rn= emp.rn
order by cte.id, cte.rn