--Linked In power creators(individual followers should  be beyond company followers)
with cte as(
select ec.personal_profile_id, cp.followers,cp.company_name,
max(cp.followers) as max_followers
from employee_company ec
inner join company_pages cp on ec.company_id = cp.company_id
group by ec.personal_profile_id)
select pp.profile_id
from personal_profiles pp
inner join cte on pp.profile_id = cte.personal_profile_id
where pp.followers> cte.max_followers;