{{
    config(
        materialized='ephemeral'
    )
}}

select
    user_id,
    value::text as friend_id
from {{ ref('users') }},
lateral flatten(input => friends) as f
