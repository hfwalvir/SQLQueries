select * from billings;
select * from HoursWorked;
with date_range as(
select * , lead(dateadd(day,-1,bill_date),1,'9999-12-31') over (partition by emp_name order by bill_date asc) as bill_date_end
from
billings)
select hw.emp_name , sum(dr.bill_rate*hw.bill_hrs) 
from date_range dr
inner join HoursWorked hw on hw.emp_name = dr.emp_name 
and hw.work_date between dr.bill_date and dr.bill_date_end
group by hw.emp_name;