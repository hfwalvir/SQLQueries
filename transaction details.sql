with cte as(
select 
transaction_date :: date as transaction_date,
sum(case when type = 'withdrawal' then -1*amount else amount end) as amount
from transactions
group by transaction_date :: date
order by transaction_date :: date);
select transaction_date,
sum(amount) over (partition by extract(year from transaction_date),extract(month from transaction_date) order by transaction_date) as cum_sum
from cte; 
