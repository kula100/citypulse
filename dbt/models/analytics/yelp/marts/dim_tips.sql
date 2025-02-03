{{
    config(
        materialized='table'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['user_id', 'business_id', 'tip_date']) }} as surrogate_key,
    user_id,
    business_id,
    tip_date,
    tip_msg,
    compliment_count,
    {{ executed_at() }}
from {{ ref('tips') }}
where tip_date is not null
qualify row_number() over (partition by surrogate_key order by tip_date desc) = 1
