{{
    config(
        materialized='table'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['user_id', 'friend_id']) }} as surrogate_key,
    user_id,
    friend_id,
    {{ executed_at() }}
from {{ ref('int_users_friends') }}
