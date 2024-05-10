select * 
from employee_checkin;
select * from employee_details ;
-- normal life

with logins as(
select employeeid, count(*) as total_logins, max(timestamp_details) as latest_login
from employee_checkin
where entry_details = 'login'
group by employeeid)
, logouts as(
select employeeid, count(*) as total_logouts, max(timestamp_details) as latest_logouts
from employee_checkin
where entry_details = 'logout'
group by employeeid)
select a.employeeid, a.total_logins, a.latest_login, b.total_logouts, b.latest_logouts,
a.total_logins + b.total_logouts as totoalentry
from logins a 
inner join logouts b on a.employeeid = b.employeeid
left join employee_details c on a.employeeid = c.employeeid and c.isdefault = 'true'

-- shorter query
select a.employeeid, c.phone_number, count(*) as totalentry--count(*) as totalentry
, count(case when entry_details = 'login' then timestamp_details else null end) as total_logins
, count(case when entry_details = 'logout' then timestamp_details else null end) as total_logouts
, max(case when entry_details = 'login' then timestamp_details else null end) as max_login
, min(case when entry_details = 'logout' then timestamp_details else null end) as max_logout
from employee_checkin a
left join employee_details c on a.employeeid = c.employeeid and c.isdefault = 'true'
group by a.employeeid, c.phone_number

CREATE TABLE ed(
   employeeid   INTEGER  
  ,phone_number INTEGER  
  ,isdefault    VARCHAR(512) 
  ,added_on     DATE 
);
INSERT INTO ed(employeeid,phone_number,isdefault,added_on ) VALUES (1001,9999,'false','2023-01-01');
INSERT INTO ed(employeeid,phone_number,isdefault,added_on ) VALUES (1001,1111,'false','2023-01-02');
INSERT INTO ed(employeeid,phone_number,isdefault,added_on ) VALUES (1001,2222,'true','2023-01-03');
INSERT INTO ed(employeeid,phone_number,isdefault,added_on ) VALUES (1000,3333,'false','2023-01-02');
INSERT INTO ed(employeeid,phone_number,isdefault,added_on ) VALUES (1000,4444,'false','2023-01-02');

select * from (select *, 
row_number() over (partition by employeeid order by added_on desc) as rn
from ed
where isdefault ='false')A
where rn = 1

