
 select max(cnt) from (
select f.name, count(*) as cnt
from families f
inner join COUNTRIES C on f.FAMILY_SIZE between c.MIN_SIZE and c.MAX_SIZE
group by f.name) a


