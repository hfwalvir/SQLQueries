/*
PROBLEM STATEMENT: 
Given vacation_plans tables shows the vacations applied by each employee during the year 2024. 
Leave_balance table has the available leaves for each employee.
Write an SQL query to determine if the vacations applied by each employee can be approved or not based on the available leave balance. 
If an employee has enough available leaves then mention the status as "Approved" else mention "Insufficient Leave Balance".
Assume there are no public holidays during 2024. weekends (sat & sun) should be excluded while calculating vacation days. 
*/



select * from vacation_plans;
select * from leave_balance;

with recursive cte as(
with cte_data as(
select v.id,v.emp_id,v.from_dt,v.to_dt,count(s.dates) as vacation_days, l.balance
,row_number() over (partition by v.emp_id order by v.emp_id,v.id) as rn
	from vacation_plans v
cross join lateral (select cast(dates as date) as dates, to_char(dates,'Day') as day
 from generate_series (v.from_dt,v.to_dt,'1 day') dates) s
join leave_balance l on v.emp_id = l.emp_id
where day not in ('Saturday','Sunday')
group by v.id,v.emp_id,v.from_dt,v.to_dt, l.balance)
select *, (balance - vacation_days) as remaining_balance
	from cte_data
	where rn = 1
union all
select c.*, (cte.remaining_balance - c.vacation_days) as remaining_balance
from cte 
join cte_data c on c.id = cte.id+1

)
select *
, case when remaining_balance < 0 then 'Insuffecient Leave Balance' else 'Approved' end as status
from cte

