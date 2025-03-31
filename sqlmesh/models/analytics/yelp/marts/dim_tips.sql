MODEL (
    name yelp.dim_tips,
    kind FULL,
    grains [user_id, business_id, tip_date],
);

select
    user_id,
    business_id,
    tip_date,
    tip_msg,
    compliment_count
from raw_yelp.view_tips
where tip_date is not null
qualify row_number() over (partition by user_id, business_id, tip_date order by tip_date desc) = 1
