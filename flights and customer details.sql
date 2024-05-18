
select * from flights 

select o.cid, o.origin,d.Destination as final_destination
from flights o
inner join flights d on o.Destination = d.origin


--2nd problem (first visit of any customer)
select order_date,count(distinct customer) as count_new_cust from
(
select *,
row_number() over (partition by customer order by order_date) as rn
from saless) a
where rn = 1
group by order_date
