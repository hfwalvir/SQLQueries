
with cte as(
select *,
sum(weight_kg) over (partition by id order by id, weight_kg ) as cumulative_sum
, case when capacity_kg >= sum(weight_kg) over (partition by id order by id, weight_kg)
  then 1 else 0 end as flag
from lift l 
join lift_passengers p on l.id = p.lift_id
order by id, weight_kg)

select id, string_agg(passenger_name,',') as passengers
from cte
where flag = 1
group by id



