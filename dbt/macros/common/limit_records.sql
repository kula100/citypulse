{% macro limit_records(limit=1000) -%}

    {%- if target.name in ('dev', 'ci') -%}
        limit {{ limit}}
    {%- endif -%}

{%- endmacro %}