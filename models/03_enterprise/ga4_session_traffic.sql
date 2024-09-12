WITH ga4_raw as (
    select * from {{ ref('cleansed_ga4_raw') }}
)
select
    distinct 
    user_pseudo_id
    , event_value as ga_session_id
    , traffic_medium
    , traffic_name
    , traffic_source
FROM ga4_raw 
where event_param = 'ga_session_id'
