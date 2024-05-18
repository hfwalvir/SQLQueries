--find words repeating more than once

select value as word, count(*) as count_of_word
from namaste_python 
cross apply string_split(content,' ')
group by value
having count(*) > 1
order by count_of_word desc



