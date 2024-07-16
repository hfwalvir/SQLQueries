


select * from feedback
where email like '[a-zA-Z]%@[a-zA-Z]%.[a-zA-Z]%'
and email not like '%[@#]%@[a-zA-Z]%.[a-zA-Z]%'
and charindex('.',reverse(email)) between 3 and 4;

