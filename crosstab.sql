--- Q7 : Derive the output --- 

drop table sales_data;
create table sales_data
    (
        sales_date      date,
        customer_id     varchar(30),
        amount          varchar(30)
    );
insert into sales_data values ('01-Jan-2021', 'Cust-1', '50$');
insert into sales_data values ('02-Jan-2021', 'Cust-1', '50$');
insert into sales_data values ('03-Jan-2021', 'Cust-1', '50$');
insert into sales_data values ('01-Jan-2021', 'Cust-2', '100$');
insert into sales_data values ('02-Jan-2021', 'Cust-2', '100$');
insert into sales_data values ('03-Jan-2021', 'Cust-2', '100$');
insert into sales_data values ('01-Feb-2021', 'Cust-2', '-100$');
insert into sales_data values ('02-Feb-2021', 'Cust-2', '-100$');
insert into sales_data values ('03-Feb-2021', 'Cust-2', '-100$');
insert into sales_data values ('01-Mar-2021', 'Cust-3', '1$');
insert into sales_data values ('01-Apr-2021', 'Cust-3', '1$');
insert into sales_data values ('01-May-2021', 'Cust-3', '1$');
insert into sales_data values ('01-Jun-2021', 'Cust-3', '1$');
insert into sales_data values ('01-Jul-2021', 'Cust-3', '-1$');
insert into sales_data values ('01-Aug-2021', 'Cust-3', '-1$');
insert into sales_data values ('01-Sep-2021', 'Cust-3', '-1$');
insert into sales_data values ('01-Oct-2021', 'Cust-3', '-1$');
insert into sales_data values ('01-Nov-2021', 'Cust-3', '-1$');
insert into sales_data values ('01-Dec-2021', 'Cust-3', '-1$');


select * from sales_data;



with pivot_data as (
    select * 
    from crosstab(
        'select customer_id ,
                to_char(sales_date, ''Mon-YY'') as month,
                sum(replace(amount, ''$'', '''')::int) as amount
         from sales_data
         group by customer_id, to_char(sales_date, ''Mon-YY'')
         order by customer_id',
         'values (''Jan-21''), (''Feb-21''), (''Mar-21''), (''Apr-21''),
                (''May-21''), (''Jun-21''), (''Jul-21''), (''Aug-21''),
                (''Sep-21''), (''Oct-21''), (''Nov-21''), (''Dec-21'')'
    ) AS (customer_id varchar, Jan_21 bigint, Feb_21 bigint, Mar_21 bigint,
                      Apr_21 bigint, May_21 bigint, Jun_21 bigint, Jul_21 bigint,
                      Aug_21 bigint, Sep_21 bigint, Oct_21 bigint, Nov_21 bigint, Dec_21 bigint)
    UNION
    select * 
    from crosstab(
        'select ''Total'' as customer_id,
                to_char(sales_date, ''Mon-YY'') as month,
                sum(replace(amount, ''$'', '''')::int) as amount
         from sales_data
         group by to_char(sales_date, ''Mon-YY'')
         order by 1',
         'values (''Jan-21''), (''Feb-21''), (''Mar-21''), (''Apr-21''),
                (''May-21''), (''Jun-21''), (''Jul-21''), (''Aug-21''),
                (''Sep-21''), (''Oct-21''), (''Nov-21''), (''Dec-21'')'
    ) AS (customer_id varchar, Jan_21 bigint, Feb_21 bigint, Mar_21 bigint,
                      Apr_21 bigint, May_21 bigint, Jun_21 bigint, Jul_21 bigint,
                      Aug_21 bigint, Sep_21 bigint, Oct_21 bigint, Nov_21 bigint, Dec_21 bigint)
order by 1),
final_data as (
    select customer_id
    ,coalesce(Jan_21,0) as Jan_21
    ,coalesce(Feb_21,0) as Feb_21
    ,coalesce(Mar_21,0) as Mar_21
    ,coalesce(Apr_21,0) as Apr_21
    ,coalesce(May_21,0) as May_21
    ,coalesce(Jun_21,0) as Jun_21
    ,coalesce(Jul_21,0) as Jul_21
    ,coalesce(Aug_21,0) as Aug_21
    ,coalesce(Sep_21,0) as Sep_21
    ,coalesce(Oct_21,0) as Oct_21
    ,coalesce(Nov_21,0) as Nov_21
    ,coalesce(Dec_21,0) as Dec_21
    ,coalesce(Jan_21,0) + coalesce(Feb_21,0) + coalesce(Mar_21,0) + coalesce(Apr_21,0) + coalesce(May_21,0) + coalesce(Jun_21,0) + coalesce(Jul_21,0) + coalesce(Aug_21,0) + coalesce(Sep_21,0) + coalesce(Oct_21,0) + coalesce(Nov_21,0) + coalesce(Dec_21,0) as Total
    from pivot_data
) 

select customer_id 
, case when Jan_21 < 0  then '(' || Jan_21 * -1 || ')$' else Jan_21 || '$' end as Jan_21
, case when Feb_21 < 0  then '(' || Feb_21 * -1 || ')$' else Feb_21 || '$' end as Feb_21
, case when Mar_21 < 0  then '(' || Mar_21 * -1 || ')$' else Mar_21 || '$' end as Mar_21
, case when Apr_21 < 0  then '(' || Apr_21 * -1 || ')$' else Apr_21 || '$' end as Apr_21 
, case when May_21 < 0  then '(' || May_21 * -1 || ')$' else May_21 || '$' end as May_21
, case when Jun_21 < 0  then '(' || Jun_21 * -1 || ')$' else Jun_21 || '$' end as Jun_21
, case when Jul_21 < 0  then '(' || Jul_21 * -1 || ')$' else Jul_21 || '$' end as Jul_21
, case when Aug_21 < 0  then '(' || Aug_21 * -1 || ')$' else Aug_21 || '$' end as Aug_21
, case when Sep_21 < 0  then '(' || Sep_21 * -1 || ')$' else Sep_21 || '$' end as Sep_21
, case when Oct_21 < 0  then '(' || Oct_21 * -1 || ')$' else Oct_21 || '$' end as Oct_21
, case when Nov_21 < 0  then '(' || Nov_21 * -1 || ')$' else Nov_21 || '$' end as Nov_21
, case when Dec_21 < 0  then '(' || Dec_21 * -1 || ')$' else Dec_21 || '$' end as Dec_21
, case when Total < 0 then '(' || (Total*-1) || ')$' else Total || '$' end as Total
from final_data;



