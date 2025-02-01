{% macro generate_schema_name_for_env(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if target.name == 'prod' -%}
        {%- if custom_schema_name is not none -%}
            {{ custom_schema_name | trim }}
        {%- else -%}
            {{ default_schema }}
        {%- endif -%}

    {%- elif target.name == 'ci' -%}
        {%- if custom_schema_name is not none -%}
            {{ custom_schema_name | trim }}
        {%- else -%}
            {{ default_schema }}
        {%- endif -%}

    {%- elif target.name == 'dev' -%}
        {%- if custom_schema_name is not none -%}
            dev_{{ custom_schema_name | trim }}
        {%- else -%}
            {{ default_schema }}
        {%- endif -%}

    {%- else -%}
        {{ default_schema }}

    {%- endif -%}

{%- endmacro %}