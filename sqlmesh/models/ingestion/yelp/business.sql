MODEL (
    name raw_yelp.view_business,
    kind VIEW,
    grain business_id,
);

with latest_data as (
    select raw_data
    from raw.yelp.raw_business
    qualify max(ingestion_datetime) over () = ingestion_datetime
)

select
    raw_data:business_id::text as business_id,
    raw_data:name::text as name,
    raw_data:address::text as address,
    raw_data:city::text as city,
    raw_data:state::text as state,
    raw_data:postal_code::text as postal_code,
    raw_data:latitude::float as latitude,
    raw_data:longitude::float as longitude,
    raw_data:stars::float as stars,
    raw_data:review_count::int as review_count,
    raw_data:is_open::int::boolean as is_open,
    raw_data:attributes::variant as attributes,
    array_distinct(split(raw_data:categories::text, ', ')) as categories,
    raw_data:hours::variant as hours
from latest_data
