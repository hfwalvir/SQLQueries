-- populating category to the last not null value
with cte1 as (select *,
row_number() over(order by (select null)) as rn
from brands)
, cte2 as(
select * 
,lead(rn,1,8) over(order by rn) as next_rn
from cte1 
where category is not null)
select cte2.category, cte1.brand_name
from cte1 
inner join cte2 on cte1.rn >= cte2.rn and cte1.rn <= cte2.next_rn-1

