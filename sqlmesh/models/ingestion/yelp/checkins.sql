MODEL (
    name raw_yelp.checkins,
    kind VIEW,
);

with latest_data as (
    select raw_data
    from raw.yelp.raw_checkin
    qualify max(ingestion_datetime) over () = ingestion_datetime
)

select
    raw_data:business_id::text as business_id,
    array_distinct(split(raw_data:date::text, ', ')) as checkin_datetimes
from latest_data
