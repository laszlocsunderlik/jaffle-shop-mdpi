with monthly_totals as (
    select
        customer,
        to_char(ordered_at::date, 'YYYY-MM') as month_of_the_year,
        sum(order_total) as total_invoiced
    from {{ ref('orders_items_view') }}
    group by customer, to_char(ordered_at::date, 'YYYY-MM')
),

--select * from monthly_totals;
ranked_customers as (
    select
        mt.*,
        row_number()
            over (partition by month_of_the_year order by total_invoiced desc)
        as rank
    from monthly_totals as mt
)
--select * from ranked_customers order by month_of_the_year;

select
    rc.month_of_the_year,
    c.name as customer_name,
    rc.total_invoiced
from ranked_customers as rc
inner join
    {{ source('raw_jaffle_shop_data', 'raw_customers') }} as c
    on rc.customer = c.id
where rc.rank <= 3
order by rc.month_of_the_year, rc.rank
