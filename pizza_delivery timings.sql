select to_char(order_time::timestamp,'Mon-YYYY') as period,
SUM(CASE 
        WHEN EXTRACT(EPOCH FROM(
            to_timestamp(actual_delivery, 'YYYY-MM-DD HH24:MI:SS') -
            to_timestamp(order_time, 'YYYY-MM-DD HH24:MI:SS')
        ))/60 > 30
        THEN 1 
        ELSE 0 
    END) as delay_times,
round(cast(SUM(CASE 
        WHEN EXTRACT(EPOCH FROM(
            to_timestamp(actual_delivery, 'YYYY-MM-DD HH24:MI:SS') -
            to_timestamp(order_time, 'YYYY-MM-DD HH24:MI:SS')
        ))/60 > 30
        THEN 1 
        ELSE 0 
    END) as decimal)/count(1)*100,1) as Percentage_delay,
sum(case when EXTRACT(EPOCH FROM(
            to_timestamp(actual_delivery, 'YYYY-MM-DD HH24:MI:SS') -
            to_timestamp(order_time, 'YYYY-MM-DD HH24:MI:SS')
        ))/60 > 30 THEN 
		no_of_pizzas else 0 
		end) as free_pizzas
from pizza_delivery 
where actual_delivery is not null
group by to_char(order_time::timestamp,'Mon-YYYY')
ORDER BY 
    EXTRACT(MONTH FROM MIN(order_time::timestamp)),
    EXTRACT(YEAR FROM MIN(order_time::timestamp));

select * from pizza_delivery 