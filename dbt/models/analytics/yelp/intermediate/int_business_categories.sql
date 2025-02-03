{{
    config(
        materialized='ephemeral'
    )
}}

select
    business_id,
    value::text as category
from {{ ref('business') }},
lateral flatten(input => categories) as f
