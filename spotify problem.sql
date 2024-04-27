

select * from activity;

--total active users each day
select datepart(week,event_date) as week, count(distinct user_id) as no_of_users
from activity a 
group by datepart(week,event_date)

--installed and purchased the app on the same day
select event_date, count(new_user) as no_of_users from (
select user_id, event_date,case when count(distinct event_name)=2 then user_id else null end as new_user 
from activity
group by user_id , event_date ) x
group by event_date;

--percentage fo paid users in India, us and any other country
with country_users as (select case when country in ('USA','India') then country else 'others' end as new_country, count(distinct user_id) as user_cnt
from activity
where event_name = 'app-purchase'
group by case when country in ('USA','India') then country else 'others' end)
,total as (select sum(user_cnt) as total_users from country_users)

select new_country, user_cnt*1.0/total_users*100 as perc_users
from country_users,total

-- app installed first and then purchased
with prev_data(
select *, lag(event_name, 1) over (partition by user_id order by event_date) as prev_event_name 
,lag(event_date, 1) over (partition by user_id order by event_date) as prev_event_date 
from activity)  
select event_date, count(distinct user_id) as cnt_users 
from prev_data
where event_name ='app-purchase' and prev_event_name = 'app-installed' and datediff(day,prev_event_date,event_date) = 1
group by event_date;
