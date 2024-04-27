 select * from orders;
select * from products;

-- history of ecommerce website can recommend products to new user.


select  pr1.name +' '+ pr2.name as pair  , count(1) as purchase_freq 
from orders o1
inner join orders o2 on o1.order_id = o2.order_id
inner join products pr1 on pr1.id = o1.product_id
inner join products pr2 on pr1.id = o2.product_id
where o1.product_id<o2.product_id
group by  pr1.name , pr2.name;
