{{
    config(
        materialized='table'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['business_id', 'category']) }} as surrogate_key,
    business_id,
    category,
    {{ executed_at() }}
from {{ ref('int_business_categories') }}
