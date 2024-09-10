
{{ config(
    materialized='table'
) }}

{% set tables_to_union = list_tables('bigquery-public-data', 'ga4_obfuscated_sample_ecommerce', 'events_') %}

{{ dbt_utils.union_relations(
    relations=tables_to_union
) }}