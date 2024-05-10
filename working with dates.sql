

select * from sku;
-- get price for the first of each month
--for months for which I have got the price (1st of the month)

with cte as(
select * ,
row_number() over (partition by sku_id, year(price_date) ,month(price_date) order by price_date desc) as rn 
from sku)
select sku_id, datetrunc(month,dateadd(month,1,price_date)) as next_mont, price 
from cte
where rn = 1 and datetrunc(month,dateadd(month,1,price_date)) not in (select price_date, datepart(day,price_date)
from sku
union all
select sku_id,price_date,price, datepart(day,price_date)
from sku
where datepart(day,price_date) = 1


-- usig calendar table
with cte as(
select * 
 , isnull(dateadd(day,-1,lead(price_date,1) over (partition by sku_id order by price_date)),dateadd(month,1,price_date)) as valid_till
 from sku)
select sku_id, c.cal_date,price 
from cte
inner join calender_dim c on c.cal_date between cte.price_date and cte.valid_till
where c.cal_month_day = 1

