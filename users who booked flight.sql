
select * from booking_table
select * from User_table  
--first find all users who did some booking
select u.Segment, count(distinct u.user_id)as no_of_users
from 
user_table u
left join booking_table b on u.User_id = b.User_id
group by u.Segment

--users who booked flight in april 2022
select u.Segment, count(distinct u.user_id)as no_of_users,
count(distinct case when b.Line_of_business = 'Flight' and b.Booking_date between '2022-04-01' and '2022-04-30' then b.user_id else null end)  as users_who_booked_flight
from 
user_table u
left join booking_table b on u.User_id = b.User_id
group by u.Segment
--to find first booking for each user
select * from(
select * 
, rank() over (partition by user_id order by booking_date asc) as rn
 from booking_table)a
 where rn =1 and Line_of_Business = 'Hotel'

 --2nd method
 select distinct User_id from(
 select * 
 , first_value(Line_of_business) over (partition by user_id order by booking_date asc) as first_booking
 from booking_table) A
 where first_booking = 'Hotel'

 --days between first and last booking of each user
 select user_id,datediff(day,min(booking_date), max(booking_date)) as no_of_days
 from booking_table
 group by user_id

 --
select segment , sum(case when Line_of_business = 'Flight' then 1 else 0 end) as flight_bookings
 ,sum( case when Line_of_business = 'Hotel' then 1 else 0 end) as hotel_bookings
from booking_table b 
inner join user_table u on b.user_id = u.user_id 
group by segment 
