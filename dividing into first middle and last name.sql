select * from customers;
with cte as(
select * ,
len(customer_name)-len(replace(customer_name,' ', '')) as no_of_spaces 
, charindex(' ', customer_name) as first_space_position
, charindex(' ', customer_name,charindex(' ', customer_name)+1) as second_space_position --it will start searching from the second name
from customers)
select *
, case when no_of_spaces = 0 then customer_name
else substring(customer_name,1,first_space_position-1)  
end as first_name
, case when no_of_spaces <=1 then null
else substring(customer_name, first_space_position+1,second_space_position-first_space_position-1)
end as middle_name,
case when no_of_spaces = 0 then null
when no_of_spaces = 1 then substring(customer_name, first_space_position+1, len(customer_name)-first_space_position)
when no_of_spaces = 2 then substring(customer_name, second_space_position+1, len(customer_name)-second_space_position)
end as last_name
from cte