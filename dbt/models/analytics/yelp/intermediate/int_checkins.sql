{{
    config(
        materialized='ephemeral'
    )
}}

select
    business_id,
    value::timestamp as checkin_date
from {{ ref('checkins') }},
lateral flatten(input => checkin_datetimes) as f
