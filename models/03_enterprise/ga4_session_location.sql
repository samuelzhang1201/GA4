WITH ga4_raw as (
    select * from {{ ref('cleansed_ga4_raw') }}
)
select
    user_pseudo_id
    , event_value as ga_session_id
    , continent
    , country
    , region
    , city
FROM ga4_raw 
where event_param = 'ga_session_id'
