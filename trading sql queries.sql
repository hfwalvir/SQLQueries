-- same stock trade between 10 seconds and having price different more than 10%
--output must also list the percentage difference 
select t1.TRADE_ID ,t2.TRADE_ID,t1.Trade_Timestamp,t2.Trade_Timestamp, t1.price, t2.price,
abs(t1.Price-t2.Price)*1.0/t1.Price * 100 Percentage_diff
from Trade_tbl t1
inner join Trade_tbl t2 on 1=1
where t1.Trade_Timestamp < t2.Trade_Timestamp and DATEDIFF(second,t1.Trade_Timestamp, t2.Trade_Timestamp) < 10 and
abs(t1.Price-t2.Price)*1.0/t1.Price * 100 > 10
order by t1.TRADE_ID 
