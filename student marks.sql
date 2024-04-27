-- whoever got more than average marks

with avg_cte as (
select subject, avg(marks) as avg_marks
from students
group by subject)
select s.*,ac.*
from students s
inner join avg_cte ac on s.subject = ac.subject
where s.marks > ac.avg_marks

-- more than 90 in any 1 subject 

select 
count(distinct case when marks > 90 then studentid else null end)*1.0/ count(distinct studentid) * 100 as perc
from students 

---- 2nd highest and 2nd lowest marks for each sub

select subject, sum(case when rnk_desc_order = 2 then marks else null end) as second_highest_marks
, sum (case when rnk_asc_order = 2 then marks else null end) as second_lowest_marks
from 
(
select subject, marks
, rank() over (partition by subject order by marks asc) as rnk_asc_order
, rank() over (partition by subject order by marks desc) as rnk_desc_order
from students)a
group by subject 

-- marks have increase dor decreased from the prev test

select * from students
order by studentid, testdate, subject

select * 
,case when marks > prev_marks then 'inc' 
when marks < prev_marks then 'dec'
else null end as status
from(
select * 
,lag(marks,1) over (partition by studentid order by testdate, subject) as prev_marks
from students) a