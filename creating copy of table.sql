

select coalesce(o.order_id,c.order_id),
case when c.order_id is null then 'I'
when o.order_id is null then 'D' end as flag
from tbl_orders o
full outer join tbl_orders_copy c
on o.order_id = c.order_id
where c.order_id is null or o.order_id is null;

select * from tbl_orders_copy



