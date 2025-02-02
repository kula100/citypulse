{{ 
    config(
        materialized='ephemeral'
    )
}}

select
    business_id,
    noiselevel::text as noiselevel,
    byappointmentonly::boolean as byappointmentonly,
    wifi::text as wifi,
    smoking::text as smoking,
    open24hours::boolean as open24hours
from {{ ref('business_attributes_flattened') }}
pivot(
    max(attribute_value)
    for attribute_key in ('noiselevel', 'byappointmentonly', 'wifi', 'smoking', 'open24hours')
) as p (business_id, noiselevel, byappointmentonly, wifi, smoking, open24hours)
