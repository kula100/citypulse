{% macro executed_at() -%}

    '{{ run_started_at }}'::timestamp_tz as executed_at

{%- endmacro %}