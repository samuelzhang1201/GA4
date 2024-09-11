WITH ga4_raw as (
    select * from {{ ref('cleansed_ga4_raw') }}
)

select 
distinct 
  parse_date('%Y%m%d',event_date) as event_date
  , timestamp_micros(event_timestamp) as event_timestamp
  , event_bundle_sequence_id
  , user_pseudo_id
  , device.category AS device_category
  , device.mobile_brand_name AS device_mobile_brand
  , device.mobile_model_name AS device_model_name
  , device.mobile_marketing_name AS mobile_marketing_name
  , device.operating_system AS device_os
  , device.language AS language
  , device.operating_system_version As os_version
  , device.is_limited_ad_tracking AS is_limited_ad_tracking
  , device.web_info.browser AS browser
  , device.web_info.browser_version AS browser_version
from 
  ga4_raw
