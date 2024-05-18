--in operator and exists operator


select customer_id, sum(revenue) as revenue 
from adobe_transactions
where customer_id IN (select distinct customer_id from adobe_transactions
where product = 'Photoshop')
and product != 'Photoshop'
group by cutomer_id
order by customer_id


--second solution (exists option)


select customer_id, sum(revenue) as revenue 
from adobe_transactions a
where exists (select 1 from adobe_transactions b
where product = 'Photoshop' and a.customer_id=b.customer_id)
and product != 'Photoshop'
group by cutomer_id
order by customer_id

