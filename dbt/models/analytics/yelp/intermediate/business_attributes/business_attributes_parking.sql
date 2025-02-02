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
    where attribute_key = 'businessparking'
),

bp_flattened as (
    select
        business_id,
        lower(a.key) as business_parking_key,
        a.value::boolean as business_parking_value
    from flattened,
    lateral flatten(input => attribute_value) as a
),

business_parking as (
    select *
    from bp_flattened
    pivot(
        max(business_parking_value)
        for business_parking_key in ('garage', 'street', 'validated', 'lot', 'valet')
    ) as p (business_id, business_parking_garage, business_parking_street, business_parking_validated, business_parking_lot, business_parking_valet)
),

other_parking as (
    select *
    from {{ ref('business_attributes_flattened') }}
    pivot(
        max(attribute_value)
        for attribute_key in ('bikeparking', 'wheelchairaccessible')
    ) as p (business_id, bike_parking, wheelchair_accessible)
)

select
    bp.business_id,
    bp.business_parking_garage,
    bp.business_parking_street,
    bp.business_parking_validated,
    bp.business_parking_lot,
    bp.business_parking_valet,
    try_parse_json(op.bike_parking)::boolean as bike_parking,
    try_parse_json(op.wheelchair_accessible)::boolean as wheelchair_accessible
from business_parking bp
inner join other_parking op
    on bp.business_id = op.business_id
