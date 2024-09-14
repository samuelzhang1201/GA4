{{
    config(
        materialized='incremental',
        unique_key=['user_pseudo_id','ga_session_id'],
        on_schema_change='fail',
        incremental_strategy='merge',
    )
}}
WITH ga4_raw as (
    select * from {{ ref('cleansed_ga4_raw') }}
    {% if is_incremental() %}

    where sys_insert_datetime >= (select date_add(max(sys_insert_datetime), INTERVAL -2 DAY) from {{ this }} )

    {% endif %}
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
    , current_datetime('UTC') as sys_insert_datetime
  from 
    ga4_raw
    where event_param = 'ga_session_id'
)
  select * from ga4_device
