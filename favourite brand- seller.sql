 with rank_orders as(
 select *,
rank() over (partition by seller_id order by order_date asc) as rn
from orderss)
select u.user_id, 
case when i.item_brand = u.favorite_brand then 'Yes' else 'No' end as item_for_brand
from userss u 
left join rank_orders ro on ro.seller_id = u.user_id and rn = 2
left join items i on i.item_id = ro.item_id


