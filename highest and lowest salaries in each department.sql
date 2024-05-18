--highest and lowest salaries in each department


select * from employees
order by dep_id

--case when aggregation and join
with cte as(
select dep_id, min(salary) as min_sal, max(salary) as max_sal
from employees
group by dep_id)
select cte.dep_id,
max(case when salary = max_sal then emp_name else null end) as max_sal_emp,
min(case when salary = min_sal then emp_name else null end) as min_sal_emp
from cte
inner join employees e on cte.dep_id = e.dep_id 
group by cte.dep_id


--ranking and aggregation case when
with cte as(
select *, 
row_number() over (partition by dep_id order by salary desc) as rank_desc
,row_number() over(partition by dep_id order by salary asc) as rank_asc
from employees)

select dep_id,
max(case when rank_desc = 1 then emp_name end) as max_sal_emp
, max(case when rank_asc = 1 then emp_name end) as min_sal_emp
from cte 
group by dep_id

