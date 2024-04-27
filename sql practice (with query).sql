-- finding out friends whose score is more than 100

select * from personn;
select * from friendd;

with score_details as (
select f.personid, sum(p.score) as total_friend_score, count(1) as no_of_friends 
from friendd f
inner join personn p on f.FriendID = p.PersonID
group by f.PersonID
having sum(p.score) > 100
)

select s.*, p.name as person_name 
from personn p
join score_details s on p.personid = s.personid


