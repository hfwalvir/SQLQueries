-- findign students with same marks in Physics and Chemistry
select * from exams; 

select student_id 
from exams
where subject in ('Chemistry','Physics')
group by student_id
having count(distinct subject) = 2 and count(distinct marks) = 1 

