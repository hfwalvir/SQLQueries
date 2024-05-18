select * from source
full join target 

select coalesce(s.id,t.id) as id, s.name, t.name,
case when t.name is null then 'new in source' 
when s.name is null then 'new in target' else 'mismatch' end as comment
from source s
full join target t on s.id = t.id
where s.name != t.name or s.name is null or t.name is null

--second method
(select id, 'new in source' as comment from source where id not in (select id from target))
union
(select id, 'new in target' as comment from target where id not in (select id from source))
union
(select s.id, 'mismatch' as comment from source s join target t on s.id = t.id and s.name != t.name)


