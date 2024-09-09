
-- Use the `ref` function to select from other models

select *
from {{ ref('ga4_raw') }}
where event_date= '20210131'
