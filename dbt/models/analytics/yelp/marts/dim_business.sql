{{
    config(
        materialized='table'
    )
}}

select
    business_id,
    name,
    address,
    city,
    state,
    postal_code,
    latitude,
    longitude,
    stars,
    review_count,
    is_open,
    {{ executed_at()}}
from {{ ref('business') }}
qualify row_number() over (partition by business_id order by null desc) = 1

{{ limit_records(10) }}
