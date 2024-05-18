--should have purchased for 2 days atleast
-- diff products on different days
select * from purchase_history;
with cte as(
select userid, count(distinct purchasedate) no_of_dates, count(productid) cnt_product,
count(distinct productid) no_of_products
from purchase_history
group by userid)
select * from cte
where no_of_dates >1 and cnt_product = no_of_products

-- second method

select userid, count(distinct purchasedate) as no_of_dates, count(productid) as cnt_product,
count(distinct productid) as no_of_dist_products
from purchase_history
group by userid
having  count(distinct purchasedate) > 1 and count(productid) = count(distinct productid)