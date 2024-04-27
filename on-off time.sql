select * from event_status;

with cte as(
select *, 
sum(case when status = 'on' and previous_status='off' then 1 else 0 end) over (order by event_time) as group_key
from(
select * 
, lag(status,1,status) over (order by event_time asc) as previous_status
from event_status) x
)
select min(event_time) as login, max(event_time) as logout, count(1)-1 as on_count 
from cte 
group by group_key;


