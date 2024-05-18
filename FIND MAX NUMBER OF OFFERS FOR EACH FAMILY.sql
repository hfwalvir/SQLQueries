--FIND MAX NUMBER OF OFFERS FOR EACH FAMILY

select * from FAMILIES;
select * from COUNTRIES;
with cte as (
select f.ID, f.NAME
from families f
join countries as c
on (f.family_size = c.min_size or f.FAMILY_SIZE > c.min_size)
and (f.FAMILY_SIZE = c.Max_size or f.family_size<c.max_size))

select name, count(c.id) as numberofcountries
from cte c
group by name

