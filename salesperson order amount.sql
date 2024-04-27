--finding largest order for salesperson without using subquery, cte, window functions and temp_tables
select * from [int_orders] a
select a.order_number, a.order_date, a.salesperson_id,a.amount
from [int_orders] a
left join [int_orders] b 
on a.salesperson_id = b.salesperson_id
group by a.order_number, a.order_date, a.salesperson_id,a.amount
having a.amount >= max(b.amount); 



