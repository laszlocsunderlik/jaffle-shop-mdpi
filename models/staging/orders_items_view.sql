
select 
    o.id as order_id,
    o.customer,
    o.ordered_at,
    o.order_total,
    o.store_id,
    i.id as item_id,
    i.sku
from {{ source('raw_jaffle_shop_data', 'raw_orders') }} o
join {{ source('raw_jaffle_shop_data', 'raw_items') }} i on o.id = i.order_id
