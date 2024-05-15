select * from Ameriprise_LLC;


--first type of solution
with qualified_team as (
select teamID, count(1) as no_of_eligible_members
from Ameriprise_LLC
where Criteria1='Y' and Criteria2 = 'Y'
group by teamID
having count(1) >=2)

select al.*,qt.*,
case when Criteria1 = 'Y' and Criteria2 = 'Y' and qt.teamID is not null then 'Y' else 'N' end as qualified_flag
from Ameriprise_LLC al
left join qualified_team qt on al.teamID = qt.teamID

--second solution

select al.*,
case when Criteria1='Y' and Criteria2='Y' and
sum(case when Criteria1 = 'Y' and Criteria2 = 'Y' then 1 else 0 end) over (partition by teamID)>=2 then 'Y' else 'N' end as qualified_flag
from Ameriprise_LLC al

