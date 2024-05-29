-- Advertising System Deviations report ---

-- DATASET

select * from customers;
select * from campaigns;
select * from eventss;


with cte as(
select concat(first_name,' ',last_name) as customer, 
string_agg(distinct name,',') as campaign, ev.status as event_type,
count(1) as total,
rank() over (partition by status order by count(1) desc) as rnk
from customers cst 
join campaigns cmp on cmp.customer_id = cst.id
join eventss ev on ev.campaign_id = cmp.id
join cte on cmp.customer_id = cte.id
group by concat(first_name,' ',last_name) , status
order by status, total desc)

select event_type,customer,campaign,total
from cte where rnk =1 
order by event_type desc




