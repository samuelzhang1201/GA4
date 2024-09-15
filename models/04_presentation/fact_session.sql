{{
    config(
        materialized='incremental',
        unique_key='ga_session_id',
        on_schema_change='fail',
        incremental_strategy='merge',
    )
}}



with events as (
    select * from {{ ref('ga4_events') }}
    {% if is_incremental() %}

    where sys_insert_datetime >= (select date_add(max(sys_insert_datetime), INTERVAL -2 DAY) from {{ this }} )

    {% endif %}
)

, user_id as (
    select * from {{ ref('ga4_user_id_merged') }}
)
, event_adj as (
    select
        user_pseudo_id
        , a.ga_session_id
        , b.merged_user_id
        , min(event_timestamp) over(partition by a.ga_session_id) as session_start
        , max(event_timestamp) over(partition by a.ga_session_id) as session_end
        , event_name
        , row_number() over(partition by a.ga_session_id, event_name order by event_name) as event_rnb
        , case when event_name = 'view_search_results' then 1 else 0 end as include_search
        , user_first_touch_timestamp
        , event_date
        , event_bundle_sequence_id
    from events a
    left join user_id b 
    on a.ga_session_id = b.ga_session_id
)
, event_staging as (
    select 
        user_pseudo_id
        , merged_user_id as user_id
        , ga_session_id
        , session_start
        , session_end
        , event_name
        , event_rnb
        , max(event_rnb) over(partition by ga_session_id, event_name order by event_name) as event_count
        , event_rnb = max(event_rnb) over(partition by ga_session_id, event_name order by event_name) as is_max_equal_to_rnb
        , max(include_search) over(partition by ga_session_id ) as is_search_included
        , user_first_touch_timestamp
        , case when user_first_touch_timestamp = session_start then True else False end is_new_user
        , event_date
        , event_bundle_sequence_id
    from
        event_adj
    )
, final as (
    select 
        * 
    from
        event_staging 
    where 
        is_max_equal_to_rnb = TRUE and event_name = 'page_view'
)
    select 
        ga_session_id
        , user_id
        , session_start
        , session_end
        , event_count as page_view_count
        , is_search_included
        , is_new_user
        , event_date
        , current_datetime('UTC') as sys_insert_datetime
    from 
        final