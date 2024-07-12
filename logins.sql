--consecutive logins
select * from user_login;

with cte as(
select * ,
dense_rank() over(partition by user_id order by user_id,login_date) 
, login_date - cast(dense_rank() over (partition by user_id order by user_id, login_date) 
					as int) as date_grp
from user_login)
select user_id, date_grp, count(1),
min(login_date) as start_date , max(login_date) as end_date
, max(login_date)- min(login_date)+1 as consecutive_days
from cte
group by user_id, date_grp
having max(login_date)- min(login_date)+1 >=5

-- for ms sql use dateadd and datediff function
