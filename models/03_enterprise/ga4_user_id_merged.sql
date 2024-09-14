WITH events as (
    select * from {{ ref('ga4_events') }}
)
, row_number_pseudo as (
SELECT 
    ga_session_id
    , event_bundle_sequence_id
    , user_pseudo_id
    , event_timestamp
    ,row_number() over(partition by ga_session_id order by event_timestamp ) as pseudo_rnb
    , user_first_touch_timestamp
FROM events 
)
, merged_user_id as (
    select 
    ga_session_id
    , user_pseudo_id as merged_user_id
    ,current_datetime('UTC') as sys_insert_datetime
    from row_number_pseudo 
    where pseudo_rnb = 1
)
    select * from merged_user_id