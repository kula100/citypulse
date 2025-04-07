{{
    config(
        materialized='table'
    )
}}

select
    review_id,
    user_id,
    business_id,
    stars,
    review_date,
    review,
    useful_votes,
    funny_votes,
    cool_votes,
    {{ executed_at() }}
from {{ ref('reviews') }}

{{ limit_records(1000) }}
