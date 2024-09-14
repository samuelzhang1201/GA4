with date_spine as (
    select * from {{ ref('date_spine') }}
)
select * from date_spine