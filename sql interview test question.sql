select * from users
select * from logins

-- 1) Mgt wants to see all the users that did not login in the past 5 months
-- return: username
select user_id, max(login_timestamp), DATEADD(MONTH,-5,GETDATE())
from logins
group by user_id 
having max(login_timestamp) < DATEADD(MONTH,-5,GETDATE())

-- 2nd method 
select distinct user_id from logins where user_id not in(
select user_id
from logins
where login_timestamp > DATEADD(MONTH,-5,GETDATE()))

--2)  For each quarter, how many logins and how many sessions

-- output : 1st day of the quarter, user_cnt, session_cnt

select datepart(quarter,login_timestamp) as quarter_number, count(*) as total_sessions, count(distinct user_id) as no_of_users
, min(login_timestamp) as quarter_first_login, DATETRUNC(quarter, min(login_timestamp) ) as first_quarter_date
from logins
group by datepart(quarter,login_timestamp)

--3)  display user ids logged in jan 2024 and did not log in in nov 2023
-- return user_id

select distinct user_id
from logins
where LOGIN_TIMESTAMP between '2024-01-01' and '2024-01-31'
and user_id not in (select user_id
from logins
where LOGIN_TIMESTAMP between '2023-11-01' and '2023-11-30') 



-- 4) add to the 2nd query percent change from last quarter
-- first day of the quarter, session cnt , session cnt prev, session percent change

with cte as( 
select datetrunc(quarter,min(login_timestamp)) as first_quarter_date
, count(*) as session_cnt,
count(distinct user_id) as user_cnt
from logins
group by datepart(quarter, login_timestamp))
select *, lag(session_cnt) over (order by first_quarter_date) as prev_session_cnt,
(session_cnt - lag(session_cnt) over (order by first_quarter_date))*100.0 / lag(session_cnt) over (order by first_quarter_date) as percentage_change
from cte

--5) higher session score for each day
-- return : date, username, score
with cte as(
select user_id, cast(login_timestamp as date) as login_date, sum(session_score) as score
from logins
group by user_id, cast(login_timestamp as date))

select * from(
select * ,
row_number() over (partition by login_date order by score desc) as rn
from cte )a
where rn = 1 

--6) to identify best users , return users that had a session on every single day since their first login
-- return user_id alone

select user_id, min(CAST(LOGIN_TIMESTAMP as date)) as first_login,
datediff(day, min(CAST(LOGIN_TIMESTAMP as date)), getdate())+1 as no_of_login_days_required,
count(distinct cast(LOGIN_TIMESTAMP as date)) as no_of_login_days
from logins
group by user_id
having datediff(day, min(CAST(LOGIN_TIMESTAMP as date)), getdate())+1 = count(distinct cast(LOGIN_TIMESTAMP as date))
order by user_id


-- 7) on what dates there are no logins at all
-- 15 july 2023 to 20 june 2024
select cast(min(login_timestamp) as date) as first_date, cast(getdate() as date) as last_date
from logins

select cal_date from cal_dim_new c
inner join (select cast(min(login_timestamp) as date) as first_date, cast(getdate() as date) as last_date
from logins) a on c.cal_date between first_date and last_date
where cal_date not in 
(select distinct cast((login_timestamp) as date) from logins)

--2nd method
with cte as(
select cast(min(login_timestamp) as date) as first_date, cast(getdate() as date) as last_date
from logins
union all
select dateadd(day,1,first_date) as first_date, last_date
from cte
where first_date < last_date
)

select first_date from cte
where first_date not in (select distinct cast((login_timestamp) as date) from logins)
option (maxrecursion 500)


