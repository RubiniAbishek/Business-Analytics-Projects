with order_details as -- CTE1
(select distinct
c.customer_unique_id,
o.order_id,
order_purchase_stamp,
product_category_name_english
from orders o
left join customers c on o.customer_id = c.customer_id
left join order_items oi on o.order_id = oi.order_id
left join product p on oi.product_id = p.product_id
left join product_category_translation pct on p.product_category_name = pct.product_category_name),
customer_metrics as --CTE2
(select
customer_unique_id,
product_category_name_english,
count(order_id) over (partition by customer_unique_id, product_category_name_english) as total_orders,
min(order_purchase_stamp) over (partition by customer_unique_id, product_category_name_english) as first_order_date,
max(order_purchase_stamp) over (partition by customer_unique_id, product_category_name_english) as last_order_date
from order_details)
select distinct
customer_unique_id,
product_category_name_english,
total_orders,
first_order_date,
last_order_date,
(last_order_date - first_order_date) AS days_between_orders,
(case
when total_orders = 1 then 'New'
when total_orders <= 3 then 'Repeat'
when total_orders >= 4 then 'Loyal'
end) as customer_type
from customer_metrics
group by
customer_unique_id,
product_category_name_english,
total_orders,
first_order_date,
last_order_date
ORDER BY total_orders DESC, days_between_orders DESC;