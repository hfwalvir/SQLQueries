-- when did udaan start their operations in each of the new cities
with cte as(
select datepart(year, business_date) as business_year, city_id
from business_city)
select c1.business_year, count(distinct case when c2.city_id is null then c1.city_id end) as no_of_new_Cities
from cte c1
left join cte c2 on c1.business_year > c2.business_year and c1.city_id = c2.city_id
group by c1.business_year 


