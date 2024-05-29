select * from candidates;
select * from results;


with cte as (
select party, constituency_id, votes, candidate_id
, rank() over (partition by constituency_id order by votes desc) as rn
from candidates c 
join results r on r.candidate_id = c.id)

select concat(party,' ', count(1)) as party_seats_won
from cte
where rn=1
group by party


