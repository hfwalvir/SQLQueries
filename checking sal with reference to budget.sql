Create table candidates(
id int primary key,
positions varchar(10) not null,
salary int not null);

-- test case 1:
insert into candidates values(1,'junior',5000);
insert into candidates values(2,'junior',7000);
insert into candidates values(3,'junior',7000);
insert into candidates values(4,'senior',10000);
insert into candidates values(5,'senior',30000);
insert into candidates values(6,'senior',20000);

with running_cte as(
select * , 
sum(salary) over (partition by positions order by salary asc, id) as running_sal
from candidates)
, senior as(
select count(*) as seniorss, sum(salary) as snr_sal
from running_cte 
where positions = 'senior'
and running_sal <= 50000)
, juniors as(
select count(*) as juniorss
from running_cte 
where positions = 'junior'
and running_sal <=50000 -(select snr_sal from senior))
select juniorss, seniorss
from juniors, senior


--test case 2 
insert into candidates values(20,'junior',10000);
insert into candidates values(30,'senior',15000);
insert into candidates values(40,'senior',30000)

select *
from candidates ; 
with running_cte as(
select * , 
sum(salary) over (partition by positions order by salary asc, id) as running_sal
from candidates)
, senior as(
select count(*) as seniorss, sum(salary) as snr_sal
from running_cte 
where positions = 'senior'
and running_sal <= 50000)
, juniors as(
select count(*) as juniorss
from running_cte 
where positions = 'junior'
and running_sal <=50000 -(select snr_sal from senior))
select juniorss, seniorss
from juniors, senior

-- test case 3:
delete from candidates;
insert into candidates values(1,'junior',15000);
insert into candidates values(2,'junior',15000);
insert into candidates values(3,'junior',20000);
insert into candidates values(4,'senior',60000);

with running_cte as(
select * , 
sum(salary) over (partition by positions order by salary asc, id) as running_sal
from candidates)
, senior as(
select count(*) as seniorss, coalesce(sum(salary),0) as snr_sal
from running_cte 
where positions = 'senior'
and running_sal <= 50000)
, juniors as(
select count(*) as juniorss
from running_cte 
where positions = 'junior'
and running_sal <=50000 -(select snr_sal from senior))
select juniorss, seniorss
from juniors, senior

--test case 4:
delete from candidates
insert into candidates values(10,'junior',10000);
insert into candidates values(40,'junior',10000);
insert into candidates values(20,'senior',15000);
insert into candidates values(30,'senior',30000);
insert into candidates values(50,'senior',15000);

with running_cte as(
select * , 
sum(salary) over (partition by positions order by salary asc, id) as running_sal
from candidates)
, senior as(
select count(*) as seniorss, coalesce(sum(salary),0) as snr_sal
from running_cte 
where positions = 'senior'
and running_sal <= 50000)
, juniors as(
select count(*) as juniorss
from running_cte 
where positions = 'junior'
and running_sal <=50000 -(select snr_sal from senior))
select juniorss, seniorss
from juniors, senior