-- Identifying museums open on both Monday and Sunday
select m.name as museum_name, m.state as city from museum_hours mh1
join museum m on m.museum_id=mh1.museum_id
join museum_hours mh2 on mh1.museum_id=mh2.museum_id
where mh1.day='Sunday' and mh2.day='Monday' ;
-- Finding the museum open for maximum hours 
select * from ( 
select  m.name as museum_name, m.state , mh.day 
,  to_timestamp(open,'HH:MI AM') as open_time
,  to_timestamp(close,'HH:MI PM') as close_time
,  to_timestamp(close,'HH:MI PM') -  to_timestamp(open,'HH:MI AM') as duration
,  rank() over(order by (to_timestamp(close,'HH:MI PM') -  to_timestamp(open,'HH:MI AM')) desc) rnk
from museum_hours mh
join museum m on m.museum_id = mh.museum_id) x
where x.rnk =1 ;

-- Other way of writing the above
SELECT *
FROM (
    SELECT  
        m.name AS museum_name, 
        m.state, 
        mh.day,
        CAST(open AS TIME) AS open_time,
        CAST(close AS TIME) AS close_time,
        CAST(close AS TIME) - CAST(open AS TIME) AS duration,
        RANK() OVER (ORDER BY (CAST(close AS TIME) - CAST(open AS TIME)) DESC) AS rnk
    FROM museum_hours mh
    JOIN museum m ON m.museum_id = mh.museum_id
) x
WHERE x.rnk = 1;

-- Display the country and city with the most number of museums
with cte_country as 
		(select country, count(1) 
        , rank() over(order by count(1) desc ) as rnk
		from museum
		group by country),
	cte_city as 
        (select city, count(1) 
        , rank() over(order by count(1) desc ) as rnk
		from museum
		group by city)
select 
    (select group_concat(country) from cte_country where rnk =1 ) as country,
    (select group_concat(city) from cte_city where rnk =1 ) as city;


-- Fetch all the paintings which are not displayed on any museums?

select * from work where museum_id is NULL ;

-- 2) Are there museuems without any paintings?

select * from museum m
where not exists (select 1 from work w
				                     where m.museum_id = w.museum_id)
-- How many paintings have an asking price of more than their regular price?

select * from product_size; 