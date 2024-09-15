{{
    config(
        materialized='incremental',
        on_schema_change='fail',
        incremental_strategy='insert_overwrite',
        partition_by={
            "field":"PARTITIONTIME",
            "data_type": "date"
        }
    )
}}

WITH ga4_raw AS (
    SELECT 
        *
        ,_PARTITIONDATE as PARTITIONTIME
    FROM {{ source('ga4','landing_ga4_raw') }}
        {% if is_incremental() %}
        -- Filter for new or updated records only in incremental loads
        WHERE _PARTITIONDATE >= (SELECT MAX(_PARTITIONDATE) FROM {{ this }})
        {% else %}
        -- Full load for the first time, select all partitions
        WHERE _PARTITIONDATE IS NOT NULL
    {% endif %}
)
, flattened_data AS (
SELECT
    parse_date('%Y%m%d',event_date) as event_date
    , timestamp_micros(event_timestamp) as event_timestamp
    , event_name
    , event_bundle_sequence_id
    , user_pseudo_id
    , timestamp_micros(user_first_touch_timestamp) as user_first_touch_timestamp
    , ep.key AS event_param
    , coalesce( cast(ep.value.string_value as string) ,cast(ep.value.int_value as string) ,cast(ep.value.float_value as string) ,cast(ep.value.double_value as string)) as event_value
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
    , geo.continent
    , geo.country
    , geo.region
    , geo.city
    , traffic_source.medium AS traffic_medium
    , traffic_source.name AS traffic_name
    , traffic_source.source AS traffic_source
    , stream_id
    , platform
    , PARTITIONTIME
    , current_datetime('UTC') as sys_insert_datetime
FROM
    ga4_raw,
    UNNEST(event_params) AS ep
)
    SELECT * FROM flattened_data