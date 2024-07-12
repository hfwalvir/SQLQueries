--find winning streak
/* -- Problem Statement: IPL Winning Streak
Given table has details of every IPL 2023 matches. Identify the maximum winning streak for each team. 
Additional test cases: 
1) Update the dataset such that when Chennai Super Kings win match no 17, your query shows the updated streak.
2) Update the dataset such that Royal Challengers Bangalore loose all match and your query should populate the winning streak as 0
*/




with cte_teams as(
select home_team as team from ipl_results
union all
select away_team as team from ipl_results)
,next_cte as(
select team, dates, result,
concat(home_team, ' vs ', away_team) as matches,
row_number() over (partition by team order by team,dates)  as id
from cte_teams c
join ipl_results i on c.team = i.home_team or c.team = i.away_team)
, cte_diff as(select * , id - row_number() over(partition by team order by team,dates)
	as diff
from next_cte 
where result = team)
,cte_final as(select *,count(1) over (partition by team, diff order by team, dates
					 rows between unbounded preceding and unbounded following) as winning_streak
from cte_diff)

select ct.team ,coalesce(max(winning_streak),0) as winning_streak
from cte_final cf
left join cte_teams ct on cf.team = cf.team
group by ct.team
order by max(winning_streak) desc




