{{
    config(
        materialized='ephemeral'
    )
}}

with flattened as (
    select
        business_id,
        lower(h.key) as day_of_week,
        split_part(h.value::text, '-', 1)::time as open_time
    from {{ ref('business') }},
    lateral flatten(input => hours) as h
)

select *
from flattened
pivot(
    max(open_time)
    for day_of_week in ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')
) as p (business_id, monday_open, tuesday_open, wednesday_open, thursday_open, friday_open, saturday_open, sunday_open)
