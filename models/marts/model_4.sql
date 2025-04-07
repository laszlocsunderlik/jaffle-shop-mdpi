with monthly_invoiced as (
    select
        to_char(ordered_at::date, 'YYYY-MM') as month_of_order,
        sum(order_total) as total_invoiced
    from {{ ref('orders_items_view') }}
    group by to_char(ordered_at::date, 'YYYY-MM')
),
monthly_variation_invoiced as (
    select
        month_of_order,
        total_invoiced,
        lag(total_invoiced) over (order by month_of_order) as prev_invoiced
    from monthly_invoiced
)

select
    month_of_order,
    total_invoiced,
    round(
        case 
            when prev_invoiced is null or prev_invoiced = 0 then null
            else ((total_invoiced - prev_invoiced) * 100.0 / prev_invoiced)
        end, 
        2
    ) as month_vs_month_change
from monthly_variation_invoiced
order by month_of_order
