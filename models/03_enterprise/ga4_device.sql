WITH ga4_raw as (
    select * from {{ ref('cleansed_ga4_raw') }}
)
, ga4_device as (
  select 
  distinct
     user_pseudo_id
    , event_value as ga_session_id
    , device_category
    , device_mobile_brand
    , device_model_name
    , mobile_marketing_name
    , device_os
    , language
    , os_version
    , is_limited_ad_tracking
  from 
    ga4_raw
    where event_param = 'ga_session_id'
)
  select * from ga4_device
