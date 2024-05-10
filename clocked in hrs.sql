--long method 

select * from clocked_hours;
with cte as(
select * ,
row_number () over (partition by empd_id, flag order by swipe) as rn 
from clocked_hours) 
, cte2 as(
select empd_id, rn , min(swipe) as swipe_in , max(swipe) as swipe_out,
datediff(hour,min(swipe),max(swipe)) as clocked_in_hrs
from cte
group by empd_id, rn) 
select empd_id, sum(clocked_in_hrs) as clocked_in_hrs
from cte2
group by empd_id



--second method (easier)
with cte as(
select *,
lead(swipe,1) over (partition by empd_id order by swipe) as next_swipe
from clocked_hours) 
select empd_id, sum(datediff(hour, swipe,next_swipe)) as clocked_in_hrs
from cte 
where flag ='I'
group by empd_id