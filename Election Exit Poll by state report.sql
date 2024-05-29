-- #3) Election Exit Poll by state report ---
select * from candidates_tab;
select * from results_tab;

with cte as(
select concat(first_name,last_name) as candidate_name,
state,
count(1) as total,
dense_rank() over (partition by concat(first_name,last_name)  order by count(1) desc) as rn
from candidates_tab c
join results_tab r on r.candidate_id = c.id
group by concat(first_name,last_name) , state)
--pirvoting from rows to col

select candidate_name, string_agg(case when rn=1 then concat(state,'(', total,')') end,',') as "1st_place",
string_agg(case when rn=2 then concat(state,'(', total,')') end,',') as "2nd_place",
string_agg(case when rn=3 then concat(state,'(', total,')') end,',') as "3rd_place"
from cte
where rn<= 3
group by candidate_name

--using pivot table
with cte as (
select concat(first_name,last_name) as candidate_name,
state, count(*) as total, 
dense_rank() over (partition by concat(first_name,last_name) order by count(1) desc) as rn
from candidates_tab c 
join results_tab r on r.candidate_id = c.id
group by concat(first_name,last_name) , state)

select candidate_name, [1] as "1st_place" , [2] as "2nd_place" , [3] as "3rd_place"
from (
    select candidate_name, concat(state,'(',total,')') as state_total,
	rn
	from cte
	where rn <= 3) x 
PIVOT (max(state_total) for rn in ([1],[2],[3]) 
) y ; 











