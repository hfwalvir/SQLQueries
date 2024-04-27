--solve without in built function

--finding median average salary for each company employees
select company, avg(salary) from
(select *,
row_number() over (partition by company order by salary asc) as rn
, count(1) over (partition by company) as total_count
from employee )x
where rn between total_count*1.0/2 AND total_count*1.0/2 + 1 
group by company 
