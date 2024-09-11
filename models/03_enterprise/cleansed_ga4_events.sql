WITH ga4_raw as (
    select * from {{ ref('cleansed_ga4_raw') }}
)
, ga4_events as (
select 
  event_date
  , event_timestamp
  , event_name
  , event_value as ga_session_id
  , event_bundle_sequence_id
  , user_pseudo_id
  , user_first_touch_timestamp
  , stream_id
  , platform
from 
  ga4_raw
where event_param = 'ga_session_id'
)
, final as (
select 
    {{ dbt_utils.generate_surrogate_key(['event_name','user_pseudo_id','event_bundle_sequence_id'])}} as event_key
    , event_date
    , event_timestamp
    , event_name
    , event_value as ga_session_id
    , event_bundle_sequence_id
    , user_pseudo_id
    , user_first_touch_timestamp
    , stream_id
    , platform
  from ga4_events
)
  select * from final 