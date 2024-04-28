--finding each of the milestones of sachin
USE [Hayapractice]
GO
with cte1 as(
select match, Innings, runs ,
sum(runs) over (order by match rows between unbounded preceding and current row) as rolling_sum
from [dbo].[sachin_scores]) 
, cte2 as (select 1 as milestone_number, 1000 as milestone_runs
union all
select 2 as milestone_number, 5000 as milestone_runs
union all
select 3 as milestone_number, 10000 as milestone_runs
union all
select 4 as milestone_number, 50000 as milestone_runs )
select milestone_number, milestone_runs, min(match) as milestone_match, min(innings) as milestone_innings
from cte2
inner join cte1 on rolling_sum > milestone_runs
group by milestone_number, milestone_runs
order by milestone_number 

