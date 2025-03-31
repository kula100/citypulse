MODEL (
    name raw_yelp.view_reviews,
    kind VIEW,
    grain review_id,
);

with latest_data as (
    select raw_data
    from raw.yelp.raw_review
    qualify max(ingestion_datetime) over () = ingestion_datetime
)

select
    raw_data:review_id::text as review_id,
    raw_data:user_id::text as user_id,
    raw_data:business_id::text as business_id,
    raw_data:stars::int as stars,
    try_to_date(raw_data:date::text) as review_date,
    raw_data:text::text as review,
    raw_data:useful::int as useful_votes,
    raw_data:funny::int as funny_votes,
    raw_data:cool::int as cool_votes
from latest_data
