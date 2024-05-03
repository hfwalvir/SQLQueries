select * from emp
select e.emp_id, e.emp_name, m.emp_name as manager_name, sm.emp_name snr_manager_name, m.salary as manager_salary
from emp e
left join emp m on e.manager_id = m.emp_id
left join emp sm on m.manager_id = sm.emp_id
where m.salary > sm.salary;

