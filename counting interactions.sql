--
select * from user_interactions;

with cte as(
select game_id, case when count(interaction_type) = 0 then 'No social interaction'
when count(distinct case when interaction_type is not null then user_id end) = 1 then 'One sided interaction'
when count(distinct case when interaction_type is not null then user_id end) = 2 
and count(distinct case when interaction_type= 'custom_typed' then user_id end) = 0 then 'both sided interaction without Custom type'
when count(distinct case when interaction_type is not null then user_id end) = 2 
and count(distinct case when interaction_type is not null then user_id end) >= 1 then 'both sided interaction with Custom type'
end as game_type
from user_interactions
group by game_id)
select game_type, count(*)*100.0/count(*) over() as percent_dist, count(*) over() as total_records
from cte 
group by game_type 
