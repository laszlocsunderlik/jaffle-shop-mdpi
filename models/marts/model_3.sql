with monthly_totals as (
    select
        o.customer,
        to_char(o.ordered_at::date, 'YYYY-MM') as order_month,
        sum(o.order_total) as total_invoiced
    from {{ source('raw', 'raw_orders') }} o
    group by o.customer, to_char(o.ordered_at::date, 'YYYY-MM')
),
--select * from monthly_totals;
ranked_customers as (
    select 
        mt.*,
        row_number() over (partition by order_month order by total_invoiced desc) as rank
    from monthly_totals mt
)
--select * from ranked_customers order by order_month;

select 
    rc.order_month,
    c.name as customer_name,
    rc.total_invoiced
from ranked_customers rc
join {{ source('raw', 'raw_customers') }} c on rc.customer = c.id
where rc.rank <= 3
order by rc.order_month, rc.rank
