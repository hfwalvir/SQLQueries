with cte as(
select * ,
left(formula,1)as d1, right(formula,1) as d2, substring(formula,2,1)as o 
from input) 
select cte.id, cte.value, cte.formula, ip1.value as d1_value, ip2.value as d2_value
, case when cte.o = '+' then ip1.value + ip2.value else ip1.value - ip2.value end as new_value
from cte 
inner join input ip1 on cte.d1 = ip1.id
inner join input ip2 on cte.d2 = ip2.id



