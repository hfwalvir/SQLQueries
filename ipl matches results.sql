select * from icc_world_cup;

--normal 
with all_matches as(
select team, sum(matches_played) as total_matches_plyed from 
(select team_1 as team, count(*) as matches_played from icc_world_cup group by team_1
union all
select team_2 as team, count(*) as matches_played from icc_world_cup group by team_2) a
group by team)
, winners as(
select winner, count(*) as wins from icc_world_cup group by winner)

select m.team, m.total_matches_plyed , coalesce(w.wins,0) as wins,m.total_matches_plyed - coalesce(w.wins,0) as losses, coalesce(w.wins,0)*2 as points
from all_matches m
left join winners w on m.team = w.winner
order by wins desc

--second method

with all_matches as(
select team, sum(matches_played) as total_matches_plyed, sum(win_flag) as wins, sum(draw_flag) as draws from 
(select team_1 as team, count(*) as matches_played,
sum(case when team_1 = winner then 1 else 0 end) as win_flag
,sum(case when winner = 'DRAW' then 1 else 0 end) as draw_flag
from icc_world_cup group by team_1
union all
select team_2 as team, count(*) as matches_played,
sum(case when team_2 = winner then 1 else 0 end) as win_flag,
sum(case when winner = 'DRAW' then 1 else 0 end) as draw_flag
from icc_world_cup group by team_2) a
group by team)
select * , total_matches_plyed- wins as losses, wins*2+draws as pts, draws as no_result
from all_matches
order by wins desc

