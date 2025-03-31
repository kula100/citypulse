MODEL (
    name yelp.int_users_friends,
    kind EMBEDDED,
);

select
    user_id,
    f.value::text as friend_id
from raw_yelp.users,
lateral flatten(input => friends) as f
