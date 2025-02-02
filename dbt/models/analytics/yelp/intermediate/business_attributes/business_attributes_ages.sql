{{
    config(
        materialized='ephemeral'
    )
}}

select
    business_id,
    agesallowed::text as agesallowed,
    goodforkids::boolean as goodforkids
from {{ ref('business_attributes_flattened') }}
pivot(
    max(attribute_value)
    for attribute_key in ('agesallowed', 'goodforkids')
) as p (business_id, agesallowed, goodforkids)
