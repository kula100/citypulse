{%- macro drop_pr_schemas(pr_number) %}

    {% set pr_cleanup_query %}
        with pr_staging_schemas as (
            select schema_name
            from {{ target.database }}.information_schema.schemata
            where schema_name ilike 'pr_' || '{{ pr_number }}' || '__%'
        )

        select 
            'drop schema if exists ' || schema_name || ' cascade;' as drop_command 
        from pr_staging_schemas
    {% endset %}

{% do log(pr_cleanup_query, True) %}

{% set drop_commands = run_query(pr_cleanup_query).columns[0].values() %}

{% if drop_commands %}
  {% for drop_command in drop_commands %}
    {% do log(drop_command, True) %}
      {% do run_query(drop_command) %}
  {% endfor %}
{% else %}
  {% do log('No schemas to drop.', True) %}
{% endif %}

{%- endmacro -%}