select * from Employee_hierarchy ;

with recursive cte as 
( base query
union all
recursive part of the query
exit condition)



with recursive cte as 
( select emp_id, emp_id as emp_hierarchy
 from  where emp_id = 1
 union all
 select cte.emp_id,eh.emp_id as emp_hierarchy
 from cte 
 join Employee_hierarchy eh on cte.emp_hierarchy = eh.reporting_id)
 
select * 
from cte
order by emp_id, emp_hierarchy



--1st iteration

select emp_id, emp_id as emp_hierarchy
 from  where emp_id = 1
 
--2nd iteration
select cte.emp_id,eh.emp_id as emp_hierarchy
 from (select emp_id, emp_id as emp_hierarchy 
	   where emp_id = 1) cte
 join Employee_hierarchy eh on cte.emp_id = eh.reporting_id
 
--3rd iteration
select cte.emp_id,eh.emp_id as emp_hierarchy
 from (select cte.emp_id,eh.emp_id as emp_hierarchy
 		from (select emp_id, emp_id as emp_hierarchy
 		where emp_id = 1) cte
 join Employee_hierarchy eh on cte.emp_id = eh.reporting_id) cte
 join Employee_hierarchy eh on cte.emp_hierarchy = eh.reporting_id
 
 
