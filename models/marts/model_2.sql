with item_counts_per_order as (
    select 
        order_id, 
        count(*) as item_count
    from {{ source('raw', 'raw_items') }}
    group by order_id
),
order_totals as (
    select 
        o.id as order_id,
        o.order_total
    from {{ source('raw', 'raw_orders') }} o
)

select 
    p.name as product_name,
    count(i.id) as items_sold,
    round(avg(ot.order_total::numeric / nullif(ico.item_count, 0)), 2) as avg_price_with_tax
from 
    {{ source('raw', 'raw_items') }} i
join 
    {{ source('raw', 'raw_products') }} p 
on i.sku = p.sku
join 
    order_totals ot 
on i.order_id = ot.order_id
join 
    item_counts_per_order ico 
on i.order_id = ico.order_id
group by p.name
order by items_sold desc
