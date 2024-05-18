select * from covid_cases ;


-- method 1 , non-equi join
with cte as(
select month(record_date) as record_month, sum(cases_count) as monthly_cases
from covid_cases
group by month(record_date))
, cte2 as(
select current_month.record_month as current_month, prev_month.record_month as prior_months, 
current_month.monthly_cases as current_count, prev_month.monthly_cases as prior_count
from cte current_month
left join cte prev_month on prev_month.record_month < current_month.record_month)

select current_month, current_count,sum(prior_count) as cum_sum, round(current_count*100.0/sum(prior_count),1)  as percent_increase
from 
cte2 
group by current_month, current_count

-- method 2 
--advanced aggregation

with cte as(
select month(record_date) as record_month, sum(cases_count) as monthly_cases
from covid_cases
group by month(record_date))
, cte2 as (
select * 
, sum(monthly_cases) over (order by record_month rows between unbounded preceding and 1 preceding) as cum_sum
from cte) 

select record_month,  round(monthly_cases*100.0/cum_sum,1)  as percent_increase
from 
cte2 


