select * from studentss;
select * from examss; 



with all_scores as(
select exam_id, min(score) as min_score, max(score) as max_score
from examss 
group by exam_id)
select examss.student_id
from examss
inner join all_scores on examss.exam_id = all_scores.exam_id
group by examss.student_id 
having max(case when score = min_score or score=max_score then 1 else 0 end) = 0


