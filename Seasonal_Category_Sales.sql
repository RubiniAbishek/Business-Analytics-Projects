select
product_category,
month,
item_sold,
rank() over (partition by product_category order by item_sold desc ) as monthly_sales_rank
from
(select
product_category_name_english as product_category,
extract (month from order_purchase_stamp) as month,
count(order_item_id) as item_sold
from order_items oi
left join orders o on oi.order_id = o.order_id
left join product p on oi.product_id = p.product_id
left join product_category_translation pct on p.product_category_name = pct.product_category_name
group by 
product_category_name_english,
extract (month from order_purchase_stamp)) as subquery
order by
product_category,
monthly_sales_rank