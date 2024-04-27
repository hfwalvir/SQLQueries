select * from covid; 


-- finding cities where covid cases are increasing continuously
with x as (
select *, 
rank() over (partition by city order by days asc) as rn_days
, rank() over (partition by city order by cases asc) as rn_cases
,rank() over (partition by city order by days asc) - rank() over (partition by city order by cases asc) as diff 
from covid)

select city
from x
group by city 
having count(distinct diff) = 1 and avg(diff) = 0

