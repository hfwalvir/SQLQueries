-- finding 4 consecutive empty seats in a movie hall
with cte1 as(
select *
, left(seat,1) as row_id, cast(substring(seat,2,2) as int) as seat_id
from movie)
,cte2 as (
select * 
, max(occupancy) over (partition by row_id order by seat_id rows between current row and 3 following) as is_4_empty
, count(occupancy) over (partition by row_id order by seat_id rows between current row and 3 following) as count_4_empty
from cte1)
, cte3 as (
select * from cte2 where is_4_empty =0 and count_4_empty = 4)
select cte2.* 
from cte2
inner join cte3 on cte2.row_id = cte3.row_id and cte2.seat_id between cte3.seat_id and cte3.seat_id + 3

