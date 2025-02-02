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
    where attribute_key = 'dietaryrestrictions'
),

diet_flattened as (
    select
        business_id,
        lower(a.key) as diet_key,
        a.value::boolean as diet_value
    from flattened,
    lateral flatten(input => attribute_value) as a
)

select
    business_id,
    diet_dairy_free::boolean as diet_dairy_free,
    diet_gluten_free::boolean as diet_gluten_free,
    diet_vegan::boolean as diet_vegan,
    diet_kosher::boolean as diet_kosher,
    diet_halal::boolean as diet_halal,
    diet_soy_free::boolean as diet_soy_free,
    diet_vegetarian::boolean as diet_vegetarian
from diet_flattened
pivot(
    max(diet_value)
    for diet_key in ('dairy-free', 'gluten-free', 'vegan', 'kosher', 'halal', 'soy-free', 'vegetarian')
) as p (business_id, diet_dairy_free, diet_gluten_free, diet_vegan, diet_kosher, diet_halal, diet_soy_free, diet_vegetarian)
