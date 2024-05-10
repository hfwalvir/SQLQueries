-- 
with cte as(
select supplier_id, product_id, record_date 
,lag(record_date,1) over (partition by supplier_id, product_id order by record_date) as prev_record_date
, datediff(day,lag(record_date,1) over (partition by supplier_id, product_id order by record_date), record_date) as daydiff
from stock
where stock_quantity <50)
, cte2 as(
select *, case when daydiff <= 1 then 0 else 1 end as group_flag
, sum(case when daydiff <= 1 then 0 else 1 end) over (partition by supplier_id, product_id order by record_date) as group_id
from cte) 
select supplier_id, product_id, group_id, count(*) as no_pf_records, min(record_date) as first_date
from cte2
group by supplier_id, product_id, group_id

