select * from users;
select * from events;

select count(distinct u.user_id) as total_users, count(distinct case when  datediff(day, u.join_date, e.access_date)<=30 then u.user_id end) as no_of_subscribed
,1.0* count(distinct case when  datediff(day, u.join_date, e.access_date)<=30 then u.user_id end)/count(distinct u.user_id)*100 as percentage
from users u 
left join events e on u.user_id = e.user_id and e.type = 'P'
where u.user_id in (select user_id from events where type = 'Music')