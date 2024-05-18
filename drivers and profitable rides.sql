select * from drivers
select * from drivers


--self join
with rides as (
select * , row_number() over (partition by id order by start_time asc) as rn
from drivers)
select r1.id, count(1) as total_rides, count(r2.id) as profit_rides
from rides r1
left join rides r2
on r1.id = r2.id and r1.end_loc = r2.start_loc and r1.rn+1 = r2.rn
group by r1.id

