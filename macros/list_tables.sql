{% macro list_tables(project, dataset, prefix) %}
  {% set query %}
    SELECT table_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.INFORMATION_SCHEMA.TABLES`
    WHERE table_name LIKE '{{ event_ }}%'
  {% endset %}

  {% set results = run_query(query) %}
  {% set table_names = [] %}

  {% for row in results %}
    {% set table_name = "`bigquery-public-data.ga4_obfuscated_sample_ecommerce." ~ row.table_name ~ "`" %}
    {% set table_relation = adapter.get_relation(
        database='bigquery-public-data', 
        schema='ga4_obfuscated_sample_ecommerce', 
        identifier=row.table_name
    ) %}
    {% do table_names.append(table_relation) %}
  {% endfor %}

  {{ return(table_names) }}
{% endmacro %}