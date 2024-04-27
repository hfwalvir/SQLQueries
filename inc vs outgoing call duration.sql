-- numbers having both incoming and outgoing calls with sum of duration of outgoing being more than sum of duration of incoming

select * 
from call_details ;

--cte and filter clause
with cte as(
select call_number, 
sum(case when call_type = 'OUT' then call_duration else null end) as out_duration 
,sum(case when call_type = 'INC' then call_duration else null end) as inc_duration 
from call_details
group by call_number)
select call_number 
from cte
where out_duration is not null and inc_duration is not null and out_duration > inc_duration

-- using having clause
select call_number
from call_details
group by call_number
having sum(case when call_type = 'OUT' then call_duration else null end) > 0 
 and sum(case when call_type = 'INC' then call_duration else null end) > 0
and sum(case when call_type = 'OUT' then call_duration else null end) > sum(case when call_type = 'INC' then call_duration else null end)

-- using cte and join
with cte_out as(
select call_number, 
sum(call_duration) as duration 
from call_details
where call_type = 'OUT'
group by call_number)
,cte_in as
(select call_number, 
sum(call_duration) as duration 
from call_details
where call_type = 'INC'
group by call_number)
select cte_out.call_number
from cte_out inner join cte_in on cte_out.call_number = cte_in.call_number
where cte_out.duration > cte_in.duration;
