
select * from tasks
order by date_value;

with all_dates as (select * 
, row_number() over (partition by state order by date_value) as rn
,date_sub(date_value, INTERVAL (row_number() over (partition by state order by date_value)-1)DAY) as group_date
from tasks
order by date_value)

select min(date_value) as start_date, max(date_value) as end_date
from all_dates
group by group_date, state
order by start_date

