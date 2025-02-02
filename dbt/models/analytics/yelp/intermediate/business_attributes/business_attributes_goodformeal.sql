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
    where attribute_key = 'goodformeal'
),

goodformeal_flattened as (
    select
        business_id,
        lower(a.key) as goodformeal_key,
        a.value::boolean as goodformeal_value
    from flattened,
    lateral flatten(input => attribute_value) as a
)

select *
from goodformeal_flattened
pivot(
    max(goodformeal_value)
    for goodformeal_key in ('dessert', 'latenight', 'lunch', 'dinner', 'brunch', 'breakfast')
) as p (business_id, goodformeal_dessert, goodformeal_latenight, goodformeal_lunch, goodformeal_dinner, goodformeal_brunch, goodformeal_breakfast)
