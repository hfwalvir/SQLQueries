/*
PROBLEM STATEMENT:
Given table contains tokens taken by different customers in a tax office.
Write a SQL query to return the lowest token number which is unique to a customer (meaning token should be allocated to just a single customer).
*/



select token_num
from (select distinct * from tokens) t
group by token_num
having count(token_num) = 1
order by token_num
limit 1

