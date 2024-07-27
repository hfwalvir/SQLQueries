

select * from swipe

with cte as(
select *, cast(activity_time as date) as activity_day
, lead(activity_time) over (partition by employee_id , cast(activity_time as date)  order by activity_time) as logout_time
from swipe)

select employee_id, activity_day,
datediff(hour,min(activity_time),max(logout_time)) as total_hours
, sum(datediff(hour, activity_time,logout_time)) as inside_hours
from cte
where activity_type='login'
group by employee_id, activity_day 


