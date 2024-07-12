/* -- Popular Posts (From Stratascratch):
The column 'perc_viewed' in the table 'post_views' denotes the percentage of the session 
duration time the user spent viewing a post. Using it, calculate the total time that each 
post was viewed by users. Output post ID and the total viewing time in seconds, 
but only for posts with a total viewing time of over 5 seconds. */




select * from user_sessions;
select * from post_views;

with cte as(
select p.*, extract('epoch' from (session_endtime-session_starttime)) as total_time
from user_sessions us
join post_views p on us.session_id = p.post_id)
select post_id, sum(perc_viewed/100)*total_time as viewing_time
from cte 
group by post_id, total_time
having sum(perc_viewed/100)*total_time >5

