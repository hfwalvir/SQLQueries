create materialized_view account_cash as 
--purchases function
with purchase_dates as(
select case when payment_method = 'cash' then payment_at 
	else payment_at + interval '1 month' end as actual_payment_at
	,-sum(quantity * amount) 
	from purchases
	group by case when payment_method = 'cash' then payment_at 
	else payment_at + interval '1 month' end
)
, purchase as(
select date_part('year',actual_payment_at) as period_year
sum(total_amount) as amount
	from purchase_dates
	group by date_part(actual_payment_at)
	

--sales table
with revenue_dates as(
select case when payment_method = 'cash' then payment_at 
	else payment_at + interval '1 month' end as actual_payment_at
	,sum(quantity * price) as total_amount
	from purchases
	group by case when payment_method = 'cash' then payment_at 
	else payment_at + interval '1 month' end
)
, revenue as(
select date_part('year',actual_payment_at) as period_year
sum(total_amount)
	from revenue_dates
	group by date_part(actual_payment_at))
-- loan and expenses
, loan_in as(
select date_part('year',loan_at) as period_year,
sum(value) as total_amount
from loans
group by date_part('year',loan_at))
, expenses as(
select date_part('year',payment_date) as period_year,
-sum(amount) as total_amount
from payments
	where payment_type in ('equipment', 'wage','rent','utility','tax','loan','interest')
group by date_part('year',payment_date)
)
--Cash Account
,cash_union as(
select * from loan_in
	union all
	select * from expenses
	union all
	select * from purchase
	union all
	select * from revenue
),
cash_amount as(
select period_year, sum(total_amount)
	from cash_union
	group by period_year
)
-- summing up the cash over the years (cumulative sum)
select period_year,
'Cash' as account
, total_amount as original,
sum(total_amount) over (order by period_year)
from cash_amount)
	
-- for payment methods with other payment method (credit)
select materialized_view account_accounts_receivable as(
select date_part('year', payment_at) as period_year,
'Accounts Receivable' as account,
sum(price*quantity) as total_amount
from revenue
where payment_methof <> 'cash'
and date_part('month',payment_at) = 12
group by date_part('year', payment_at))


