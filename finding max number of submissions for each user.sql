--
with cte as(
select submission_date, hacker_id, count(*) as no_of_submissions
, DENSE_RANK() over (order by submission_date) as day_number
from Submissions
group by submission_date, hacker_id)
, cte2 as(
select * , 
count(*) over(partition by hacker_id order by submission_date) as till_date_submissions,
case when day_number = count(*) over(partition by hacker_id order by submission_date) then 1 else 0 end as unique_flag
from cte)
,cte3 as(
select * , sum(unique_flag) over (partition by submission_date) as unique_count,
row_number() over (partition by submission_date order by no_of_submissions desc, hacker_id asc ) as rn
from cte2)
select submission_date, hacker_id, unique_count, no_of_submissions
from cte3
where rn =1
order by submission_date, hacker_id





