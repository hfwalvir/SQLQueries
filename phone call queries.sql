--last and first call was to the same person
with calls as(
select Callerid, cast(datecalled as date) as called_date,
min(datecalled) as first_call
,max(datecalled) as last_call
from phonelog
group by callerid, cast(datecalled as date))
select c.* , p1.Recipientid as first_rec, p2.Recipientid as last_rec
from calls c
inner join phonelog p1 on c.Callerid = p1.Callerid and c.first_call = p1.datecalled
inner join phonelog p2 on c.Callerid = p2.Callerid and c.last_call = p2.datecalled
where p1.Recipientid = p2.Recipientid
