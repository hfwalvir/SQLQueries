select game.match_id, game.match_date,game.team1, game.team2
, sum(case when game.team1 = goal.team_id then 1 else 0 end) as team_1_flag
, sum(case when game.team2 = goal.team_id then 1 else 0 end) as team_2_flag
from game
left join goal on game.match_id = goal.match_id
group by  game.match_id, game.match_date,game.team1, game.team2
