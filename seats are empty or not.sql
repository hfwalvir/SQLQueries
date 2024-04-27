-- lead lag 

select * from(select *
, lag(is_empty,1) over (order by seat_no) as prev_1
, lag(is_empty,2) over (order by seat_no) as prev_2
,lead(is_empty,1) over (order by seat_no) as next_1,
lead(is_empty,2) over (order by seat_no) as next_2
from bms) a
where is_empty = 'Y' and prev_1 = 'Y' and prev_2 = 'Y'
or (is_empty = 'Y' and prev_1 = 'Y' and next_1 = 'Y')
or (is_empty = 'Y' and next_1 = 'Y' and next_2 = 'Y');

--method 2 
-- advance aggregation
select * from (select *
, sum(case when is_empty= 'Y' then 1 else 0 end) over (order by seat_no rows between 2 preceding and current row) as prev_2
, sum(case when is_empty= 'Y' then 1 else 0 end) over (order by seat_no rows between 1 preceding and 1 following) as prev_next_2
, sum(case when is_empty= 'Y' then 1 else 0 end) over (order by seat_no rows between current row and 2 following) as next_2
from bms) a
where prev_2 = 3 or prev_next_2 = 3 or next_2 = 3

-- analytical row number function (method 3 )
with diff_num as(
select * , row_number() over (order by seat_no) as rn
, seat_no-row_number() over (order by seat_no) as diff
from bms
where is_empty = 'Y')
, cnt as(
select diff,count(1) as c from diff_num
group by diff having count(1) >=3)

select * from diff_num where diff in (select diff from cnt)

