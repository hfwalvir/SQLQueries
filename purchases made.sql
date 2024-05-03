--find users who did not purchase the same product on a different date
select * from purchase_history;
with cte as(
select userid, count(distinct purchasedate) no_of_dates_of_purchase , count(productid) cnt_product, 
count(distinct productid) count_distinct_pdt
from purchase_history
group by userid )
select * from cte
where no_of_dates_of_purchase > 1 and cnt_product = count_distinct_pdt; 
--different method
select userid, count(distinct purchasedate) no_of_dates_of_purchase , count(productid) cnt_product, 
count(distinct productid) count_distinct_pdt
from purchase_history
group by userid 
having count(distinct purchasedate) > 1 and count(productid) = count(distinct productid)