-- top 2 numbers for any 2 section and then top 2 sections
with cte as(
select * ,
row_number() over(partition by section order by number desc) as rn
from section_data)
, cte2 as (
select *,
sum(number) over (partition by section) as total,
max(number) over (partition by section) as max_sec
from cte 
where rn <=2) 
select * from(
select *,
dense_rank() over (order by total desc, max_sec desc)  as rnd
from cte2 ) A
where rnd <=2
select * from section_data


with cte as(
select *,
row_number() over (partition by section order by number desc) as rn
from section_data)
, cte1 as(
select * 
,sum(number) over(partition by section) as total,
max(number) over (partition by section) as Max_number
from cte
where rn <=2)

select * from(
select *,
dense_rank() over (order by total desc, max_number desc) as dense
from cte1) A
where dense <=2

