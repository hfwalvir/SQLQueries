--atleast 3 consecutive rows where number of people more than 100

with grp_number as (
select *, 
row_number() over (order by visit_date) as rn, id-row_number() over (order by visit_date) as grp
from stadium
where no_of_people >= 100)
select id, visit_date, no_of_people
from grp_number 
where grp in 
(select grp
from grp_number
group by grp having count(1) >=3)
