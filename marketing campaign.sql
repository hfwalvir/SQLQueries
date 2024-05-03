select * from marketing_campaign;
with rnk_data as(
select *,
rank() over (partition by user_id order by created_at) as rn
from marketing_campaign)
, first_app_purchases as (
select * from rnk_data
where rn = 1)
, except_first_app_purchases as(
select * from rnk_data
where rn>1)
select efap.user_id
from except_first_app_purchases efap
left join first_app_purchases fap on fap.user_id = efap.user_id and efap.product_id = fap.product_id
where fap.product_id is null;