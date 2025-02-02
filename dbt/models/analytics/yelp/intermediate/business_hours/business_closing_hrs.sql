{{
    config(
        materialized='ephemeral'
    )
}}

with flattened as (
    select
        business_id,
        lower(h.key) as day_of_week,
        split_part(h.value::text, '-', 2)::time as close_time
    from {{ ref('business') }},
    lateral flatten(input => hours) as h
)

select *
from flattened
pivot(
    max(close_time)
    for day_of_week in ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')
) as p (business_id, monday_close, tuesday_close, wednesday_close, thursday_close, friday_close, saturday_close, sunday_close)
