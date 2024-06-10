--Database Case Sensitivity vs Insensitivity

-- Database Case Insensitivity
with cte as(
select * ,ASCII(email_id) as ascii_value,
rank() over (partition by email_id order by ASCII(email_id) desc) as rn
from employees)
--where email_id = LOWER(email_id))


select * from cte where rn =1
--with added Case Sensitivity
ALTER TABLE employees
ALTER COLUMN email_id VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CS_AS; -- CS MEANS CASE SENSITIVE

select * , LOWER(email_id) as l_email_id
from employees
where email_id = LOWER(email_id) 

with cte as(
select * ,ASCII(email_id) as ascii_value,
row_number() over (partition by lower(email_id) order by ASCII(email_id) desc) as rn
from employees)

select * from cte
where rn = 1

select * from employees