MODEL (
    name yelp.dim_reviews,
    kind FULL,
    grain review_id,
);

select
    review_id,
    user_id,
    business_id,
    stars,
    review_date,
    review,
    useful_votes,
    funny_votes,
    cool_votes,
from raw_yelp.reviews
