select * from call_start_logs;
select * from call_end_logs;


--join
select A.phone_number, A.rn, A.start_time, b.end_time,
datediff(minute,start_time,end_time) as duration from
(select * ,
row_number() over (partition by phone_number order by start_time) as rn 
from call_start_logs) A
inner join 
(select * ,
row_number() over (partition by phone_number order by end_time) as rn 
from call_end_logs) b
on A.phone_number = b.phone_number and A.rn = b.rn

--union
select phone_number, rn, min(call_time) as start_time, max(call_time) as end_time --b.end_time,
,datediff(minute,min(call_time),max(call_time)) as duration
from
(select phone_number,start_time as call_time,
row_number() over (partition by phone_number order by start_time) as rn 
from call_start_logs
union all
select * ,
row_number() over (partition by phone_number order by end_time) as rn 
from call_end_logs)x
group by phone_number, rn