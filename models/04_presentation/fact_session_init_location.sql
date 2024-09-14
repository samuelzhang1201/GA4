{{
    config(
        materialized='incremental',
        unique_key='ga_session_id',
        on_schema_change='fail',
        incremental_strategy='merge',
    )
}}

with ga4_location as (
    select * from {{ ref('ga4_session_location') }}
    {% if is_incremental() %}

    where sys_insert_datetime >= (select date_add(max(sys_insert_datetime), INTERVAL -2 DAY) from {{ this }} )

    {% endif %}
)
, ga4_user_id as (
    select * from {{ ref('ga4_user_id_merged') }}
)
, final as (
    select 
        a.user_pseudo_id
        , a.ga_session_id
        , a.continent
        , a.country
        , a.region
        , a.city
        , b.merged_user_id as user_id
    from ga4_location a 
    left join ga4_user_id b 
    on a.ga_session_id = b.ga_session_id
    where 
    a.user_pseudo_id = b.merged_user_id
)
    select 
    *
    , current_datetime('UTC') as sys_insert_datetime
    from final