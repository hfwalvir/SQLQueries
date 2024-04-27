select * from transactions;
--how many customers are retained within a month
select month(this_month.order_date) as month_date, count(distinct last_month.cust_id)
from transactions this_month
left join transactions last_month
on this_month.cust_id = last_month.cust_id and datediff(month, last_month.order_date, this_month.order_date) = 1
group by month(this_month.order_date);

--customer_churn

select * from transactions;

select  
month(last_month.order_date) as month_date, count(distinct last_month.cust_id)
from transactions last_month
left join transactions this_month
on this_month.cust_id = last_month.cust_id and datediff(month, last_month.order_date, this_month.order_date) = 1
where month(last_month.order_date) = 1
and this_month.cust_id is null
group by month(last_month.order_date);

