-- 


select * from people;
select * from relations;

--first method
with f as(
select r.c_id, p.name as mother_name
from 
relations r
inner join people p on r.p_id= p.id and gender = 'F') 
, m as(
select r.c_id, p.name as father_name
from 
relations r
inner join people p on r.p_id= p.id and gender = 'M')

select f.c_id as child_id,p.name as child_name, f.mother_name,m.father_name 
from
f 
inner join m on f.c_id = m.c_id
inner join people p on f.c_id = p.id


--second method

select max(r.c_id) as child_id,p.name as child_name, max(m.name) as mother_name, max(f.name) as father_name
from relations r 
left join people m on r.p_id = m.id and m.gender = 'F'
left join people f on r.p_id = f.id and f.gender = 'M'
inner join people p on r.c_id = p.id
group by r.c_id, p.name

-- third method
select r.c_id,pe.name as child_name, max(case when p.gender = 'F' then p.name end) as mother_name
,  max(case when p.gender = 'M' then p.name end) as father_name
from relations r
inner join people p on r.p_id = p.id
inner join people pe on r.c_id = pe.id
group by r.c_id, pe.name ; 
