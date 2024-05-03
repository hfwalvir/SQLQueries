--hiring criteria : start from smallest salaried senior employee, rfer to budget as $70000
--then for remaining budget hire from smallest salaried junior
with total_sal as(
(select *, 
sum(salary) over (partition by experience order by salary asc rows between unbounded preceding and current row) as running_sal
from candidates)
, seniors as (
select * from total_sal 
where experience = 'Senior' and running_sal <=70000)
select * from total_sal where experience = 'Junior' and running_sal <=70000 - (select sum(salary) from seniors)
union all
select * from seniors ;  
