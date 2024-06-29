select cast('2000-01-01' as date) as cal_date
,datepart(year,'2000-01-01') as cal_year
,datepart(dayofyear, '2000-01-01') as cal_year_day
,datepart(quarter, '2000-01-01') as cal_quarter
,datepart(month, '2000-01-01') as cal_month
,datename(month, '2000-01-01') as cal_month_name
,datepart(day, '2000-01-01') as cal_month_day
,datepart(week, '2000-01-01') as cal_week
,datepart(weekday, '2000-01-01') as cal_week_day
,datename(weekday, '2000-01-01') as cal_day_name


with cte as (
select cast('2000-01-01' as date) as cal_date
,datepart(year, '2000-01-01') as cal_year
,datepart(dayofyear, '2000-01-01') as cal_year_day
,datepart(quarter, '2000-01-01') as cal_quarter
,datepart(month, '2000-01-01') as cal_month
,datename(month, '2000-01-01') as cal_month_name
,datepart(day, '2000-01-01') as cal_month_day
,datepart(week, '2000-01-01') as cal_week
,datepart(weekday, '2000-01-01') as cal_week_day
,datename(weekday, '2000-01-01') as cal_day_name
union all
select dateadd(day,1,cal_date) as cal_date
, datepart(year, dateadd(day,1,cal_date)) as cal_year
,datepart(dayofyear,dateadd(day,1,cal_date) ) as cal_year_day
,datepart(quarter, dateadd(day,1,cal_date)) as cal_quarter
,datepart(month,dateadd(day,1,cal_date) ) as cal_month
,datename(month,dateadd(day,1,cal_date) ) as cal_month_name
,datepart(day,dateadd(day,1,cal_date) ) as cal_month_day
,datepart(week,dateadd(day,1,cal_date)) as cal_week
,datepart(weekday,dateadd(day,1,cal_date) ) as cal_week_day
,datename(weekday, dateadd(day,1,cal_date)) as cal_day_name
from cte
where cal_date < '2050-12-31')

select row_number() over (order by cal_date) as id,* into cal_dim_new
from cte
option (maxrecursion 32676)

select * from cal_dim_new
order by id