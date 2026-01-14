-- Top Product categories by items sold
with category_orders as
(select
product_category_name_english as product_category,
oi.order_id
from order_items oi
left join product p on oi.product_id = p.product_id
left join product_category_translation pct on p.product_category_name = pct.product_category_name)
select
product_category,
count(order_id) as total_orders
from category_orders
group by
product_category
order by total_orders desc
limit 5