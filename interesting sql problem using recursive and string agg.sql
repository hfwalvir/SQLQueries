with recursive cte as
               (select * , 1 as iter, max(idx) over() as max_idx
				from cte_values
				where idx = 1
			    union
			    select cv.*,(iter+1), max(cv.idx) over() as max_idx
				from cte
				join cte_values cv on cv.idx between max_idx + 1 and max_idx+1+iter 
					  
),
cte_values as()
select x.*
from arbitrary_values
cross join unnest(string_to_array(val,',')) with ordinality x(val,idx))

select iter as grp ,string_agg(val,',') as val from cte
group by iter order by iter;