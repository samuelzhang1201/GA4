{{
    config(
        materialized='incremental',
        unique_key=['user_pseudo_id','ga_session_id'],
        on_schema_change='fail',
        incremental_strategy='merge',
    )
}}

with ga4_raw as (
    select * from {{ ref('cleansed_ga4_raw') }}
    {% if is_incremental() %}

    where sys_insert_datetime >= (select date_add(max(sys_insert_datetime), INTERVAL -2 DAY) from {{ this }} )

    {% endif %}
)
select
    distinct 
    user_pseudo_id
    , event_value as ga_session_id
    , continent
    , country
    , region
    , city
    , current_datetime('UTC') as sys_insert_datetime
FROM ga4_raw 
where event_param = 'ga_session_id'
