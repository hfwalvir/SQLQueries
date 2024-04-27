
--using 10 - sum of all quarters by store
select store, 'Q' + cast (10-sum(cast(right(quarter,1) as int)) as char(2)) as q_no
from stores
group by store;

--  using recursive_cte 
with r_cte as 
(
		select distinct store, 1 as q_no
		from stores 
		union all
		select store, q_no+1 as q_no
		from r_cte
		where q_no <4
)
, q as(select store, 'Q' + cast(q_no as char(1)) as q_no from r_cte) 

select q.*
from q
left join stores s on q.store = s.store and q.q_no = s.Quarter
where s.store is null

--3rd solution (using cross join)
with cte as(
select distinct s1.store, s2.quarter
from stores s1, stores s2)
select q.* 
from cte q
left join stores s on q.store = s.store and q.quarter = s.quarter
where s.store is null; 

