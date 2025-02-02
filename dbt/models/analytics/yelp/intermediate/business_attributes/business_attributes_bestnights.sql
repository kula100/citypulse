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
    where attribute_key = 'bestnights'
),

bestnights_flattened as (
    select
        business_id,
        lower(a.key) as bestnights_key,
        a.value::boolean as bestnights_value
    from flattened,
    lateral flatten(input => attribute_value) as a
)

select *
from bestnights_flattened
pivot(
    max(bestnights_value)
    for bestnights_key in ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')
) as p (business_id, bestnights_monday, bestnights_tuesday, bestnights_wednesday, bestnights_thursday, bestnights_friday, bestnights_saturday, bestnights_sunday)
