-- all the consecutive available seats

select * from cinema;

--method 1 
with cte as(
select * ,
row_number() over (order by seat_id) as rn,
seat_id - row_number() over (order by seat_id) as grp

from cinema
where free = 1)
select * from(
select *,count(*) over (partition by grp) as cnt
from cte) A
where cnt>1

--method 2 

with cte as(
select c1.seat_id as s1, c2.seat_id as s2 from cinema c1
inner join cinema c2 on c1.seat_id+ 1 = c2.seat_id
where c1.free = 1 and c2.free = 1)
select s1 from cte
union
select s2 from cte

--method 3 
select * from (
select *, lag(free,1) over (order by seat_id) as prev_free
, lead(free,1) over (order by seat_id) as next_free
from cinema) A
where free = 1 and (prev_free=1 or next_free =1)






