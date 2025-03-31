MODEL (
    name raw_yelp.tips,
    kind VIEW,
);

with latest_data as (
    select raw_data
    from raw.yelp.raw_tip
    qualify max(ingestion_datetime) over () = ingestion_datetime
)

select
    raw_data:user_id::text as user_id,
    raw_data:business_id::text as business_id,
    try_to_timestamp(raw_data:date::text) as tip_date,
    raw_data:text::text as tip_msg,
    raw_data:compliment_count::int as compliment_count
from latest_data
