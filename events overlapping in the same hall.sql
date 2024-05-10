--events overlapping in the same hall


with cte as(
select hall_id, start_date, end_date,
lag(end_date) over (partition by hall_id order by start_date) as prev_end_date
from hall_events)
select hall_id, min(start_date)as start_date, max(end_date) as end_date
from cte
where prev_end_date is null or start_date < prev_end_date
group by hall_id
union all
select hall_id, start_date, end_date 
from cte
where start_date > prev_end_date
order by hall_id, start_date

