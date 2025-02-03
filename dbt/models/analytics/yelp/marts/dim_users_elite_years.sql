{{
    config(
        materialized='table'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['user_id', 'year']) }} as surrogate_key,
    user_id,
    year,
    {{ executed_at() }}
from {{ ref('int_users_elite_years') }}
