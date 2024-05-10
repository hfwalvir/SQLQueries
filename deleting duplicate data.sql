-- How to delete duplicate data

select emp_id, min(create_timestamp) as create_timestamp
from employee
group by emp_id 
having count(1) > 1

delete from employee where (emp_id,create_timestamp) 
in (select emp_id, min(create_timestamp) as create_timestamp
from employee
group by emp_id 
having count(1) > 1)


-- for 2 same records
delete from employee where emp_id = 1l

--create backup table
create table employee_back as select * from employee


insert into employee select distinct * from employee_back

--another way (for removing duplicate salaries)

insert into employee
select emp_id, emp_name, salary, create_timestamp from (
select *
, row_number() over (partition by emp_id order by salary) as rn 
from employee_back) x 
where rn = 1


-- based on latest timestamp
insert into employee
select emp_id, emp_name, salary, create_timestamp from (
select *
, row_number() over (partition by emp_id order by create_timestamp desc) as rn 
from employee_back) x 
where rn = 1


-- run it twice 
delete from employee where (emp_id,create_timestamp) 
not in (select emp_id, max(create_timestamp) as create_timestamp
from employee
group by emp_id 
having count(1) > 1) ;

