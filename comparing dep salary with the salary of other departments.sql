-- comparing dep salary with the salary of other departments

with cte as (select department_id, avg(salary)  as dep_avg,
count(*) as no_of_emp, sum(salary) as total_dep_sal
from employeess 
group by department_id)


select * from (
select a.department_id, a.dep_avg,sum(b.no_of_emp) as no_of_emp,
sum(b.total_dep_sal)/ sum(b.no_of_emp) as avg_of_other_2
from cte a
inner join cte b on a.department_id != b.department_id
group by a.department_id, a.dep_avg
) A
where dep_avg < avg_of_other_2

 