
-- finding median ages 
select country, avg(age) as median_age 
from(select *,
row_number() over (partition by country order by age) as age_rnk
, cast (count(id) over (partition by country order by age range between unbounded preceding and unbounded following)as decimal) 
	 as cnt_age
from people) X
where age_rnk>= cnt_age/2 and age_rnk <= (cnt_age/2)+1
group by country 