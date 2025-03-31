MODEL (
    name raw_yelp.view_users,
    kind VIEW,
    grain user_id,
);

with latest_data as (
    select raw_data
    from raw.yelp.raw_user
    qualify max(ingestion_datetime) over () = ingestion_datetime
)

select
    raw_data:user_id::text as user_id,
    raw_data:name::text as name,
    raw_data:review_count::int as review_count,
    raw_data:yelping_since::date as yelping_since,
    array_distinct(split(raw_data:friends::text, ', ')) as friends,
    raw_data:useful::int as useful_votes,
    raw_data:funny::int as funny_votes,
    raw_data:cool::int as cool_votes,
    raw_data:fans::int as fans,
    array_distinct(split(raw_data:elite::text, ',')) as elite_years,
    raw_data:average_stars::float as average_stars,
    raw_data:compliment_hot::int as compliment_hot,
    raw_data:compliment_more::int as compliment_more,
    raw_data:compliment_profile::int as compliment_profile,
    raw_data:compliment_cute::int as compliment_cute,
    raw_data:compliment_list::int as compliment_list,
    raw_data:compliment_note::int as compliment_note,
    raw_data:compliment_plain::int as compliment_plain,
    raw_data:compliment_cool::int as compliment_cool,
    raw_data:compliment_funny::int as compliment_funny,
    raw_data:compliment_writer::int as compliment_writer,
    raw_data:compliment_photos::int as compliment_photos
from latest_data
