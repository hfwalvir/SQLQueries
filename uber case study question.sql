-- find if end loc of current = start loc of next ride (that is th eprofitble ride for the driver)

select * from drivers; 

--lead function window method 
select id, count(1) as total_rides
, sum(case when end_loc =  next_start_loc then 1 else 0 end) as profit_rides
from(
select * 
, lead(start_loc,1) over (partition by id order by start_time asc) as next_start_loc
from drivers) A 
group by id




--self join method 
with rides as(
select * ,
row_number() over (partition by id order by start_time asc) as rn
from drivers)
select r1.id,count(1) total_rides, count(r2.id) as profit_rides
from rides r1
left join rides r2
on r1.id = r2.id and r1.end_loc = r2.start_loc and r1.rn +1 =r2.rn
group by r1.id

