--printing names of stars
select * from movies
select * from reviews;

with cte as(
select m.genre, m.title,avg(r.rating) as avg_rating,
row_number() over (partition by m.genre order by avg(r.rating) desc) as rn
from movies m 
inner join reviews r on m.id = r.movie_id
group by m.genre,m.title)

select genre,title,round(avg_rating,0) as avg_rating,
REPLICATE('*',round(avg_rating,0)) as stars
from cte 
where rn = 1
