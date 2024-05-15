
--pwc interview question (revenue increase should be in all the years)


select *
from company_revenue ;

--first solution
with cte as(
select * ,
lag(revenue,1,0) over (partition by company order by year) as prev_rev
, revenue - lag(revenue,1,0) over (partition by company order by year) as rev_diff
, count(1) over (partition by company) as cnt_yrs
from company_revenue)

select company
from cte
where rev_diff > 0
group by company, cnt_yrs
having cnt_yrs = count(1)


-- quick solution
with cte as(
select * ,
--lag(revenue,1,0) over (partition by company order by year) as prev_rev
revenue - lag(revenue,1,0) over (partition by company order by year) as rev_diff
, count(1) over (partition by company) as cnt_yrs
from company_revenue)

select company
from cte
where company not in (select company from cte where rev_diff < 0)
group by company
