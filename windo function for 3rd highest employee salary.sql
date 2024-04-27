-- 3rd highest salary in the department
select * from emp
order by dep_id, salary desc;
with xxx as (
select emp_id, emp_name, salary, dep_id, dep_name
, rank() over (partition by dep_id order by salary desc) as rn
, count(1) over (partition by dep_id) as cnt
from emp)
select* from xxx 
where rn = 3 or (cnt<3 and rn=cnt) 



