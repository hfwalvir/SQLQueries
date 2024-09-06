create table numbers (n int);
insert into numbers values (1),(2),(3),(4),(5)
insert into numbers values (9)

select * from numbers

-- without Recursive cte question


select * from numbers

-- With recursive cte 
with cte as (
select n, 1 as num_counter from numbers
union all
select n, num_counter+1 
from cte
where num_counter + 1<= n)

select n from cte
order by n

--without Recursive

select n1.n, n2.n from numbers n1
inner join numbers n2 on n1.n >= n2.n
order by n1.n, n2.n


-- to get the 9 values for 9 
with cte1 as(
select max(n) as n from numbers
union all
select n-1 from cte1
where n-1>= 1) 


select n1.n, n2.n from numbers n1
inner join cte1 n2 on n1.n >= n2.n
order by n1.n, n2.n


--without recursive for finding numbers until 9

with cte2 as(
select row_number() over (order by (select null)) as n
from sys.all_columns)
select n1.n, n2.n 
from numbers n1
inner join cte2 n2 on n1.n>= n2.n
where n2.n <= (select max(n) from numbers)
order by n1.n, n2.n

