--likdd by friend but not by user itself yet 

select * from likes;
select * from friends;




select f.user_id, l.page_id
from friends f
inner join likes l on f.friend_id = l.user_id 
where CONCAT(f.user_id,l.page_id) not in (
select distinct CONCAT(f.user_id,l.page_id) as concat_columns
from friends f inner join likes l on 
f.user_id = l.user_id)
group by f.user_id, l.page_id

