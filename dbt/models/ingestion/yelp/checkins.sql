{{ config(alias='view_checkins') }}

with latest_data as (
    select raw_data
    from {{ source('raw_yelp', 'checkins') }}
    qualify max(ingestion_datetime) over () = ingestion_datetime
)

select
    raw_data:business_id::text as business_id,
    split(raw_data:date::text, ', ') as checkin_datetimes
from latest_data
