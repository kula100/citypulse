{{
    config(
        materialized='ephemeral'
    )
}}

select
    business_id,
    lower(a.key) as attribute_key,
    try_parse_json(a.value) as attribute_value
from {{ ref('business') }},
lateral flatten(input => attributes) as a
