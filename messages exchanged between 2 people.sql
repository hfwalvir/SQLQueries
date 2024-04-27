select sms_date, p1,p2, sum(sms_no) as total_sms from
(select sms_date
, case when sender<receiver then sender else receiver end as p1
, case when sender>receiver then sender else receiver end as p2 
, sms_no 
from subscriber) a 
group by sms_date, p1,p2;
