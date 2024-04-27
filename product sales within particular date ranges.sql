
with recursive_cte as(
select min(period_start) as dates, max(period_end) as max_date
from sales
union all
select dateadd(day, 1, dates) as dates, max_date 
from recursive_cte
where dates  < max_date
)
select product_id, year(dates) as report_year, sum(average_daily_sales) as total_amount
from recursive_cte
inner join sales on dates between period_start and period_end
group by product_id, year(dates)
order by product_id, year(dates)
option (maxrecursion 1000);


