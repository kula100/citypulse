{{
    config(
        materialized='ephemeral'
    )
}}

with flattened as (
    select
        business_id,
        try_parse_json(attribute_value) as attribute_value
    from {{ ref('business_attributes_flattened') }}
    where attribute_key = 'ambience'
),

ambience_flattened as (
    select
        business_id,
        lower(a.key) as ambience_key,
        a.value::boolean as ambience_value
    from flattened,
    lateral flatten(input => attribute_value) as a
)

select *
from ambience_flattened
pivot(
    max(ambience_value)
    for ambience_key in ('romantic', 'intimate', 'classy', 'hipster', 'divey', 'touristy', 'trendy', 'upscale', 'casual')
) as p (business_id, amb_romantic, amb_intimate, amb_classy, amb_hipster, amb_divey, amb_touristy, amb_trendy, amb_upscale, amb_casual)
