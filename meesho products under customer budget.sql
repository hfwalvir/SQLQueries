-- meesho productsss



select * from productsss;
select * from customer_budget ;

with running_cost as(
select*,
sum(cost) over (order by cost asc) as r_cost
from productsss)
select customer_id,budget,
 STRING_AGG(product_id,',') as list_of_products, count(customer_id) as no_of_products
from customer_budget cb 
left join running_cost rc on rc.cost < cb.budget
group by customer_id, budget; 

