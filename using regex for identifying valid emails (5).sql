-- Find length of comma seperated values in items field



select * from item;

--solution 1
select id, string_agg(length,',')
from (select id, length(unnest(string_to_array(items,',')))::varchar as length from item) s
group by id

--solution 2

select id, string_agg(s.lengths,',')
from item 
cross join lateral (select length(unnest(string_to_array(items,',')))::varchar as lengths) s
group by id
order by id