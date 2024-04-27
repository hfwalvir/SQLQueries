select * from buy;
select * from sell;

with running_sum_values as (
select buy.time as buy_time, buy.qty as buy_qty , sell.qty as sell_qty
, sum(buy.qty) over (order by buy.time) as r_buy_qty
,  isnull(sum(buy.qty) over (order by buy.time rows between unbounded preceding and 1 preceding),0) as r_buy_qty_prev
from buy
inner join sell on buy.date = sell.date and buy.time = sell.time)
select buy_time,
case when sell_qty >= r_buy_qty then buy_qty
else sell_qty-r_buy_qty_prev end as sell_qty
from running_sum_values