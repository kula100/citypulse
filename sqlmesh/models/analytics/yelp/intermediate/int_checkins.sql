MODEL (
    name yelp.int_checkins,
    kind EMBEDDED,
);

select
    business_id,
    f.value::timestamp as checkin_date
from raw_yelp.checkins,
lateral flatten(input => checkin_datetimes) as f
