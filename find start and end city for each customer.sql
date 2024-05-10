select * from travel_data ; 

--find start and end city for each customer
with cte as(
select customer, start_loc as loc, 'start_loc' as column_name
from travel_data
union all
select customer, end_loc as loc, 'end_loc' as column_name
from travel_data)
, cte2 as(select * , count(*) over (partition by customer, loc) as cnt
from cte ) 
select customer, 
max(case when column_name = 'start_loc' then loc end) as starting_location
, max(case when column_name = 'end_loc' then loc end) as ending_location
from cte2 
where cnt = 1
group by customer 

-- 2nd method (self join)

select td.customer,
max(case when td1.end_loc is null then td.start_loc end) as starting_location
, max(case when td2.start_loc is null then td.end_loc end) as end_location

from travel_data td
left join travel_data td1 on td.customer = td1.customer and td.start_loc = td1.end_loc
left join travel_data td2 on td.customer = td2.customer and td.end_loc = td2.start_loc
group by td.customer


--


