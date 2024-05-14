select * from employeee

--Using last_value
select *, 
last_value(emp_name) over (partition by dept_id order by emp_age rows between current row and unbounded following) as oldest_emp
from employeee
order by dept_id,emp_age

--Alternatively
select *, 
first_value(emp_name) over (partition by dept_id order by emp_age desc) as oldest_emp
from employeee
order by dept_id,emp_age