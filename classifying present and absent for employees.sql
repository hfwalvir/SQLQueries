--classsifying absence and presence for employees
with cte as(
SELECT * ,
row_number() over (partition by employee order by employee,dates) as rn
from emp_attendance)
, cte_present as(
select *,rn-row_number() over (partition by employee order by employee,dates) as flag
from cte
where status = 'PRESENT' )
, cte_absent as(
select *,rn-row_number() over (partition by employee order by employee,dates) as flag
from cte
where status = 'ABSENT' )

select employee,
first_value(dates) over(partition by employee, flag order by employee,dates) as from_date
, last_value(dates) over(partition by employee, flag order by employee,dates
                         range between unbounded preceding and unbounded following) as to_date
, status
from cte_present
union
select employee,
first_value(dates) over(partition by employee, flag order by employee,dates) as from_date
, last_value(dates) over(partition by employee, flag order by employee,dates
                         range between unbounded preceding and unbounded following) as to_date
, status
from cte_absent
order by employee, from_date

