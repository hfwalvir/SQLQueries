
select * from customer_orders;

with first_order as(
select customer_id, min(order_date) as first_order_date
from customer_orders
group by customer_id)

select co.order_date
, sum(case when co.order_date = first_order_date then co.order_amount else 0 end) as first_visit_flag
, sum(case when co.order_date!=first_order_date then co.order_amount else 0 end) as repeat_visit_flag
from customer_orders co
inner join first_order fo on co.customer_id = fo.customer_id 
group by co.order_date
