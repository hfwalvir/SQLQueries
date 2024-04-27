create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);
insert into customer_orders values(1,100,cast('2022-01-01' as date),2000);
insert into customer_orders values (2,200,cast('2022-01-01' as date),2500);
insert into customer_orders values(3,300,cast('2022-01-01' as date),2100);
insert into customer_orders values(4,100,cast('2022-01-02' as date),2000);
insert into customer_orders values(5,400,cast('2022-01-02' as date),2200);
insert into customer_orders values(6,500,cast('2022-01-02' as date),2700); 
insert into customer_orders values (7,100,cast('2022-01-03' as date),3000);
insert into customer_orders values (8,400,cast('2022-01-03' as date),1000);
insert into customer_orders values (9,600,cast('2022-01-03' as date),3000);

with first_visit as (
select customer_id, min(order_date) as first_visit_date
from customer_orders
group by customer_id)
(select co.order_date,
 sum(CASE WHEN co.order_date = fv.first_visit_date then 1 else 0 end) as first_visit_flag
,sum(CASE WHEN co.order_date != fv.first_visit_date then 1 else 0 end) as repeat_visit_flag
from customer_orders co
inner join first_visit fv on co.customer_id = fv.customer_id
group by co.order_date		
order by co.order_date);



