-- real business case study
select *,
datediff(day,create_date, resolved_date) as actual_days,
datediff(day,create_date, resolved_date) - 2*datediff(week,create_date, resolved_date) - no_of_holidays
as business_days
from (
select ticket_id, create_date,resolved_date , count(holiday_date) as no_of_holidays
-- datediff(day,create_date, resolved_date) as actual_days
-- datediff(day,create_date, resolved_date) - 2*datediff(week,create_date, resolved_date)
--as business_day
from tickets
left join holidays on holiday_date between create_date and resolved_date
group by  ticket_id, create_date,resolved_date ) x


-- what if the public holidays fall in weekends

select *,
datediff(day,create_date, resolved_date) as actual_days,
datediff(day,create_date, resolved_date) - 2*datediff(week,create_date, resolved_date) - no_of_holidays
as business_days from(
select ticket_id, create_date,resolved_date , count(holiday_date) as no_of_holidays
-- datediff(day,create_date, resolved_date) as actual_days
-- datediff(day,create_date, resolved_date) - 2*datediff(week,create_date, resolved_date)
--as business_day
from tickets
left join holidays on (holiday_date between create_date and resolved_date) and (DATENAME(WEEKDAY,holiday_date) <> 'Saturday' AND 
DATENAME(WEEKDAY,holiday_date) <> 'Sunday') 
group by  ticket_id, create_date,resolved_date ) x
