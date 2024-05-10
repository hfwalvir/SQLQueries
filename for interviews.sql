-- top 3 products by sales, top 3 employees by salaries, within each category /department

select * from employee
--top 2 highest salaried employee

select top 2*
from employee
order by dept_id, salary desc

select * from(select * from
, row_number() over (partition by dept_id order by salary) as rn
, dense_rank() over (partition by dept_id order by salary) as rn_dense
from employee) a
where rn<= 2 

--for finding top 5 products
with cte as(
select category, sum(sales) as sales, product_id
from orders
group by category, product_id)
select * from (
select *,
row_number() over (partition by category order by sales desc) as rn
from cte) a
where rn <=5 


-- year on year growth with current yr sales more than previous year's sales
--lead/lag functions

select * from orders 

with cte as(
select category,year(order_date) as year_order, sum(sales) as sales
from orders 
group by category, year(order_date) )
,cte2 as(
select * 
, lag(sales,1, sales) over (partition by category order by year_order) as 
from cte) 

select (sales-prev_yr_sales)*100.0/prev_yr_sales as yoy
from cte2

--running/cummulative sales yr wise
select order_id, product_id, sales
from orders

with cte as(
select category,year(order_date) as year_order, sum(sales) as sales
from orders 
group by  category, year(order_date))

select * , sum(sales) over (partition by category order by year_order) as cumulative_sales
from cte 

--rolling 3 months sales  
with cte as(
select category,year(order_date) as year_order,month(order_date) as month_order_date, sum(sales) as sales
from orders 
group by  category, year(order_date))

select * , sum(sales) over (partition by category order by year_order,month_order_date 
rows between 2 preceding and current row) as cumulative_sales
from cte 

--pivoting - convert rows into column -- year wise each category sales

select year(order_date) as year_order,
category, 
sum(case when category = 'Furniture' then sales else 0 end) as fur_sales
, sum(case when category = 'Office Supplies' then sales else 0 end) as os_sales
, sum(case when category = 'Technology' then sales else 0 end) as tech_sales
from orders
group by year(order_date)
