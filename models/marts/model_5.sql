
with sold_in_2016 as (
    select
        sku,
        count(item_id) as units_sold
    from {{ ref('orders_items_view') }}
    where date_trunc('year', ordered_at::date) = date '2016-01-01'
    group by sku
),
supply_costs as (
    select
        ss.id as supply_id,
        ss.name as supply_name,
        ss.cost,
        ss.sku,
        p.type as product_type
    from {{ source('raw_jaffle_shop_data', 'raw_supplies') }} ss
    join {{ source('raw_jaffle_shop_data', 'raw_products') }} p on ss.sku = p.sku
)

select
	sc.supply_id,
	sc.sku,
    sc.supply_name,
    sc.product_type,
    coalesce(sc.cost * ss.units_sold, 0) as total_cost
from supply_costs sc
left join sold_in_2016 ss on sc.sku = ss.sku
order by total_cost desc
