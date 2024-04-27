declare @today_date date;
declare @n int;
set @today_date = '2022-01-01' ;--sat 
set @n = 3; --nth week 
--1 is sunday
select dateadd(week, @n,dateadd(day,8 -datepart(weekday,@today_date),@today_date))



