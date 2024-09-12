with events as (
    select * from {{ ref('ga4_events') }}
)
, event_adj as (
    select
        user_pseudo_id
        , ga_session_id
        , min(event_timestamp) over(partition by ga_session_id) as session_start
        , max(event_timestamp) over(partition by ga_session_id) as session_end
        , event_name
        , row_number() over(partition by user_pseudo_id, ga_session_id, event_name order by event_name) as event_rnb
        , case when event_name = 'view_search_results' then 1 else 0 end as include_search
        , event_date
        , event_bundle_sequence_id
    FROM events
)
, event_staging as (
    select 
        user_pseudo_id
        , ga_session_id
        , session_start
        , session_end
        , event_name
        , event_rnb
        , max(event_rnb) over(partition by user_pseudo_id, ga_session_id, event_name order by event_name) as event_count
        , event_rnb = max(event_rnb) over(partition by user_pseudo_id, ga_session_id, event_name order by event_name) as is_max_equal_to_rnb
        , include_search
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
        user_pseudo_id
        , ga_session_id
        , session_start
        , session_end
        , event_count as page_view_count
        , include_search
        , event_date
    from 
        final