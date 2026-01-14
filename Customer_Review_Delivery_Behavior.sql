with customer_review as
(select
o.order_id,
(order_delivered_customer_date - order_estimated_delivery_date) as delay_days,
review_score
from
orders o
left join reviews r on o.order_id = r.order_id)
select
order_id,
extract(day from delay_days) as delay_days,
case
when extract(day from delay_days) = 0 then 'on-time'
when extract(day from delay_days) < 0 then 'Early delivery'
when extract(day from delay_days) > 0 then 'Late delivery'
when extract(day from delay_days) is null then 'Not delivered'
end as delivery_status,
review_score
from
customer_review