MODEL (
    name yelp.dim_checkins,
    kind FULL,
    grains [business_id, checkin_date],
);

select
    business_id,
    checkin_date,
from yelp.int_checkins
