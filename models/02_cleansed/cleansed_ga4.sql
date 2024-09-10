{{
    config(
        materialized='incremental',
        unique_key = ["event_timestamp","user_id","event_bundle_sequence_id"],
        on_schema_change = 'append_new_columns'
    )
}}


With ga4_raw as (
    select * from {{source('ga4_ecommerce_raw','ga4_raw')}}
)

, flattened_data AS (
  -- Flatten the event_params array
  SELECT
    event_date,
    event_timestamp,
    event_name,
    event_previous_timestamp,
    event_value_in_usd,
    event_bundle_sequence_id,
    event_server_timestamp_offset,
    user_id,
    user_pseudo_id,
    user_first_touch_timestamp,
    user_ltv.revenue AS user_ltv_revenue,
    user_ltv.currency AS user_ltv_currency,
    device.category AS device_category,
    device.mobile_brand_name AS mobile_brand,
    device.mobile_model_name AS mobile_model,
    device.operating_system AS operating_system,
    device.language AS device_language,
    geo.continent AS geo_continent,
    geo.country AS geo_country,
    geo.city AS geo_city,
    traffic_source.medium AS traffic_medium,
    traffic_source.source AS traffic_source,
    traffic_source.name AS traffic_name,
    e.value.string_value AS event_param_value_string,
    e.value.int_value AS event_param_value_int,
    e.value.float_value AS event_param_value_float,
    e.value.double_value AS event_param_value_double,
    e.key AS event_param_key
  FROM ga4_raw, 
  UNNEST(event_params) AS e  -- Unnest the event_params array
)
SELECT
  event_date,
  event_timestamp,
  event_name,
  event_previous_timestamp,
  event_value_in_usd,
  event_bundle_sequence_id,
  event_server_timestamp_offset,
  user_id,
  user_pseudo_id,
  user_first_touch_timestamp,
  user_ltv_revenue,
  user_ltv_currency,
  device_category,
  mobile_brand,
  mobile_model,
  operating_system,
  device_language,
  geo_continent,
  geo_country,
  geo_city,
  traffic_medium,
  traffic_source,
  traffic_name,
  event_param_key,
  event_param_value_string,
  event_param_value_int,
  event_param_value_float,
  event_param_value_double
FROM flattened_data