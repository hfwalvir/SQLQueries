-- both client nd driver must not be banned
select * from trips ;
select * from usersss ;

select request_at, count(case when status in ('cancelled_by_driver','cancelled_by_client') then 1 else null end)  as cancelled_trip_cnt
, count(1) as total_trips
, round(1.0*count(case when status in ('cancelled_by_driver','cancelled_by_client') then 1 else null end) /count(1) * 100,2) as percent_cancelled
from trips t
inner join usersss c on t.client_id = c.users_id
inner join usersss d on t.driver_id = d.users_id
where c.banned = 'No' and d.banned = 'No' 
group by request_at

