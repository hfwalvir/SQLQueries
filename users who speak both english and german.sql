-- google interview question
-- find companies who have atleast 2 users who speak eng and german both

select * from company_users; 
select company_id, count(1) from(
select 
company_id, user_id
from company_users
where language in ('English', 'German')  
group by company_id , user_id
having count(1) = 2) x

group by company_id 
having count(1)>= 2 
