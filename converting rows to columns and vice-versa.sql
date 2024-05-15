--converting rows to columns and vice-versa (without pivot)

select emp_id
, sum(case when salary_component_type='salary' then val end) as salary
, sum(case when salary_component_type='bonus' then val end) as bonus
, sum(case when salary_component_type='hike_percent' then val end) as hike_percent
into emp_compensation_pivot
from emp_compensation
group by emp_id
select * from emp_compensation
select * from emp_compensation_pivot
--unpivoting(converting back from columns to rows)
select * from
(select emp_id, 'salary' as salary_component_type, salary as val 
from emp_compensation_pivot
union all
select emp_id, 'bonus' as salary_component_type, bonus as val 
from emp_compensation_pivot
union all 
select emp_id, 'hike_percent' as salary_component_type, hike_percent as val 
from emp_compensation_pivot) a
order by emp_id