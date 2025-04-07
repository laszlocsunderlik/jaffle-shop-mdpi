select 
    s.name as store_name,
    round(avg(item_counts.item_count), 2) as avg_items_per_order
from (
    select 
        order_id,
        count(item_id) as item_count,
        store_id
    from {{ ref('orders_items_view') }}
    group by order_id, store_id
) as item_counts
join {{ source('raw_jaffle_shop_data', 'raw_stores') }} s on item_counts.store_id = s.id
group by s.name
order by avg_items_per_order desc
