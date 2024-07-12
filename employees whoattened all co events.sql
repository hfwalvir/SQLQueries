

select * from employees;
select * from events;

select em.name, count(distinct event_name)
from events e
inner join employees em on em.id = e.emp_id
group by em.name, e.emp_id
having count(distinct event_name) = (select count(distinct event_name) from events)
order by emp_id