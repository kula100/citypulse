{% macro generate_database_name_for_env(custom_database_name, node) -%}

    {%- set default_database = target.database -%}

    {%- if target.name == 'prod' -%}
        {%- if custom_database_name is not none -%}
            {{ custom_database_name | trim }}
        {%- else -%}
            {{ default_database }}
        {%- endif -%}

    {%- elif target.name == 'ci' -%}
        {%- if custom_database_name is not none -%}
            {{ custom_database_name | trim }}
        {%- else -%}
            {{ default_database }}
        {%- endif -%}

    {%- elif target.name == 'dev' -%}
        {{ default_database }}

    {%- else -%}
        {{ default_database }}

    {%- endif -%}

{%- endmacro %}