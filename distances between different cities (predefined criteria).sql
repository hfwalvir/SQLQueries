select * from city_distance 
--first solution
--retain only the first record out of the duplicates (alphabetically)

select * 
from city_distance c1 
left join city_distance c2 on c1.source = c2.destination and c1.destination = c2.source
where c2.distance is null or c1.distance != c2.distance or c1.source<c1.destination

-- 2nd solution
with cte as(
select * 
, case when source<destination then source else destination end as city1
, case when source<destination then destination else source end as city2
from city_distance
),
cte2 as(
select *,
count(*) over (partition by city1,city2,distance) as cnt
from cte)
select distance,source,destination
from cte2
where cnt=1 or source<destination

--3rd solution
with cte as(
select * 
,row_number() over(order by (select null)) as rn --it will create as per same order as present in the table
from city_distance)
select c1.*
from cte c1 
left join cte c2 on c1.source = c2.destination and c1.destination = c2.source
where c2.distance is null or c1.distance != c2.distance or c1.rn<c2.rn
