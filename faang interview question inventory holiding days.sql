with wh as (
	select * from warehouse order by event_datetime desc),
     days as (
	 select onhandquantity, event_datetime, 
		 (event_datetime - interval '90 DAY')as day90
		 , (event_datetime - interval '180 DAY') as day180
		 , (event_datetime - interval '270 DAY') as day270
		 , (event_datetime - interval '365 DAY') as day365
	 from wh limit 1)
	 ,inventory90days as(
	 select sum(onhandquantitydelta) as DaysOld90
	 from wh 
	 cross join days as d
	 where event_type = 'InBound'
	 and wh.event_datetime >=  d.day90),
	 inv_90_days_final as 
	 (select case when DaysOld90 > d.onhandquantity then d.onhandquantity
	              else DaysOld90 
	         end DaysOld90
	  from inventory90days
	  cross join days d),
	  inv_180_days as(
	     select sum(onhandquantitydelta) as DaysOld180
		 from wh 
		 cross join days as d
		 where event_type = 'InBound'
		 and wh.event_datetime between d.day180 and d.day90)
	  ,inv_180_days_final as 
	  ( select case when DaysOld180 > (d.onhandquantity-DaysOld90) then (d.onhandquantity-DaysOld90)
	                else DaysOld180
	           end DaysOld180
	   from inv_180_days
	   cross join days d
	   cross join inv_90_days_final )
	   , inv_270days as
	   (select coalesce(squanitydelta) as DaysOld270
	   from wh
	   cross join days as d
	   where event_type = 'InBound'
	   and wh.event_datetime between d.day270d d.day180
	   , inv_270_days_final as(
	   )
select DaysOld90 as "0-90 days old"
, DaysOld180 as "91-180 days old"
from inv_90_days_final
cross join inv_180_days;


