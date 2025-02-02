{{
    config(
        materialized='ephemeral'
    )
}}

select
    business_id,
    dogsallowed::boolean as dogsallowed
from {{ ref('business_attributes_flattened') }}
pivot(
    max(attribute_value)
    for attribute_key in ('dogsallowed')
) as p (business_id, dogsallowed)