-- PROPERTY, LAND AND EQUIPMENT
create materialized_view account_ple as
with depreciation_dates as(
select id, payment_date, calendar_at, year as period_year,
	case when year = date_part('year', payment_date + interval '10 years'
	and month = date_part('month',payment_date) then 1
	when month = 12 then 1 
	else 0 end as flag_1_year, amount,
	amount/(count(*) over(partition by id)) as installments 
	from calendar
	cross join payments
	where calendar_at >= payment_date
	and calendar_at <= payment_date + interval "10 years"
	and payment_type = 'equipment'
	and id = 66

)
, depreciation_sum as(
select * ,
sum(installments) over (partition by id order by calendar_at) as depn_amount
from depreciation_dates
)
, depreciation as(
select period_year, sum(depn_amount) as total_amount
	from depreciation_sum
	group by period_year)
						
, ple_purchase as(
select date_part('year',payment_date) as period_year,
sum(amount) as total_amount
from payments
	where payment_type in ('equipment')
	group by date_part('year', payment_date
),
ple_union as (
select * from depreciation
	union all
	select * from ple_purchase)
, ple_sum as(
select period_year , sum(total_amount) as total_amount
	from ple_union
	group by period_year
),
property_equipment as(
select period_year, 'Property Lan and Equipment' as account,
	roumd(sum(total_amount),2) over (order by period_year) as total_amount
	from ple_sum
)
create materialized view account_inventory as
--purchases function
with purchase_dates as(
select case when payment_method = 'cash' then payment_at 
	else payment_at + interval '1 month' end as actual_payment_at
	,-sum(quantity * amount) as total_amount
	from purchases
	group by case when payment_method = 'cash' then payment_at 
	else payment_at + interval '1 month' end
)
, purchase as(
select date_part('year',actual_payment_at) as period_year, 
sum(total_amount) as amount
	from purchase_dates
	group by date_part(actual_payment_at)	
, product_price as (
select distinct product_name,
	amount
	from purchase),
sale as(
select datepart('year',payment_at) as period_year.
	-sum(s.quantity * p.amount) as total_amount
	from sales s 
	left join product_price p 
	on s.product_name = p.product_name
group by datepart('year',payment_at))
, inventory_union as(
select * from purchases
	union all
select * from sale)
, inventory_sum as(
select period_year, sum(total_amount) as total_amount
	from inventory_union
	group by period_year
)
, inventory as(
select period_year, 'Inventory' as account
sum(total_amount) over (order by period_year) as total_amount
from inventory_sum
), 
select * from inventory
	
-- LOAN
create materialized_view loan_account as
with loan_in as(
select date_part('year',loan_at) as period_year,
sum(value) as total_amount
from loans
group by date_part('year',loan_at))
, loan_pay as(
select date_part('year',payment_date) as period_year,
-sum(amount) as total_amount
from payments
	where payment_type in ('loan','interest')
group by date_part('year',payment_date))
, loan_union as(
select * from loan_in
	union all
	select * from loan
),
loan_amount as (
select period_year, sum(total_amount) as total_amount
	from loan_union
	group by period_year
),
loan as(
select period_year, 'Loan' as account,
	sum(total_amount) over (order by period_year) as total_amount
from loan_amount
)
select * from loan
	
-- Retained earnings account
create materialized view account_RETAINED_EARNINGS as 
with 
	revenue as (
	select date_part('year',payment_at) as period_year
		, 'Revenue' as transaction_type,
		1 as order_process
		, sum(quantity * price) as total_amount
		from sales
		group by date_part('year',payment_at)
)
,purchase as(
select date_part('year',actual_payment_at) as period_year, 
sum(total_amount) as amount
	from purchase_dates
	group by date_part(actual_payment_at)	
, product_price as (
select distinct product_name,
	amount
	from purchase),
cogs as(
select datepart('year',payment_at) as period_year,
	'COGS' as transaction_type, 2 as order_process,
	-sum(s.quantity * p.amount) as total_amount
	from sales s 
	left join product_price p 
	on s.product_name = p.product_name
group by datepart('year',payment_at))

,depreciation_dates as(
select id, payment_date, calendar_at, year as period_year,
	case when year = date_part('year', payment_date + interval '10 years'
	and month = date_part('month',payment_date) then 1
	when month = 12 then 1 
	else 0 end as flag_1_year, amount,
	amount/(count(*) over(partition by id)) as installments 
	from calendar
	cross join payments
	where calendar_at >= payment_date
	and calendar_at <= payment_date + interval "10 years"
	and payment_type = 'equipment'
	and id = 66
)
, depreciation_sum as(
select * ,
sum(installments) over (partition by id order by calendar_at) as depn_amount
from depreciation_dates
)
, depreciation as(
select period_year,'Depreciation' as transaction_type,
	3 as order_process,
	sum(depn_amount) as total_amount
	from depreciation_sum
	group by period_year)
,expenses as(
select date_part('year',payment_date) as period_year,
case when payment_type = 'tax' then 'Tax Expenses'
	when payment_type = 'interest' then 'Interest Expenses'
	when payment_type = 'wage' then 'Wage Expenses'
	when payment_type in ('rent', 'utility') then 'Operational Expenses' end as transaction_type 
case when payment_type = 'tax' then 4
	when payment_type = 'interest' then 5
	when payment_type = 'wage' then 6 
	when payment_type in ('rent', 'utility') then 7 end as order_process
	-sum(amount) as total_amount
from payments
	where payment_type in ('wage','rent','utility','tax','interest')
group by date_part('year',payment_date),
	case when payment_type = 'tax' then 'Tax Expenses'
	when payment_type = 'interest' then 'Interest Expenses'
	when payment_type = 'wage' then 'Wage Expenses'
	when payment_type in ('rent', 'utility') then 'Operational Expenses' end 
case when payment_type = 'tax' then 4
	when payment_type = 'interest' then 5
	when payment_type = 'wage' then 6 
	when payment_type in ('rent', 'utility') then 7 end) 
, re_union as (
select * from revenue
	union all
	select * from cogs
	union all
    select * from depreciation
	union all
	select * from expenses
	union all
	select distinct date_part('year', calendar_at) as period_year,
	'Retained Earnings-Beginning Balance' as transaction_type,
	0 as order_process,
	0 as total_amount
	from calendar 
	union all
	select distinct date_part('year', calendar_at) as period_year,
	'Retained Earnings' as transaction_type,
	999 as order_process,
	0 as total_amount
	from calendar 
),
re_details as(
select period_year, transaction_type , total_amount as original
, round(case when order_process = 0 or order_process = 999 then sum(total_amount) over (order by period_year,order_process)
	else total_amount end,2) as total_amount
	from re_union)
	
-- Assets 
	crete materialized view section_assets as
with assets_union
	( 
	select *, 1 as order_process from account_cash
		union all
		select *, 2 as order_process from account_accounts_receivable
	    union all
		select * , 3 as order_pricess from account_inventory
		union all
		select * , 4 as order_process from account_property_equipment
		union all
		select date_part('year',calendar_at) as period_year,
		'Assets' as account, 0 as total_amount, 999 as order_process
		from calendar
		group by date_part('year',calendar_at)
)
select period_year, 'Assets' as section_bs, total_amount as original,
	case when order_process = 999 then sum(total_amount) over (partition by period_year order by order_process)
	else total_amount end as total_amount
	from assets_union
	
-- Liabilities
	create materialized_view section_liabilities as 
with liabilities_union as(
select *, 1 as order_process from account_loan
	union all
	select date_part('year', calendar_at) as period_year,
	'Liabilities' as account,
	0 as total_amount,
	999 as order_process
	from calendar
	group by date_part('year', calendar_at)
)
select period_year, 'Liabilities' as section_bs, account,
	case when order_process = 999 then sum(total_amount) over (partition by period_year order by order_process)
	else total_amount end as total_amount
	from liabilities_union)  

--equity section
	create materialized view section_owners_equity as 
with oe_union as(
select period_year, transaction_type as account,
	total_amount , 1 as order_process
	from account_retained_earnings_details
	where transaction_type = 'Retained Earnings'
union all
select distinct date_part('year', calendar_at)as period_year,
	'Owners Equity' as account,
	0 as total_amount,
	999 as order_process
	from calendar
)
select period_year, 'Owners Equity' as sectionbs,
	account,case when order_process = 999 then sum(total_amount) over (partition by period_year order by order_process)
	else total_amount end as total_amount
	from oe_union
--Time for Balance Sheet!
create materialized view balance_sheet as 
with balance_sheet as (
select * from section_assets
	union all
	select * from section_liabilities
	union all
	select * from section_owners_liability
	union all
	select * from section_owners_equity
)
	select * from balance_sheet
	
--Time for income statement !
	create materialized view income_statement
select period_year,
	case when transaction_type = 'Retained Earnings' then'Net Income' 
	else transaction_type end as transaction_type
	, total_amount
from account_retained_earnings_details
	
	
	