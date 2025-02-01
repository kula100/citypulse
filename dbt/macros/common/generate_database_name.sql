{% macro generate_database_name(custom_database_name=none, node=none) -%}

    {%- set default_database = target.database -%}
    {%- if custom_database_name is none -%}

        {{ default_database }}

    {%- else -%}

        {{ generate_database_name_for_env(custom_database_name, node) }}

    {%- endif -%}

{%- endmacro %}