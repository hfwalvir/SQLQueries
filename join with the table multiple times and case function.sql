Create table  practice.Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
Create table practice.Users (users_id int, banned varchar(50), role varchar(50));
Truncate table practice.Trips;
-- Insert data into Trips table in the "practice" database
INSERT INTO practice.Trips (id, client_id, driver_id, city_id, status, request_at)
VALUES 
    ('1', '1', '10', '1', 'completed', '2013-10-01'),
    ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01'),
    ('3', '3', '12', '6', 'completed', '2013-10-01'),
    ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01'),
    ('5', '1', '10', '1', 'completed', '2013-10-02'),
    ('6', '2', '11', '6', 'completed', '2013-10-02'),
    ('7', '3', '12', '6', 'completed', '2013-10-02'),
    ('8', '2', '12', '12', 'completed', '2013-10-03'),
    ('9', '3', '10', '12', 'completed', '2013-10-03'),
    ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');

-- Insert data into Users table in the "practice" database
INSERT INTO practice.Users (users_id, banned, role)
VALUES 
    ('1', 'No', 'client'),
    ('2', 'Yes', 'client'),
    ('3', 'No', 'client'),
    ('4', 'No', 'client'),
    ('10', 'No', 'driver'),
    ('11', 'No', 'driver'),
    ('12', 'No', 'driver'),
    ('13', 'No', 'driver');
select * from trips;
select * from users;

-- cancellation rate of requests with unbanned users

select request_at,count(case when status in ('cancelled_by_client','cancelled_by_driver') then 1 else null end), count(1) as total_trips 
,1.0*count(case when status in ('cancelled_by_client','cancelled_by_driver') then 1 else null end)/count(1)*100 as cancelled_percent
from trips t 
inner join users u 
on t.client_id = u.users_id
inner join users d on t.driver_id = d.users_id
where u.banned = 'No' and d.banned = 'No'
group by request_at;

