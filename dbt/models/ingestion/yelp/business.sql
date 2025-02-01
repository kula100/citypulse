
with latest_data as (
    select raw_data
    from {{ source('raw_yelp', 'business') }}
    qualify row_number() over (order by ingestion_datetime desc) = 1
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
    raw_data:is_open::boolean as is_open,
    raw_data:attributes::variant as attributes,
    split(raw_data:categories,', ') as categories,
    raw_data:hours::variant as hours
from latest_data
