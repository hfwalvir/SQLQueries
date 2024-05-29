select * from entries;
with distinct_resources as (
select distinct name, resources from entries)
, agg_resources as (select name, string_agg(resources,',') as used_resources from distinct_resources group by name)
,total_visits as(select name,count(1) as total_visits, string_agg(resources,',') as resources_used
from entries group by name)
,floor_visit as (
select name, floor, count(1) no_of_floor_visit,
rank()  over (partition by name order by count(1) desc) as rn
from entries
group by name,floor)

select fv.name,fv.floor as most_visited_floor , tv.total_visits, ar.used_resources
from floor_visit fv
inner join agg_resources ar on fv.name = ar.name
inner join total_visits tv on fv.name = tv.name
where rn =1

