{{
    config(
        materialized='table'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['business_id', 'checkin_date']) }} as surrogate_key,
    business_id,
    checkin_date,
    {{ executed_at() }}
from {{ ref('int_checkins') }}
