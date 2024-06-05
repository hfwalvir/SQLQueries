-- problem st : updating quantity of order fulfillment

select * from batch;


select * from orders;

--expanding batch table
WITH RECURSIVE batch_expansion as(
select batch_id, 1 as quantity from batch
union all
select b.batch_id, (cte.quantity + 1) as quantity
from batch_expansion cte
join batch b on b.batch_id = cte.batch_id and b.quantity > cte.quantity
)
select batch_id, 1 as quantity
from batch_expansion
order by 1,2

WITH RECURSIVE order_expansion as(
select order_number, 1 as quantity from batch
union all
select o.order_number, (cte.quantity + 1) as quantity
from order_expansion cte
join orders o on o.ordere.order_number and o.quantity > cte.quantity
)
select order_number, 1 as quantity
from order_expansion 
order by 1,2
