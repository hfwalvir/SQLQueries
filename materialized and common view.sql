select * from orders ; 

-- create simple view
create view vw_orders as 
select o.*,r.return_date
from orders o 
left join returns r on o.order_id = r.order_id

select * from vw_orders

-- create materliazed views ( used for 

create materialized view mat_orders as 
select o.*,r.return_date
from orders o 
left join returns r on o.order_id = r.order_id
     with no data 
	 
select * from mat_orders;
drop materialized view mat_orders
refresh materialized view mat_orders

--FOR UPDATING THE DATA REGULARLY IN THE MAT VIEW 
ALTER MATERIALIZED VIEW mat_orders SET AUTOFRESH