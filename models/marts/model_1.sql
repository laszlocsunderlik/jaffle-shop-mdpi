select 
    s.name as store_name,
    round(avg(item_counts.item_count), 2) as avg_items_per_order
from (
    select 
        o.id as order_id,
        count(i.id) as item_count,
        o.store_id
    from {{ source('raw', 'raw_orders') }} o
    join {{ source('raw', 'raw_items') }} i on o.id = i.order_id
    group by o.id, o.store_id
) as item_counts
join {{ source('raw', 'raw_stores') }} s on item_counts.store_id = s.id
group by s.name
order by avg_items_per_order desc
