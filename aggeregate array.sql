
select 
cast(sum(factorial(cnt) / factorial(cnt -2) * factorial(2))as int )as matching_airbnb
from(
select amenity_list, count(rental_id) as cnt
from(
select rental_id, array_agg(amenity) as amenity_list
from rental_amenities
group by rental_id 
order by amenity_list) A
group by amenity_list
having count(rental_id) > 1) B


