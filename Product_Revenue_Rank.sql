create index order_items_product_id
on order_items(product_id);
create index order_items_price
on order_items(price);
select
pr.product_id,
pr.product_category_name_english,
pr.total_revenue,
pr.revenue_rank_in_category
from
(select
oi.product_id,
pct.product_category_name_english,
sum(oi.price) as total_revenue,
rank() over ( partition by pct.product_category_name_english order by sum(oi.price) desc) as revenue_rank_in_category
from order_items oi
left join product p on oi.product_id = p.product_id
left join product_category_translation pct on p.product_category_name = pct.product_category_name
group by
oi.product_id,
pct.product_category_name_english) pr
where pr.revenue_rank_in_category <= 3
order by pr.product_category_name_english, pr.revenue_rank_in_category;
